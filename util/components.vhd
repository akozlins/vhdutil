library ieee;
use ieee.std_logic_1164.all;

package components is

    component debounce is
    generic (
        N : integer := 1;
        C : std_logic_vector := X"FFFF"--;
    );
    port (
        input   :   in  std_logic_vector(N-1 downto 0);
        output  :   out std_logic_vector(N-1 downto 0);
        clk     :   in  std_logic--;
    );
    end component debounce;

end package components;
