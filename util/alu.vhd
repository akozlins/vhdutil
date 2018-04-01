library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity alu is
    generic (
        N   : integer := 8--;
    );
    port (
        s0  :   in  std_logic;
        s1  :   in  std_logic;
        s2  :   in  std_logic;
        a   :   in  std_logic_vector(N-1 downto 0);
        b   :   in  std_logic_vector(N-1 downto 0);
        z   :   out std_logic_vector(N-1 downto 0);
        ci  :   in  std_logic;
        co  :   out std_logic--;
    );
end entity alu;

architecture arch of alu is

    signal a_i : std_logic_vector(N-1 downto 0);
    signal b_i : std_logic_vector(N-1 downto 0);

    signal s0_i : std_logic_vector(N-1 downto 0);
    signal s1_i : std_logic_vector(N-1 downto 0);
    signal s2_i : std_logic_vector(N-1 downto 0);

begin

    adder_i : ripple_adder
    generic map (
        N => N
    )
    port map (
        a => a_i,
        b => b_i,
        s => z,
        ci => ci,
        co => co
    );

    s0_i <= (others => s0);
    s1_i <= (others => s1);
    s2_i <= (others => s2);

    a_i <= a and (b or s0_i);
    b_i <= (b or s1_i) xor s2_i;

end;
