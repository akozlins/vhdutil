library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity alu is
    generic (
        W   : integer := 8--;
    );
    port (
        mux :   in  std_logic_vector(2 downto 0);
        a   :   in  std_logic_vector(W-1 downto 0);
        b   :   in  std_logic_vector(W-1 downto 0);
        z   :   out std_logic_vector(W-1 downto 0);
        ci  :   in  std_logic;
        co  :   out std_logic--;
    );
end entity alu;

architecture arch of alu is

    signal m2_i : std_logic_vector(W-1 downto 0);

    signal a_i : std_logic_vector(W-1 downto 0);
    signal b_i : std_logic_vector(W-1 downto 0);
    signal z_i : std_logic_vector(W downto 0);

begin

    m2_i <= (others => mux(2));

    a_i <= a xor m2_i;
    b_i <= b;

    adder_i : ripple_adder
    generic map (
        W => W
    )
    port map (
        a => a_i,
        b => b_i,
        s => z_i,
        ci => ci,
        co => co
    );

    z <= a_i and b_i when mux(1 downto 0) = "01" else
         a_i  or b_i when mux(1 downto 0) = "10" else
         a_i xor b_i when mux(1 downto 0) = "11" else
         z_i(W-1 downto 0);

end;
