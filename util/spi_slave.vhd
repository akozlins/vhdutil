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

    -- sck clock
    signal sck, sck_q : std_logic;

    signal wfifo_rdata, rfifo_wdata : std_logic_vector(g_DATA_WIDTH-1 downto 0);
    signal wfifo_rack, wfifo_rempty, rfifo_we, rfifo_wfull : std_logic;

    signal data_index : integer range g_DATA_WIDTH-1 downto 0;

begin

    -- sync from serial to i_clk clock domain
    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        ss <= '0';
        ss_q <= '0';
        sck <= '0';
        sck_q <= '0';
        --
    elsif rising_edge(i_clk) then
        -- sample ss
        ss <= not i_ss_n;
        ss_q <= ss;
        -- sample sck
        sck <= i_sck xor i_cpol;
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



    o_sdo <=
        '-' when ( ss = '0' or wfifo_rempty = '1' ) else
        wfifo_rdata(data_index);

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        wfifo_rack <= '0';
        rfifo_we <= '0';
        --
    elsif rising_edge(i_clk) then
        wfifo_rack <= '0';
        rfifo_we <= '0';

        if ( ss = '1' ) then
            -- reset data_index on ss rising edge
            if ( ss_q = '0' ) then
                if ( i_sdo_cpha = '1' ) then
                    -- for CPHA = 1 first bit should be shifted on sck rising edge
                    data_index <= 0;
                else
                    data_index <= g_DATA_WIDTH-1;
                end if;
            end if;

            -- update sdo
            if ( (i_sdo_cpha = '0' and sck_q = '1' and sck = '0') or
                 (i_sdo_cpha = '1' and sck_q = '0' and sck = '1') ) then
                if ( data_index = 0 ) then
                    wfifo_rack <= '1';
                    rfifo_we <= '1';
                    data_index <= g_DATA_WIDTH-1;
                else
                    data_index <= data_index - 1;
                end if;
            end if;

            -- sample sdi
            if ( (i_sdi_cpha = '0' and sck_q = '0' and sck = '1') or
                 (i_sdi_cpha = '1' and sck_q = '1' and sck = '0') ) then
                rfifo_wdata(data_index) <= i_sdi;
            end if;
        end if;

        --
    end if;
    end process;

end architecture;
