library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util.all;

entity full_adder is
    port (
        a   :   in  std_logic;
        b   :   in  std_logic;
        ci  :   in  std_logic;
        s   :   out std_logic;
        co  :   out std_logic--;
    );
end entity full_adder;

architecture arch of full_adder is

    signal s_1 : std_logic;
    signal c_1 : std_logic;
    signal c_2 : std_logic;

begin

    half_adder_1 : half_adder
    port map (
        a => a,
        b => b,
        s => s_1,
        c => c_1
    );

    half_adder_2 : half_adder
    port map (
        a => s_1,
        b => ci,
        s => s,
        c => c_2
    );

    co <= c_1 or c_2;

end;
