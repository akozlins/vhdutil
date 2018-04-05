library ieee;
use ieee.std_logic_1164.all;

package util is

    function bool_to_logic (
        constant b : in boolean--;
    ) return std_logic;



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

    component ram is
    generic (
        W   : integer := 8;
        N   : integer := 8;
        INIT_FILE_HEX : string := ""--;
    );
    port (
        clk     :   in  std_logic;
        addr    :   in  std_logic_vector(N-1 downto 0);
        dout    :   out std_logic_vector(W-1 downto 0);
        din     :   in  std_logic_vector(W-1 downto 0);
        we      :   in  std_logic--;
    );
    end component ram;

    component gray_counter is
    generic (
        W   : integer := 8--;
    );
    port (
        cnt     :   out std_logic_vector(W-1 downto 0);
        clk     :   in  std_logic;
        ena     :   in  std_logic;
        areset  :   in  std_logic--;
    );
    end component gray_counter;

    component cpu_v1 is
    port (
        reg15   :   out std_logic_vector(15 downto 0);
        clk     :   in  std_logic;
        areset  :   in  std_logic--;
    );
    end component cpu_v1;

    component reg_file is
    generic (
        W   : integer := 8;
        N   : integer := 2--;
    );
    port (
        clk     :   in  std_logic;
        a_addr  :   in  std_logic_vector(N-1 downto 0);
        b_addr  :   in  std_logic_vector(N-1 downto 0);
        c_addr  :   in  std_logic_vector(N-1 downto 0);
        a_dout  :   out std_logic_vector(W-1 downto 0);
        b_dout  :   out std_logic_vector(W-1 downto 0);
        c_dout  :   out std_logic_vector(W-1 downto 0);
        c_din   :   in  std_logic_vector(W-1 downto 0);
        c_we    :   in  std_logic;
        areset  :   in  std_logic--;
    );
    end component reg_file;

    component cpu_v2 is
    port (
        debug   :   out std_logic_vector(15 downto 0);
        clk     :   in  std_logic;
        areset  :   in  std_logic--;
    );
    end component cpu_v2;

end package util;

package body util is

    function bool_to_logic (
        constant b : in boolean--;
    ) return std_logic is
    begin
        if b then return '1';
             else return '0';
        end if;
    end function bool_to_logic;

end util;
