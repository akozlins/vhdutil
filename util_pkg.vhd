--
-- Author: Alexandr Kozlinskiy
-- Date: 2018-03-30
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use std.textio.all;
use ieee.std_logic_textio.all;

package util is

    function max (
        l, r: integer
    ) return integer;

    function vector_width (
        v : natural--;
    ) return positive;

    function bin2gray (
        v : std_logic_vector--;
    ) return std_logic_vector;

    function gray2bin (
        v : std_logic_vector--;
    ) return std_logic_vector;

    function shift_right (
        v : std_logic_vector;
        n : natural--;
    ) return std_logic_vector;

    function shift_left (
        v : std_logic_vector;
        n : natural--;
    ) return std_logic_vector;

    function resize (
        v : std_logic_vector;
        n : positive--;
    ) return std_logic_vector;

    function and_reduce (
        v : std_logic_vector--;
    ) return std_logic;

    function or_reduce (
        v : std_logic_vector--;
    ) return std_logic;

    function xor_reduce (
        v : std_logic_vector--;
    ) return std_logic;

    function to_std_logic (
        b : in boolean--;
    ) return std_logic;

    procedure char_to_hex (
        c : in character;
        v : out std_logic_vector(3 downto 0);
        good : out boolean--;
    );

    procedure string_to_hex (
        s : in string;
        v : out std_logic_vector;
        good : out boolean--;
    );

    procedure read_hex (
        l : inout line;
        value : out std_logic_vector;
        good : out boolean--;
    );

    impure
    function read_hex (
        fname : in string;
        N : in positive;
        W : in positive--;
    ) return std_logic_vector;

    function to_string (
        v : in std_logic--;
    ) return string;

    function to_string (
        v : in std_logic_vector--;
    ) return string;

end package;

package body util is

    function max (
        l, r: integer
    ) return integer is
    begin
        if l > r then
            return l;
        else
            return r;
        end if;
    end function;

    function vector_width (
        v : natural--;
    ) return positive is
    begin
        if ( v = 0 or v = 1 ) then
            return 1;
        end if;
        return positive(ceil(log2(real(v))));
    end function;

    function bin2gray (
        v : std_logic_vector--;
    ) return std_logic_vector is
    begin
        return v xor shift_right(v, 1);
    end function;

    function gray2bin (
        v : std_logic_vector--;
    ) return std_logic_vector is
        variable b : std_logic := '0';
        variable r : std_logic_vector(v'range);
    begin
        for i in v'range loop
            b := b xor v(i);
            r(i) := b;
        end loop;
        return r;
    end function;

    function shift_right (
        v : std_logic_vector;
        n : natural--;
    ) return std_logic_vector is
    begin
        return std_logic_vector(shift_right(unsigned(v), n));
    end function;

    function shift_left (
        v : std_logic_vector;
        n : natural--;
    ) return std_logic_vector is
    begin
        return std_logic_vector(shift_left(unsigned(v), n));
    end function;

    function resize (
        v : std_logic_vector;
        n : positive--;
    ) return std_logic_vector is
    begin
        return std_logic_vector(resize(unsigned(v), n));
    end function;

    function and_reduce (
        v : std_logic_vector--;
    ) return std_logic is
    begin
        return to_std_logic(v = (v'range => '1'));
    end function;

    function or_reduce (
        v : std_logic_vector--;
    ) return std_logic is
    begin
        return to_std_logic(v /= (v'range => '0'));
    end function;

    function xor_reduce (
        v : std_logic_vector--;
    ) return std_logic is
        variable r : std_logic := '0';
    begin
        for i in v'range loop
            r := r xor v(i);
        end loop;
        return r;
    end function;

    function to_std_logic (
        b : in boolean--;
    ) return std_logic is
    begin
        if b then
            return '1';
        else
            return '0';
        end if;
    end function;

    procedure char_to_hex (
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
           assert false report "ERROR (char_to_hex) invalid hex character '" & c & "'";
           good := false;
        end case;
    end procedure;

    procedure string_to_hex (
        s : in string;
        v : out std_logic_vector;
        good : out boolean--;
    ) is
        variable ok : boolean;
    begin
        good := false;
        for i in 0 to s'length-1 loop
            char_to_hex(s(s'right-i), v(3+4*i+v'right downto 4*i+v'right), ok);
            if not ok then
                return;
            end if;
        end loop;
        good := true;
    end procedure;

    procedure read_hex (
        l : inout line;
        value : out std_logic_vector;
        good : out boolean--;
    ) is
        variable v : std_logic_vector(value'range);
        variable c : character;
        variable s : string(1 to value'length/4);
        variable ok : boolean;
    begin
        good := false;

        if value'length mod 4 /= 0 then
            assert false report "ERROR (read_hex) value'length mod 4 /= 0";
            return;
        end if;

        -- skip spaces
        loop
            read(l, c);
            exit when ((c /= ' ') and (c /= CR) and (c /= HT));
        end loop;

        -- skip comment
        if c = '#' then
            return;
        end if;

        s(1) := c;
        read(L, s(2 to s'right), ok);
        if not ok then
            return;
        end if;

        string_to_hex(s, v, ok);
        if not ok then
            return;
        end if;

        value := v;
        good := true;
    end procedure;

    impure
    function read_hex (
        fname : in string;
        N : in positive;
        W : in positive--;
    ) return std_logic_vector is
        variable data : std_logic_vector(N*W-1 downto 0);
        variable data_i : std_logic_vector(W-1 downto 0);
        variable i : integer := 0;
        file f : text;
        variable fs : file_open_status;
        variable l : line;
        variable c : character;
        variable s : string(1 to W/4);
        variable ok : boolean;
    begin
        if fname = "" then
            return data;
        end if;
        file_open(fs, f, fname, READ_MODE);
        while ( endfile(f) /= true ) loop
            readline(f, l);
            read(l, c, ok);
            next when ( not ok or c = '#' );
            s(1) := c;
            read(l, s(2 to s'right), ok);
            next when ( not ok );
            work.util.string_to_hex(s, data_i, ok);
            next when ( not ok );
            data(W-1+i*W downto i*W) := data_i;
            i := i + 1;
        end loop;
        file_close(f);
        return data;
    end function;

    function to_string (
        v : in std_logic--;
    ) return string is
        variable s : string(1 to 1);
        variable c : character;
    begin
        c := 'X';
        if ( v = '0' ) then
            c := '0';
        elsif ( v = '1' ) then
            c := '1';
        end if;
        s(1) := c;
        return s;
    end function;

    function to_string (
        v : in std_logic_vector--;
    ) return string is
        variable s : string(1 to v'length);
    begin
        for i in v'range loop
            s(v'length - i + v'right) := to_string(v(i))(1);
        end loop;
        return s;
    end function;

end package body;
