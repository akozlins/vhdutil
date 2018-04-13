library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

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
