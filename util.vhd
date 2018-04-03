library ieee;
use ieee.std_logic_1164.all;

package util is

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

    component half_adder is
    port (
        a   :   in  std_logic;
        b   :   in  std_logic;
        s   :   out std_logic;
        c   :   out std_logic--;
    );
    end component half_adder;

    component full_adder is
    port (
        a   :   in  std_logic;
        b   :   in  std_logic;
        s   :   out std_logic;
        ci  :   in  std_logic;
        co  :   out std_logic--;
    );
    end component full_adder;

    component ripple_adder is
    generic (
        W   : integer := 8--;
    );
    port (
        a   :   in  std_logic_vector(W-1 downto 0);
        b   :   in  std_logic_vector(W-1 downto 0);
        s   :   out std_logic_vector(W-1 downto 0);
        ci  :   in  std_logic;
        co  :   out std_logic--;
    );
    end component ripple_adder;

    component alu is
    generic (
        W   : integer := 8--;
    );
    port (
        s0  :   in  std_logic;
        s1  :   in  std_logic;
        s2  :   in  std_logic;
        a   :   in  std_logic_vector(W-1 downto 0);
        b   :   in  std_logic_vector(W-1 downto 0);
        z   :   out std_logic_vector(W-1 downto 0);
        ci  :   in  std_logic;
        co  :   out std_logic--;
    );
    end component alu;

end package util;
