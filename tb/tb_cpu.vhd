library ieee;
use ieee.std_logic_1164.all;

entity tb_cpu is
end entity;

architecture arch of tb_cpu is

    constant CLK_MHZ : positive := 100;
    signal clk, reset_n : std_logic := '0';

begin

    clk <= not clk after (500 ns / CLK_MHZ);
    reset_n <= '0', '1' after 100 ns;

    i_cpu : entity work.rv32i_cpu_v1
    port map (
        dbg_out => open,
        dbg_in => (others => '0'),
        reset_n => reset_n,
        clk => clk--,
    );

end architecture;
