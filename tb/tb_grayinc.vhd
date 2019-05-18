library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_grayinc is
end entity;

architecture arch of tb_grayinc is

    constant CLK_MHZ : positive := 100;
    signal clk, rst_n : std_logic := '0';

    signal i : unsigned(7 downto 0);
    signal g1, g2 : std_logic_vector(7 downto 0);

begin

    clk <= not clk after (500 ns / CLK_MHZ);
    rst_n <= '0', '1' after 100 ns;

    g1 <= work.util.bin2gray(std_logic_vector(i));

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        i <= (others => '0');
        g2 <= (others => '0');
        --
    elsif rising_edge(clk) then
        report "i = " & work.util.to_string(i);
        report "g1 = " & work.util.to_string(g1);
        report "g2 = " & work.util.to_string(g2);
        assert ( g1 = g2 ) severity failure;

        i <= i + 1;
        g2 <= work.util.grayinc(g2);
        --
    end if; -- rising_edge
    end process;

end architecture;
