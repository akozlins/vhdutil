--
-- author : Alexandr Kozlinskiy
-- date : 2021-05-19
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- SPI slave
--
-- - ...
entity spi_slave is
generic (
    g_DATA_WIDTH        : positive := 8;
    g_FIFO_ADDR_WIDTH   : positive := 4;
    g_CLK_MHZ           : real--;
);
port (
    i_ss_n              : in    std_logic;
    i_sck               : in    std_logic;
    o_sdo               : out   std_logic;
    i_sdi               : in    std_logic;

    i_wdata             : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_we                : in    std_logic;
    o_wfull             : out   std_logic;

    o_rdata             : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_rack              : in    std_logic;
    o_rempty            : out   std_logic;

    -- clock polarity
    i_cpol              : in    std_logic := '0';
    -- clock phase (separate for sdo and sdi)
    -- - cpha = 0 -> sample on first clock transitions
    -- - cpha = 1 -> sample on second clock transition
    i_sdo_cpha          : in    std_logic := '0';
    i_sdi_cpha          : in    std_logic := '0';

    o_wfifo_rempty      : out   std_logic;

    i_reset_n           : in    std_logic;
    i_clk               : in    std_logic--;
);
end entity;

architecture arch of spi_slave is

    signal ss, ss_q : std_logic;
    signal sck, sck_q : std_logic;

    signal wfifo_rdata, wfifo_rdata_q, rfifo_wdata : std_logic_vector(g_DATA_WIDTH-1 downto 0);
    signal wfifo_rack, wfifo_rempty, rfifo_we, rfifo_wfull : std_logic;

    signal update_sdo, sample_sdo, sample_sdi : std_logic;

    signal sdo_cnt, sdi_cnt : integer range 0 to g_DATA_WIDTH-1;

    signal error_wfifo_uf : std_logic := '0';
    signal error_sdi_uf : std_logic := '0';
    signal error_rfifo_of : std_logic := '0';

begin

    ss <= not i_ss_n;
    sck <= i_sck xor i_cpol;

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        ss_q <= '0';
        sck_q <= '0';
        --
    elsif rising_edge(i_clk) then
        ss_q <= ss;
        sck_q <= sck;
        --
    end if;
    end process;



    -- write fifo (to sdo)
    e_wfifo : entity work.fifo_sc
    generic map (
        DATA_WIDTH_g => g_DATA_WIDTH,
        ADDR_WIDTH_g => g_FIFO_ADDR_WIDTH--,
    )
    port map (
        o_rdata         => wfifo_rdata,
        i_rack          => wfifo_rack,
        o_rempty        => wfifo_rempty,

        i_wdata         => i_wdata,
        i_we            => i_we,
        o_wfull         => o_wfull,

        i_reset_n       => i_reset_n,
        i_clk           => i_clk--;
    );

    o_wfifo_rempty <= wfifo_rempty;

    -- read fifo (from sdi)
    e_rfifo : entity work.fifo_sc
    generic map (
        DATA_WIDTH_g => g_DATA_WIDTH,
        ADDR_WIDTH_g => g_FIFO_ADDR_WIDTH--,
    )
    port map (
        o_rdata         => o_rdata,
        i_rack          => i_rack,
        o_rempty        => o_rempty,

        i_wdata         => rfifo_wdata,
        i_we            => rfifo_we,
        o_wfull         => rfifo_wfull,

        i_reset_n       => i_reset_n,
        i_clk           => i_clk--;
    );



    update_sdo <=
        -- cpha == 0 and riging_edge(ss)
        '1' when ( ss = '1' and i_sdo_cpha = '0' and ss_q = '0' ) else
        -- cpha == 0 and falling_edge(sck)
        '1' when ( ss = '1' and i_sdo_cpha = '0' and sck_q = '1' and sck = '0' ) else
        -- cpha == 1 and rising_edge(sck)
        '1' when ( ss = '1' and i_sdo_cpha = '1' and sck_q = '0' and sck = '1' ) else
        '0';

    sample_sdo <=
        -- cpha == 0 and rising_edge(sck)
        '1' when ( ss = '1' and i_sdo_cpha = '0' and sck_q = '0' and sck = '1' ) else
        -- cpha == 1 and falling_edge(sck)
        '1' when ( ss = '1' and i_sdo_cpha = '1' and sck_q = '1' and sck = '0' ) else
        '0';

    sample_sdi <=
        -- cpha == 0 and rising_edge(sck)
        '1' when ( ss = '1' and i_sdi_cpha = '0' and sck_q = '0' and sck = '1' ) else
        -- cpha == 1 and falling_edge(sck)
        '1' when ( ss = '1' and i_sdi_cpha = '1' and sck_q = '1' and sck = '0' ) else
        '0';

    o_sdo <= wfifo_rdata_q(g_DATA_WIDTH-1);

    wfifo_rack <= '1' when ( sample_sdo = '1' and sdo_cnt = 0 ) else '0';

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        rfifo_we <= '0';
        wfifo_rdata_q <= (others => '-');
        rfifo_wdata <= (others => '-');
        sdo_cnt <= 0;
        sdi_cnt <= 0;
        error_wfifo_uf <= '0';
        error_sdi_uf <= '0';
        error_rfifo_of <= '0';
        --
    elsif rising_edge(i_clk) then
        rfifo_we <= '0';

        -- reset
        if ( ss = '0' ) then
            wfifo_rdata_q <= (others => '-');
            rfifo_wdata <= (others => '-');
            sdo_cnt <= 0;
            sdi_cnt <= 0;
        end if;

        -- sdo
        if ( update_sdo = '1' ) then
            if ( sdo_cnt = 0 ) then
                if ( wfifo_rempty = '0' ) then
                    wfifo_rdata_q <= wfifo_rdata;
                else
                    wfifo_rdata_q <= (others => '-');
                end if;
            else
                wfifo_rdata_q <= wfifo_rdata_q(g_DATA_WIDTH-2 downto 0) & '-';
            end if;

            if ( sdo_cnt = g_DATA_WIDTH-1 ) then
                sdo_cnt <= 0;
            else
                sdo_cnt <= sdo_cnt + 1;
            end if;
        end if;

        -- wfifo underflow
        if ( wfifo_rack = '1' and wfifo_rempty = '1' ) then
            error_wfifo_uf <= '1';
        end if;

        -- sdi
        if ( sample_sdi = '1' ) then
            rfifo_wdata <= rfifo_wdata(g_DATA_WIDTH-2 downto 0) & i_sdi;
            if ( sdi_cnt = g_DATA_WIDTH-1 ) then
                rfifo_we <= '1';
                sdi_cnt <= 0;
            else
                sdi_cnt <= sdi_cnt + 1;
            end if;
        end if;

        -- sdi underflow
        if ( ss_q = '1' and ss = '0' and sdi_cnt /= 0 ) then
            rfifo_we <= '1';
            error_sdi_uf <= '1';
        end if;

        -- rfifo overflow
        if ( rfifo_we = '1' and rfifo_wfull = '1' ) then
            error_rfifo_of <= '1';
        end if;
        --
    end if;
    end process;

end architecture;
