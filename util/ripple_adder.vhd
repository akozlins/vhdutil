library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity ripple_adder is
    generic (
        N   : integer := 8--;
    );
    port (
        a   :   in  std_logic_vector(N-1 downto 0);
        b   :   in  std_logic_vector(N-1 downto 0);
        s   :   out std_logic_vector(N-1 downto 0);
        ci  :   in  std_logic;
        co  :   out std_logic--;
    );
end entity ripple_adder;

architecture arch of ripple_adder is

    signal c_i : std_logic_vector(N downto 0);

begin

    c_i(0) <= ci;
    co <= c_i(N);

    gen : for i in 0 to N-1 generate
        full_adder_i : full_adder
        port map (
            a => a(i),
            b => b(i),
            s => s(i),
            ci => c_i(i),
            co => c_i(i+1)
        );
    end generate gen;

end;
