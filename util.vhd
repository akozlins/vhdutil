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
        result : out std_logic_vector(3 downto 0);
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
    end component debounce;

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

    component alu_v1 is
    generic (
        W   : integer := 8--;
    );
    port (
        mux :   in  std_logic_vector(2 downto 0);
        a   :   in  std_logic_vector(W-1 downto 0);
        b   :   in  std_logic_vector(W-1 downto 0);
        z   :   out std_logic_vector(W-1 downto 0);
        ci  :   in  std_logic;
        co  :   out std_logic--;
    );
    end component alu_v1;

    component alu_v2 is
    generic (
        W   : integer := 8--;
    );
    port (
        -- carry in
        ci  :   in  std_logic;
        -- operands
        a   :   in  std_logic_vector(W-1 downto 0);
        b   :   in  std_logic_vector(W-1 downto 0);
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
    end component alu_v2;

    component ram_v1 is
    generic (
        W   : integer := 8;
        N   : integer := 8;
        INIT_FILE_HEX : string := ""--;
    );
    port (
        clk     :   in  std_logic;
        addr    :   in  std_logic_vector(N-1 downto 0);
        rd      :   out std_logic_vector(W-1 downto 0);
        wd      :   in  std_logic_vector(W-1 downto 0);
        we      :   in  std_logic--;
    );
    end component ram_v1;

    component ram_v3 is
    generic (
        W   : integer := 8;
        N   : integer := 8;
        INIT_FILE_HEX : string := ""--;
    );
    port (
        clk     :   in  std_logic;
        raddr   :   in  std_logic_vector(N-1 downto 0);
        rd      :   out std_logic_vector(W-1 downto 0);
        waddr   :   in  std_logic_vector(N-1 downto 0);
        wd      :   in  std_logic_vector(W-1 downto 0);
        we      :   in  std_logic--;
    );
    end component ram_v3;

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

    component reg_file_v3 is
    generic (
        W   : integer := 8; -- word width in bits
        N   : integer := 2--; -- addr bits (2**N words)
    );
    port (
        a_addr  :   in  std_logic_vector(N-1 downto 0);
        b_addr  :   in  std_logic_vector(N-1 downto 0);
        a_rd    :   out std_logic_vector(W-1 downto 0);
        b_rd    :   out std_logic_vector(W-1 downto 0);
        b_wd    :   in  std_logic_vector(W-1 downto 0);
        b_we    :   in  std_logic;
        clk     :   in  std_logic--;
    );
    end component reg_file_v3;

    component cpu_v1 is
    port (
        reg15   :   out std_logic_vector(15 downto 0);
        clk     :   in  std_logic;
        areset  :   in  std_logic--;
    );
    end component cpu_v1;

    component cpu_v2 is
    port (
        dbg_out :   out std_logic_vector(31 downto 0);
        dbg_in  :   in  std_logic_vector(31 downto 0);
        clk     :   in  std_logic;
        areset  :   in  std_logic--;
    );
    end component cpu_v2;

    component cpu_v3 is
    port (
        dbg_out :   out std_logic_vector(31 downto 0);
        dbg_in  :   in  std_logic_vector(31 downto 0);
        clk     :   in  std_logic;
        areset  :   in  std_logic--;
    );
    end component cpu_v3;

end package util;

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
    end function bool_to_logic;

    procedure char_to_hex(
        c : in character;
        result : out std_logic_vector(3 downto 0);
        good : out boolean--;
    ) is
    begin
        good := true;
        case c is
        when '0' => result := X"0";
        when '1' => result := X"1";
        when '2' => result := X"2";
        when '3' => result := X"3";
        when '4' => result := X"4";
        when '5' => result := X"5";
        when '6' => result := X"6";
        when '7' => result := X"7";
        when '8' => result := X"8";
        when '9' => result := X"9";

        when 'A' => result := X"A";
        when 'B' => result := X"B";
        when 'C' => result := X"C";
        when 'D' => result := X"D";
        when 'E' => result := X"E";
        when 'F' => result := X"F";

        when 'a' => result := X"A";
        when 'b' => result := X"B";
        when 'c' => result := X"C";
        when 'd' => result := X"D";
        when 'e' => result := X"E";
        when 'f' => result := X"F";
        when others =>
           assert false report "HREAD Error: Read a '" & c & "', expected a Hex character (0-F).";
           good := false;
        end case;
    end char_to_hex;

    procedure string_to_hex(
        s : in string;
        v : out std_logic_vector;
        good : out boolean--;
    ) is
        variable ok: boolean;
    begin
        good := false;
        for i in 0 to s'length-1 loop
            char_to_hex(s(s'length-i), v(4*i+3 downto 4*i), ok);
            if not ok then
                return;
            end if;
        end loop;
        good := true;
    end string_to_hex;

end util;
