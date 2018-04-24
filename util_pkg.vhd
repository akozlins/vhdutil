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
