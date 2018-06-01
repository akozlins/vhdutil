library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clkdiv is
    generic (
        M   : positive := 1--;
    );
    port (
        clkout  :   out std_logic;
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of clkdiv is

    signal clkout1 : std_logic;

    constant W : integer := integer(ceil(log2(real(M))));
    signal cnt1 : unsigned(W-1 downto 0);

begin

    clkout <= clkout1;

    process(clk, rst_n)
    begin
    if rst_n = '0' then
        clkout1 <= '0';
        cnt1 <= (others => '0');
        --
    elsif rising_edge(clk) then
        cnt1 <= cnt1 + 1;
        if ( cnt1 = M - 1 ) then
            clkout1 <= not clkout1;
            cnt1 <= (others => '0');
        end if;
        --
    end if;
    end process;

end architecture;
