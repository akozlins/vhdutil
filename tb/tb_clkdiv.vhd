library ieee;
use ieee.std_logic_1164.all;

entity tb_clkdiv is
end entity;

architecture arch of tb_clkdiv is

    constant CLK_MHZ : positive := 100;
    signal clk, reset_n : std_logic := '0';

begin

    clk <= not clk after (500 ns / CLK_MHZ);
    reset_n <= '0', '1' after 100 ns;

    e_clkdiv : entity work.clkdiv
    generic map ( P => 5 )
    port map (
        o_clk => open,
        i_reset_n => reset_n,
        i_clk => clk--,
    );

end architecture;
