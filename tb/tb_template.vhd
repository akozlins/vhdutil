--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_template is
end entity;

architecture arch of tb_template is

    constant CLK_MHZ : positive := 100;
    signal clk, reset_n : std_logic := '0';
    signal reset : std_logic;

begin

    clk <= not clk after (500 ns / CLK_MHZ);
    reset_n <= '0', '1' after 100 ns;
    reset <= not reset_n;

end architecture;
