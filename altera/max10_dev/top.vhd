library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
port (
    Arduino_IO13    : in    std_logic;
    Arduino_IO12    : out   std_logic;
    Arduino_IO11    : out   std_logic;
    Arduino_IO10    : out   std_logic;

    SWITCH1         : in    std_logic;
    SWITCH2         : in    std_logic;
    SWITCH3         : in    std_logic;
    SWITCH4         : in    std_logic;
    SWITCH5         : in    std_logic;

    LED1            : out   std_logic;
    LED2            : out   std_logic;
    LED3            : out   std_logic;
    LED4            : out   std_logic;
    LED5            : out   std_logic;

    RESET_N         : in    std_logic;
    CLOCK           : in    std_logic--; -- 50 MHz
);
end entity;

architecture arch of top is

    signal sw : std_logic_vector(4 downto 0);
    signal led : std_logic_vector(4 downto 0);

    signal nios_clk : std_logic; -- 50 MHz
    signal nios_reset_n : std_logic;

    signal adc_pll_clk : std_logic; -- 10 MHz
    signal adc_pll_locked : std_logic;

begin

    sw <= SWITCH5 & SWITCH4 & SWITCH3 & SWITCH2 & SWITCH1;

    LED1 <= not (led(0) and CLOCK);
    LED2 <= not (led(1) and CLOCK);
    LED3 <= not (led(2) and CLOCK);
    LED4 <= not (led(3) and CLOCK);
    LED5 <= not (led(4) and CLOCK);

    e_nios_reset_n : entity work.reset_sync
    port map ( o_reset_n => nios_reset_n, i_reset_n => reset_n, i_clk => nios_clk );

    e_nios_clk_hz : entity work.clkdiv
    generic map (
        P => 50000000--,
    )
    port map (
        o_clk       => led(0),
        i_reset_n   => nios_reset_n,
        i_clk       => nios_clk--,
    );

    --- PLL ---
    e_adc_pll_clk : entity work.ip_altpll
    port map (
        c0      => adc_pll_clk,
        c1      => nios_clk,
        locked  => adc_pll_locked,
        areset  => not reset_n,
        inclk0  => CLOCK--,
    );

    e_adc_pll_clk_hz : entity work.clkdiv
    generic map (
        P => 10000000--,
    )
    port map (
        o_clk       => led(1),
        i_reset_n   => nios_reset_n,
        i_clk       => adc_pll_clk--,
    );

    led(2) <= adc_pll_locked;

    e_nios : component work.components.nios
    port map (
        adc_pll_clock_clk       => adc_pll_clk,
        adc_pll_locked_export   => adc_pll_locked,

        spi_MISO    => Arduino_IO13,
        spi_MOSI    => Arduino_IO12,
        spi_SCLK    => Arduino_IO11,
        spi_SS_n    => Arduino_IO10,

        rst_reset_n => nios_reset_n,
        clk_clk     => nios_clk--,
    );

end architecture;
