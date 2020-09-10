--
-- author : Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reset_ctrl is
generic (
    W : positive := 1;
    N : positive := 16#FFFF#--;
);
port (
    rstout_n    : out   std_logic_vector(W-1 downto 0);

    rst_n       : in    std_logic;
    clk         : in    std_logic--;
);
end entity;

architecture arch of reset_ctrl is

    signal ff0 : std_logic_vector(rstout_n'range);
    signal cnt : integer range 0 to N;

begin

    rstout_n <= ff0;

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        ff0 <= (others => '0');
        cnt <= 0;
        --
    elsif rising_edge(clk) then
        if cnt = N then
            ff0 <= work.util.shift_right(ff0, 1);
            ff0(ff0'left) <= '1';
            cnt <= 0;
        else
            cnt <= cnt + 1;
        end if;
    end if;
    end process;

end architecture;
