--
-- author : Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
port (
    i_a : in    std_logic;
    i_b : in    std_logic;
    i_c : in    std_logic := '0';
    o_s : out   std_logic;
    o_c : out   std_logic--;
);
end entity;

architecture arch of full_adder is

    signal s1 : std_logic;
    signal c1 : std_logic;
    signal c2 : std_logic;

begin

    e_half_adder_1 : entity work.half_adder
    port map (
        i_a => i_a,
        i_b => i_b,
        o_s => s1,
        o_c => c1
    );

    e_half_adder_2 : entity work.half_adder
    port map (
        i_a => s1,
        i_b => i_c,
        o_s => o_s,
        o_c => c2
    );

    o_c <= c1 or c2;

end architecture;
