--
-- author : Alexandr Kozlinskiy
-- date : 2021-05-18
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- SPI master
--
-- - ...
entity spi_master is
generic (
    g_DATA_WIDTH        : positive := 8;
    g_FIFO_ADDR_WIDTH   : positive := 4;
    g_CLK_MHZ           : real--;
);
port (
    i_wdata     : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_we        : in    std_logic;
    o_wfull     : out   std_logic;

    o_rdata     : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_rack      : in    std_logic;
    o_rempty    : out   std_logic;

    o_ss_n      : out   std_logic;
    o_sck       : out   std_logic;
    o_mosi      : out   std_logic;
    i_miso      : in    std_logic;

    -- number of cycles between sck clock transitions
    i_sck_div   : in    std_logic_vector(15 downto 0) := (others => '0');
    -- clock polarity
    i_cpol      : in    std_logic := '0';
    -- clock phase (separate for mosi and miso)
    -- - cpha = 0 -> sample on first clock transitions
    -- - cpha = 1 -> sample on second clock transition
    i_mosi_cpha : in    std_logic := '0';
    i_miso_cpha : in    std_logic := '0';

    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of spi_master is

    signal ss, ss_q : std_logic;

    -- sck clock
    signal sck, sck_i, sck_q : std_logic;
    signal sck_cnt : unsigned(15 downto 0);

    signal fifo_rdata, fifo_wdata : std_logic_vector(g_DATA_WIDTH-1 downto 0);
    signal fifo_rack, fifo_rempty, fifo_we, fifo_wfull : std_logic;
    signal data_index : integer range g_DATA_WIDTH-1 downto 0;

begin

    o_ss_n <= not ss;

    -- clock polarity
    o_sck <= sck xor i_cpol;

    -- generate clock (sck) and slave select (ss)
    process(i_clk)
    begin
    if ( i_reset_n = '0' ) then
        ss <= '0';
        sck <= '0';
        sck_i <= '0';
        sck_cnt <= (others => '0');
        --
    elsif rising_edge(i_clk) then
        if ( sck_cnt = unsigned(i_sck_div) ) then
            -- set ss on falling edge
            if ( sck_i = '1' and fifo_rempty = '0' ) then
                ss <= '1';
            end if;
            -- reset ss on rising edge
            if ( sck_i = '0' and fifo_rempty = '1' ) then
                ss <= '0';
            end if;

            if ( ss = '1' ) then
                sck <= not sck;
            end if;

            sck_i <= not sck_i;
            sck_cnt <= (others => '0');
        else
            sck_cnt <= sck_cnt + 1;
        end if;
        --
    end if;
    end process;



    e_mosi_fifo : entity work.fifo_sc
    generic map (
        DATA_WIDTH_g => g_DATA_WIDTH,
        ADDR_WIDTH_g => g_FIFO_ADDR_WIDTH--,
    )
    port map (
        o_rdata         => fifo_rdata,
        i_rack          => fifo_rack,
        o_rempty        => fifo_rempty,

        i_wdata         => i_wdata,
        i_we            => i_we,
        o_wfull         => o_wfull,

        i_reset_n       => i_reset_n,
        i_clk           => i_clk--;
    );

    e_miso_fifo : entity work.fifo_sc
    generic map (
        DATA_WIDTH_g => g_DATA_WIDTH,
        ADDR_WIDTH_g => g_FIFO_ADDR_WIDTH--,
    )
    port map (
        o_rdata         => o_rdata,
        i_rack          => i_rack,
        o_rempty        => o_rempty,

        i_wdata         => fifo_wdata,
        i_we            => fifo_we,
        o_wfull         => fifo_wfull,

        i_reset_n       => i_reset_n,
        i_clk           => i_clk--;
    );



    o_mosi <=
        '-' when ( ss = '0' or fifo_rempty = '1' ) else
        fifo_rdata(data_index);

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        ss_q <= '0';
        sck_q <= '0';
        fifo_rack <= '0';
        fifo_we <= '0';
        --
    elsif rising_edge(i_clk) then
        ss_q <= ss;
        sck_q <= sck;
        fifo_rack <= '0';
        fifo_we <= '0';

        if ( ss = '1' ) then
            -- reset data_index on ss rising edge
            if ( ss_q = '0' ) then
                if ( i_mosi_cpha = '1' ) then
                    -- for CPHA = 1 first bit should be shifted on sck rising edge
                    data_index <= 0;
                else
                    data_index <= g_DATA_WIDTH-1;
                end if;
            end if;

            -- update mosi
            if ( (i_mosi_cpha = '0' and sck_q = '1' and sck = '0') or
                 (i_mosi_cpha = '1' and sck_q = '0' and sck = '1') ) then
                if ( data_index = 0 ) then
                    fifo_rack <= '1';
                    fifo_we <= '1';
                    data_index <= g_DATA_WIDTH-1;
                else
                    data_index <= data_index - 1;
                end if;
            end if;

            -- sample miso
            if ( (i_miso_cpha = '0' and sck_q = '0' and sck = '1') or
                 (i_miso_cpha = '1' and sck_q = '1' and sck = '0') ) then
                fifo_wdata(data_index) <= i_miso;
                -- TODO: fifo_we
            end if;
        end if;
        --
    end if;
    end process;

end architecture;
