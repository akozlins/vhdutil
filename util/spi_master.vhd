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
    g_N                 : positive := 32;
    g_DATA_WIDTH        : positive := 8;
    g_FIFO_ADDR_WIDTH   : positive := 4--;
);
port (
    o_sclk      : out   std_logic;
    o_sdo       : out   std_logic;
    i_sdi       : in    std_logic;
    o_ss_n      : out   std_logic;

    i_wdata     : in    std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_we        : in    std_logic;
    o_wfull     : out   std_logic;

    o_rdata     : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_rack      : in    std_logic;
    o_rempty    : out   std_logic;

    -- sck clock divider (cycles between clock transitions)
    i_sclk_div  : in    std_logic_vector(15 downto 0) := (others => '0');
    -- clock polarity
    i_cpol      : in    std_logic := '0';
    -- clock phase (separate for sdo and sdi)
    i_sdo_cpha  : in    std_logic := '0';
    i_sdi_cpha  : in    std_logic := '0';

    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of spi_master is

    signal ss : std_logic;
    signal sclk, sclk_i : std_logic;
    signal sclk_cnt : unsigned(15 downto 0);

    signal wfifo_rempty : std_logic;

begin

    -- clock polarity
    o_sclk <= sclk xor i_cpol;

    -- generate clock (sclk) and slave select (ss)
    process(i_clk)
    begin
    if ( i_reset_n = '0' ) then
        ss <= '0';
        sclk <= '0';
        sclk_i <= '0';
        sclk_cnt <= (others => '0');
        --
    elsif rising_edge(i_clk) then
        if ( sclk_cnt >= unsigned(i_sclk_div) ) then
            -- set ss on falling edge
            if ( sclk_i = '1' and wfifo_rempty = '0' ) then
                ss <= '1';
            end if;
            -- reset ss on rising edge
            if ( sclk_i = '0' and wfifo_rempty = '1' ) then
                ss <= '0';
            elsif ( ss = '1' ) then
                sclk <= not sclk;
            end if;

            sclk_i <= not sclk_i;
            sclk_cnt <= (others => '0');
        else
            sclk_cnt <= sclk_cnt + 1;
        end if;
        --
    end if;
    end process;

    e_spi_slave : entity work.spi_slave
    generic map (
        g_DATA_WIDTH => g_DATA_WIDTH,
        g_FIFO_ADDR_WIDTH => g_FIFO_ADDR_WIDTH--,
    )
    port map (
        i_sclk => sclk,
        o_sdo => o_sdo,
        i_sdi => i_sdi,
        i_ss_n => not ss,

        i_wdata => i_wdata,
        i_we => i_we,
        o_wfull => o_wfull,

        o_rdata => o_rdata,
        i_rack => i_rack,
        o_rempty => o_rempty,

        i_cpol => '0',
        i_sdo_cpha => i_sdo_cpha,
        i_sdi_cpha => i_sdi_cpha,

        o_wfifo_rempty => wfifo_rempty,

        i_reset_n => i_reset_n,
        i_clk => i_clk--,
    );

end architecture;
