--
-- author : Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;

entity adder is
generic (
    W   : positive := 8--;
);
port (
    i_a : in    std_logic_vector(W-1 downto 0);
    i_b : in    std_logic_vector(W-1 downto 0);
    i_c : in    std_logic := '0';
    o_s : out   std_logic_vector(W-1 downto 0);
    o_c : out   std_logic--;
);
end entity;

library ieee;
use ieee.numeric_std.all;

architecture arch1 of adder is

    signal s : std_logic_vector(W downto 0);

begin

    s <= std_logic_vector(unsigned('0' & i_a) + unsigned(i_b) + ("" & i_c));
    o_s <= s(o_s'range);
    o_c <= s(s'left);

end architecture;

library ieee;
use ieee.numeric_std.all;

architecture arch2 of adder is

    signal s : std_logic_vector(W+1 downto 0);

begin

    s <= std_logic_vector(unsigned('0' & i_a & '1') + unsigned('0' & i_b & i_c));
    o_s <= s(W downto 1);
    o_c <= s(s'left);

end architecture;
