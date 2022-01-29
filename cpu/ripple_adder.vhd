--
-- author : Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;

entity ripple_adder is
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

architecture arch of ripple_adder is

    signal c : std_logic_vector(W downto 0);

begin

    c(0) <= i_c;
    o_c <= c(W);

    g_full_adder :
    for i in o_s'range generate
        e_full_adder : entity work.full_adder
        port map (
            i_a => i_a(i),
            i_b => i_b(i),
            i_c => c(i),
            o_s => o_s(i),
            o_c => c(i+1)
        );
    end generate;

end architecture;
