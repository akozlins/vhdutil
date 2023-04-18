library ieee;
use ieee.std_logic_1164.all;

entity top is
port (
    o_led       : out   std_logic_vector(7 downto 0);
    i_btn       : in    std_logic_vector(4 downto 0);
    i_sw        : in    std_logic_vector(7 downto 0);

    i_clk_100   : in    std_logic--;
);
end entity;

architecture arch of top is

    signal reset_100_n : std_logic;

    signal debug : std_logic_vector(31 downto 0);

begin

    e_reset_100_n : entity work.reset_sync
    port map ( o_reset_n => reset_100_n, i_reset_n => not i_btn(0), i_clk => i_clk_100 );

    process(i_clk_100, reset_100_n)
    begin
    if ( reset_100_n = '1' ) then
        o_led <= (others => '0');
        --
    elsif rising_edge(i_clk_100) then
        o_led <= i_sw;
        o_led(0) <= work.util.xor_reduce(debug);
        --
    end if;
    end process;

    e_cpu : entity work.rv32i_cpu_v1
    port map (
        o_debug => debug,
        i_reset_n => reset_100_n,
        i_clk => i_clk_100--,
    );

end architecture;
