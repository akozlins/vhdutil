library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

package util is

    function bool_to_logic (
        constant b : in boolean--;
    ) return std_logic;

    procedure char_to_hex(
        c : in character;
        v : out std_logic_vector(3 downto 0);
        good : out boolean--;
    );

    procedure string_to_hex(
        s : in string;
        v : out std_logic_vector;
        good : out boolean--;
    );



    component debounce is
    generic (
        N : integer := 1;
        C : unsigned := X"FFFF"--;
    );
    port (
        input   :   in  std_logic_vector(N-1 downto 0);
        output  :   out std_logic_vector(N-1 downto 0);
        clk     :   in  std_logic--;
    );
    end component;

    component gray_counter is
    generic (
        W   : integer := 8--;
    );
    port (
        cnt     :   out std_logic_vector(W-1 downto 0);
        ce      :   in  std_logic;
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
    end component;

    component half_adder is
    port (
        a   :   in  std_logic;
        b   :   in  std_logic;
        s   :   out std_logic;
        c   :   out std_logic--;
    );
    end component;

    component full_adder is
    port (
        a   :   in  std_logic;
        b   :   in  std_logic;
        ci  :   in  std_logic;
        s   :   out std_logic;
        co  :   out std_logic--;
    );
    end component;

    component ripple_adder is
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
    end component;

    component adder is
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
    end component;

    component alu_v2 is
    generic (
        W   : integer := 8--;
    );
    port (
        -- operands
        a   :   in  std_logic_vector(W-1 downto 0);
        b   :   in  std_logic_vector(W-1 downto 0);
        -- carry in
        ci  :   in  std_logic;
        -- operation
        op  :   in  std_logic_vector(2 downto 0);
        -- output
        y   :   out std_logic_vector(W-1 downto 0);
        -- zero
        z   :   out std_logic;
        -- sign
        s   :   out std_logic;
        -- overflow
        v   :   out std_logic;
        -- carry out
        co  :   out std_logic--;
    );
    end component;

    component ram_v1 is
    generic (
        W   : integer := 8;
        N   : integer := 8;
        INIT_FILE_HEX : string := ""--;
    );
    port (
        addr    :   in  std_logic_vector(N-1 downto 0);
        rd      :   out std_logic_vector(W-1 downto 0);
        wd      :   in  std_logic_vector(W-1 downto 0);
        we      :   in  std_logic;
        clk     :   in  std_logic--;
    );
    end component;

    component ram_v3 is
    generic (
        W   : integer := 8;
        N   : integer := 8;
        INIT_FILE_HEX : string := ""--;
    );
    port (
        a_addr  :   in  std_logic_vector(N-1 downto 0);
        a_rd    :   out std_logic_vector(W-1 downto 0);
        b_addr  :   in  std_logic_vector(N-1 downto 0);
        b_rd    :   out std_logic_vector(W-1 downto 0);
        b_wd    :   in  std_logic_vector(W-1 downto 0);
        b_we    :   in  std_logic;
        clk     :   in  std_logic--;
    );
    end component;

    component reg_file_v1 is
    generic (
        W   : integer := 8;
        N   : integer := 2--;
    );
    port (
        a_addr  :   in  std_logic_vector(N-1 downto 0);
        a_rd    :   out std_logic_vector(W-1 downto 0);
        b_addr  :   in  std_logic_vector(N-1 downto 0);
        b_rd    :   out std_logic_vector(W-1 downto 0);
        c_addr  :   in  std_logic_vector(N-1 downto 0);
        c_rd    :   out std_logic_vector(W-1 downto 0);
        c_wd    :   in  std_logic_vector(W-1 downto 0);
        c_we    :   in  std_logic;
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
    end component;

    component reg_file_v3 is
    generic (
        W   : integer := 8; -- word width in bits
        N   : integer := 2--; -- addr bits (2**N words)
    );
    port (
        a_addr  :   in  std_logic_vector(N-1 downto 0);
        a_rd    :   out std_logic_vector(W-1 downto 0);
        b_addr  :   in  std_logic_vector(N-1 downto 0);
        b_rd    :   out std_logic_vector(W-1 downto 0);
        b_wd    :   in  std_logic_vector(W-1 downto 0);
        b_we    :   in  std_logic;
        clk     :   in  std_logic--;
    );
    end component;

    component cpu_v1 is
    port (
        dbg_out :   out std_logic_vector(31 downto 0);
        dbg_in  :   in  std_logic_vector(31 downto 0);
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
    end component;

    component cpu_v2 is
    port (
        dbg_out :   out std_logic_vector(31 downto 0);
        dbg_in  :   in  std_logic_vector(31 downto 0);
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
    end component;

    component cpu_v3 is
    port (
        dbg_out :   out std_logic_vector(31 downto 0);
        dbg_in  :   in  std_logic_vector(31 downto 0);
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
    end component;

    component cpu_v4 is
    port (
        dbg_out :   out std_logic_vector(31 downto 0);
        dbg_in  :   in  std_logic_vector(31 downto 0);
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
    end component;

end package;

package body util is

    function bool_to_logic (
        constant b : in boolean--;
    ) return std_logic is
    begin
        if b then
            return '1';
        else
            return '0';
        end if;
    end function;

    procedure char_to_hex(
        c : in character;
        v : out std_logic_vector(3 downto 0);
        good : out boolean--;
    ) is
    begin
        good := true;
        case c is
        when '0' => v := X"0";
        when '1' => v := X"1";
        when '2' => v := X"2";
        when '3' => v := X"3";
        when '4' => v := X"4";
        when '5' => v := X"5";
        when '6' => v := X"6";
        when '7' => v := X"7";
        when '8' => v := X"8";
        when '9' => v := X"9";

        when 'a' | 'A' => v := X"A";
        when 'b' | 'B' => v := X"B";
        when 'c' | 'C' => v := X"C";
        when 'd' | 'D' => v := X"D";
        when 'e' | 'E' => v := X"E";
        when 'f' | 'F' => v := X"F";

        when others =>
           assert false report "ERROR char_to_hex: invalid hex character '" & c & "'";
           good := false;
        end case;
    end procedure;

    procedure string_to_hex(
        s : in string;
        v : out std_logic_vector;
        good : out boolean--;
    ) is
        variable ok : boolean;
    begin
        good := false;
        for i in 0 to s'length-1 loop
            char_to_hex(s(s'length-i), v(4*i+3 downto 4*i), ok);
            if not ok then
                return;
            end if;
        end loop;
        good := true;
    end procedure;

end package body;
