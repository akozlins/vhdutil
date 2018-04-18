library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity adder is
    generic (
        W   : integer := 8--;
    );
    port (
        a   :   in  std_logic_vector(W-1 downto 0);
        b   :   in  std_logic_vector(W-1 downto 0);
        ci  :   in  std_logic;
        s   :   out std_logic_vector(W-1 downto 0);
        co  :   out std_logic--;
    );
end entity;

architecture arch of adder is

    signal s_i : std_logic_vector(W downto 0);

begin

    s_i <= ('0' & a) + b + ci;
    s <= s_i(s'range);
    co <= s_i(W);

end architecture;

library UNISIM;
use UNISIM.vcomponents.all;

architecture rtl of adder is

    signal co_i : std_logic_vector(15 downto 0);
    signal ab : std_logic_vector(15 downto 0);

begin

    ab <= a xor b;
    co <= co_i(15);

    i_c0 : CARRY4
    port map (
        CO => co_i(3 downto 0),
        O => s(3 downto 0),
        CI => '0',
        CYINIT => ci,
        DI => a(3 downto 0),
        S => ab(3 downto 0)
    );

    i_c1 : CARRY4
    port map (
        CO => co_i(7 downto 4),
        O => s(7 downto 4),
        CI => co_i(3),
        CYINIT => '0',
        DI => a(7 downto 4),
        S => ab(7 downto 4)
    );

    i_c2 : CARRY4
    port map (
        CO => co_i(11 downto 8),
        O => s(11 downto 8),
        CI => co_i(7),
        CYINIT => '0',
        DI => a(11 downto 8),
        S => ab(11 downto 8)
    );

    i_c3 : CARRY4
    port map (
        CO => co_i(15 downto 12),
        O => s(15 downto 12),
        CI => co_i(11),
        CYINIT => '0',
        DI => a(15 downto 12),
        S => ab(15 downto 12)
    );

end architecture;
