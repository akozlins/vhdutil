library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_adder is
end entity;

architecture arch of tb_adder is

    constant CLK_MHZ : positive := 1000;
    signal clk, reset_n : std_logic := '0';

    signal a, b, s : std_logic_vector(7 downto 0);
    signal ci, co : std_logic;

    signal i : std_logic_vector(a'length + b'length downto 0);

begin

    clk <= not clk after (500 ns / CLK_MHZ);
    reset_n <= '0', '1' after 100 ns;

    i_adder : entity work.ripple_adder
    generic map ( W => s'length )
    port map (
        a   => a,
        b   => b,
        ci  => ci,
        s   => s,
        co  => co--,
    );

    a <= i(a'length-1 downto 0);
    b <= work.util.shift_right(i, a'length)(b'length-1 downto 0);
    ci <= i(i'left);

    process(clk, reset_n)
    begin
    if ( reset_n = '0' ) then
        i <= (others => '0');
    elsif rising_edge(clk) then
        assert ( unsigned(co & s) = unsigned('0' & a) + unsigned(b) + ("" & ci) ) severity failure;

        i <= std_logic_vector(unsigned(i) + 1);
    end if;
    end process;

end architecture;
