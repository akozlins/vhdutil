library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util.all;

entity alu_v1 is
    generic (
        W   : integer := 8--;
    );
    port (
        mux :   in  std_logic_vector(2 downto 0);
        a   :   in  std_logic_vector(W-1 downto 0);
        b   :   in  std_logic_vector(W-1 downto 0);
        ci  :   in  std_logic;
        y   :   out std_logic_vector(W-1 downto 0);
        co  :   out std_logic--;
    );
end entity;

architecture arch of alu_v1 is

    signal m2_i : std_logic_vector(W-1 downto 0);

    signal a_i, b_i, s_i : std_logic_vector(W-1 downto 0);

begin

    m2_i <= (others => mux(2));

    a_i <= a xor m2_i;
    b_i <= b;

    i_adder : component adder
    generic map (
        W => W--,
    )
    port map (
        a => a_i,
        b => b_i,
        ci => ci,
        s => s_i,
        co => co--,
    );

    y <= a_i and b_i when mux(1 downto 0) = "01" else
         a_i  or b_i when mux(1 downto 0) = "10" else
         a_i xor b_i when mux(1 downto 0) = "11" else
         s_i;

end architecture;
