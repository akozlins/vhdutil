--

library ieee;
use ieee.std_logic_1164.all;

entity top is
port (
    -- 8 light diods (active low)
    o_led_n     : out   std_logic_vector(7 downto 0) := (others => '1');
    -- 4 switches
    i_sw_n      : in    std_logic_vector(3 downto 0);

    -- uart interface (install resistors R14 and R15)
    i_rs232_rx  : in    std_logic;
    o_rs232_tx  : out   std_logic := '1';

    -- external clock (12 MHz)
    i_clk       : in    std_logic;
    -- reset button (active low)
    i_reset_n   : in    std_logic--;
);
end entity;

architecture arch of top is

    signal clk, reset_n : std_logic;

    ----------------------------------------------------------------
    -- OSCH is the primitive of internal (on-chip) oscillator
    component OSCH
    generic (
        -- the frequency is 12.09 MHz
        NOM_FREQ : string := "12.09"--;
    );
    port (
        stdby : in std_logic := '0';
        sedstdby : out std_logic;
        osc : out std_logic--;
    );
    end component;
    attribute NOM_FREQ : string;
    attribute NOM_FREQ of e_osch : label is "12.09";
    signal osc : std_logic;
    ----------------------------------------------------------------

    signal led : std_logic_vector(o_led_n'range) := (others => '0');
    signal sw : std_logic_vector(i_sw_n'range);

    signal dbg : std_logic_vector(31 downto 0);

begin

    -- instantiate internal oscillator entity (primitive)
    e_osch : component OSCH port map ( sedstdby => open, osc => osc );
    clk <= i_clk;

    -- output led's are active low
    o_led_n <= not led;
    -- input switches are active low
    sw <= not i_sw_n;

    led(3 downto 0) <= not i_sw_n;

    -- generate reset for clock 'clk'
    e_reset_n : entity work.reset_sync
    port map ( o_reset_n => reset_n, i_reset_n => i_reset_n, i_clk => clk );

    e_clk_hz : entity work.clkdiv
    generic map ( p => 12000000 )
    port map ( o_clk => led(7), i_reset_n => reset_n, i_clk => clk );

    process(clk, reset_n)
    begin
    if ( reset_n = '0' ) then
        --
    elsif rising_edge(clk) then
        o_rs232_tx <= i_rs232_rx;
        --
    end if;
    end process;



--    e_cpu : entity work.rv32i_cpu_v1
--    port map (
--        o_debug => dbg,
--        i_clk => clk,
--        i_reset_n => reset_n--,
--    );

end architecture;
