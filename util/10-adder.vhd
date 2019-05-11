--
-- Author: Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;

entity adder is
    generic (
        W   : positive := 8--;
    );
    port (
        a   :   in  std_logic_vector(W-1 downto 0);
        b   :   in  std_logic_vector(W-1 downto 0);
        ci  :   in  std_logic;
        s   :   out std_logic_vector(W-1 downto 0);
        co  :   out std_logic--;
    );
end entity;

library ieee;
use ieee.numeric_std.all;

architecture arch1 of adder is

    signal s_i : std_logic_vector(W downto 0);

begin

    s_i <= std_logic_vector(unsigned('0' & a) + unsigned(b) + ("" & ci));
    s <= s_i(s'range);
    co <= s_i(s_i'left);

end architecture;

library ieee;
use ieee.numeric_std.all;

architecture arch2 of adder is

    signal s_i : std_logic_vector(W+1 downto 0);

begin

    s_i <= std_logic_vector(unsigned('0' & a & '1') + unsigned('0' & b & ci));
    s <= s_i(W downto 1);
    co <= s_i(s_i'left);

end architecture;
