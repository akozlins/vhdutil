library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
port (
    Arduino_IO13                : in    std_logic;
    Arduino_IO12                : out   std_logic;
    Arduino_IO11                : out   std_logic;
    Arduino_IO10                : out   std_logic;

    i_sw                        : in    std_logic_vector(4 downto 0);
    o_led_n                     : out   std_logic_vector(4 downto 0);

    i_reset_n                   : in    std_logic;
    i_clk_50                    : in    std_logic--;
);
end entity;

architecture arch of top is

    signal led                  : std_logic_vector(4 downto 0) := (others => '0');

    signal reset_50_n           : std_logic;

    signal clk_10_locked        : std_logic;
    signal clk_10               : std_logic;
    signal reset_10_n           : std_logic;

    signal nios_pio             : std_logic_vector(31 downto 0);

begin

    o_led_n <= not led or (led'range => i_clk_50);

    e_reset_50_n : entity work.reset_sync
    port map ( o_reset_n => reset_50_n, i_reset_n => i_reset_n, i_clk => i_clk_50 );

    e_clk_50_hz : entity work.clkdiv
    generic map (
        P => 50000000--,
    )
    port map (
        o_clk       => led(0),
        i_reset_n   => reset_50_n,
        i_clk       => i_clk_50--,
    );

    --- PLL ---
    e_pll_50to10 : entity work.ip_altpll
    port map (
        locked      => clk_10_locked,
        c0          => clk_10,
        areset      => not reset_50_n,
        inclk0      => i_clk_50--,
    );

    led(1) <= clk_10_locked;

    e_reset_10_n : entity work.reset_sync
    port map ( o_reset_n => reset_10_n, i_reset_n => i_reset_n, i_clk => clk_10 );

    e_clk_10_hz : entity work.clkdiv
    generic map (
        P => 10000000--,
    )
    port map (
        o_clk       => led(2),
        i_reset_n   => reset_10_n,
        i_clk       => clk_10--,
    );

    e_nios : component work.components.nios
    port map (
        adc_pll_clock_clk       => clk_10,
        adc_pll_locked_export   => clk_10_locked,

        spi_MISO                => Arduino_IO13,
        spi_MOSI                => Arduino_IO12,
        spi_SCLK                => Arduino_IO11,
        spi_SS_n                => Arduino_IO10,

        pio_export              => nios_pio,

        rst_reset_n             => reset_50_n,
        clk_clk                 => i_clk_50--,
    );

end architecture;
