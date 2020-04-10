library ieee;
use ieee.std_logic_1164.all;

entity top is
port (
    -- 8 light diods (active low)
    o_led_n     : out   std_logic_vector(7 downto 0);
    -- 4 switches
    i_sw_n      : in    std_logic_vector(3 downto 0);

    -- reset button (active low)
    i_reset_n   : in    std_logic;
    -- external clock
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of top is

    signal led : std_logic_vector(o_led_n'range) := (others => '0');

    signal clk, reset_n : std_logic;

    signal dbg : std_logic_vector(31 downto 0);

    component osch
    generic (
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

begin

    o_led_n <= not led;

    led(3 downto 0) <= not i_sw_n;

    -- internal 12.09 MHz oscillator
    e_osch : component osch
    port map (
        osc => clk--,
    );

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
        --
    end if;
    end process;



    e_cpu : entity work.rv32i_cpu_v1
    port map (
        dbg_out => dbg,
        dbg_in => (others => '0'),
        clk => clk,
        rst_n => reset_n--,
    );

end architecture;
