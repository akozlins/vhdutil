--
-- author : Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;

entity half_adder is
port (
    i_a : in    std_logic;
    i_b : in    std_logic;
    o_s : out   std_logic;
    o_c : out   std_logic--;
);
end entity;

architecture arch of half_adder is
begin

    o_s <= i_a xor i_b;
    o_c <= i_a and i_b;

end architecture;
