--
-- author : Alexandr Kozlinskiy
-- date : 2018-03-30
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use std.textio.all;

package util is

    subtype slv4_t is std_logic_vector(3 downto 0);
    type slv4_array_t is array ( natural range <> ) of slv4_t;
    subtype slv8_t is std_logic_vector(7 downto 0);
    type slv8_array_t is array ( natural range <> ) of slv8_t;
    subtype slv16_t is std_logic_vector(15 downto 0);
    type slv16_array_t is array ( natural range <> ) of slv16_t;
    subtype slv32_t is std_logic_vector(31 downto 0);
    type slv32_array_t is array ( natural range <> ) of slv32_t;

    type avalon_t is record
        address         :   std_logic_vector(31 downto 0);
        read            :   std_logic;
        readdata        :   std_logic_vector(31 downto 0);
        write           :   std_logic;
        writedata       :   std_logic_vector(31 downto 0);
        waitrequest     :   std_logic;
        readdatavalid   :   std_logic;
    end record;
    type avalon_array_t is array(natural range <>) of avalon_t;

    -- Greatest Common Divisor
    function gcd (
        p, q : positive--;
    ) return positive;

    function max (
        l, r : integer--;
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

    function gray_inc (
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

    function reverse (
        v : std_logic_vector--;
    ) return std_logic_vector;

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



    -- LFSR 32
    -- src: http://www.xilinx.com/support/documentation/application_notes/xapp052.pdf
    --
    -- taps: 31, 21, 1, 0
    function lfsr_32 (
        data : std_logic_vector(31 downto 0)--;
    ) return std_logic_vector;

    -- CRC-32C (Castagnoli) 0x1.1EDC6F41
    -- src: http://www.easics.com/services/freesics/crctool.html
    -- polynomial: x^32 + x^28 + x^27 + x^26 + x^25 + x^23 + x^22 + x^20 + x^19 + x^18 + x^14 + x^13 + x^11 + x^10 + x^9 + x^8 + x^6 + 1
    -- data width: 32
    -- convention: the first serial bit is D[31] -- TODO: D[0]
    function crc32 (
        data : std_logic_vector(31 downto 0);
        crc  : std_logic_vector(31 downto 0)--;
    ) return std_logic_vector;



    function count_bits_4 (
        data : std_logic_vector(3 downto 0)--;
    ) return natural;

    function count_bits_32 (
        data : std_logic_vector(31 downto 0)--;
    ) return natural;

    function count_bits (
        data : std_logic_vector--;
    ) return natural;

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

    function to_string (
        v : in unsigned--;
    ) return string;

    function to_hstring (
        v : std_logic_vector--;
    ) return string;

    function to_hstring (
        v : unsigned--;
    ) return string;

    -- Select Graphic Rendition
    function sgr (
        n : natural--;
    ) return string;

    -- get next Round-Robin index
    function round_robin_next (
        i : std_logic_vector;
        req : std_logic_vector--;
    ) return std_logic_vector;

end package;

package body util is

    function gcd (
        p, q : positive--;
    ) return positive is
        variable p_v : positive := p;
        variable q_v : positive := q;
    begin
        while ( p_v /= q_v ) loop
            if ( p_v > q_v ) then
                p_v := p_v - q_v;
            else
                q_v := q_v - p_v;
            end if;
        end loop;
        return p_v;
    end function;

    function max (
        l, r : integer
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

    function gray_inc (
        v : std_logic_vector--;
    ) return std_logic_vector is
        variable r : std_logic_vector(v'range) := (others => '0');
    begin
        r := gray2bin(v);
        r := std_logic_vector(unsigned(r) + 1);
        return bin2gray(r);
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
        alias a : std_logic_vector(v'length-1 downto 0) is v;
    begin
        if ( v'length = 0 ) then
            report "(xor_reduce) v'length = 0" severity failure;
            return 'X';
        end if;
        if ( a'length = 1 ) then
            return a(0);
        end if;
        return xor_reduce(a(a'length-1 downto a'length/2)) xor xor_reduce(a(a'length/2-1 downto 0));
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

    function reverse (
        v : std_logic_vector--;
    ) return std_logic_vector is
        variable r : std_logic_vector(v'range);
        alias a : std_logic_vector(v'reverse_range) is v;
    begin
        for i in a'range loop
            r(i) := a(i);
        end loop;
        return r;
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
           report "(char_to_hex) invalid hex character '" & c & "'" severity failure;
           good := false;
           v := "XXXX";
        end case;
    end procedure;

    procedure string_to_hex (
        s : in string;
        v : out std_logic_vector;
        good : out boolean--;
    ) is
        variable ok : boolean;
        variable good_i : boolean;
    begin
        good_i := true;
        for i in 0 to s'length-1 loop
            char_to_hex(s(s'right-i), v(3+4*i+v'right downto 4*i+v'right), ok);
            good_i := good_i and ok;
        end loop;
        good := good_i;
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
            report "(read_hex) value'length mod 4 /= 0" severity failure;
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
        if fname'length = 0 then
            return data;
        end if;

        file_open(fs, f, fname, READ_MODE);
        assert ( fs = open_ok ) report "(read_hex) file_open_status = '" & FILE_OPEN_STATUS'image(fs) & "'" severity failure;

        while ( not endfile(f) ) loop
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



    function lfsr_32(
        data : std_logic_vector(31 downto 0)--;
    ) return std_logic_vector is
    begin
        return data(30 downto 0) &
              (data(31) xor data(21) xor data(1) xor data(0));
    end function;

    function crc32 (
        data : std_logic_vector(31 downto 0);
        crc  : std_logic_vector(31 downto 0)--;
    ) return std_logic_vector is
        variable d      : std_logic_vector(31 downto 0);
        variable c      : std_logic_vector(31 downto 0);
        variable newcrc : std_logic_vector(31 downto 0);
    begin
        d := data;
        c := crc;

        newcrc(0) := d(31) xor d(30) xor d(28) xor d(27) xor d(26) xor d(25) xor d(23) xor d(21) xor d(18) xor d(17) xor d(16) xor d(12) xor d(9) xor d(8) xor d(7) xor d(6) xor d(5) xor d(4) xor d(0) xor c(0) xor c(4) xor c(5) xor c(6) xor c(7) xor c(8) xor c(9) xor c(12) xor c(16) xor c(17) xor c(18) xor c(21) xor c(23) xor c(25) xor c(26) xor c(27) xor c(28) xor c(30) xor c(31);
        newcrc(1) := d(31) xor d(29) xor d(28) xor d(27) xor d(26) xor d(24) xor d(22) xor d(19) xor d(18) xor d(17) xor d(13) xor d(10) xor d(9) xor d(8) xor d(7) xor d(6) xor d(5) xor d(1) xor c(1) xor c(5) xor c(6) xor c(7) xor c(8) xor c(9) xor c(10) xor c(13) xor c(17) xor c(18) xor c(19) xor c(22) xor c(24) xor c(26) xor c(27) xor c(28) xor c(29) xor c(31);
        newcrc(2) := d(30) xor d(29) xor d(28) xor d(27) xor d(25) xor d(23) xor d(20) xor d(19) xor d(18) xor d(14) xor d(11) xor d(10) xor d(9) xor d(8) xor d(7) xor d(6) xor d(2) xor c(2) xor c(6) xor c(7) xor c(8) xor c(9) xor c(10) xor c(11) xor c(14) xor c(18) xor c(19) xor c(20) xor c(23) xor c(25) xor c(27) xor c(28) xor c(29) xor c(30);
        newcrc(3) := d(31) xor d(30) xor d(29) xor d(28) xor d(26) xor d(24) xor d(21) xor d(20) xor d(19) xor d(15) xor d(12) xor d(11) xor d(10) xor d(9) xor d(8) xor d(7) xor d(3) xor c(3) xor c(7) xor c(8) xor c(9) xor c(10) xor c(11) xor c(12) xor c(15) xor c(19) xor c(20) xor c(21) xor c(24) xor c(26) xor c(28) xor c(29) xor c(30) xor c(31);
        newcrc(4) := d(31) xor d(30) xor d(29) xor d(27) xor d(25) xor d(22) xor d(21) xor d(20) xor d(16) xor d(13) xor d(12) xor d(11) xor d(10) xor d(9) xor d(8) xor d(4) xor c(4) xor c(8) xor c(9) xor c(10) xor c(11) xor c(12) xor c(13) xor c(16) xor c(20) xor c(21) xor c(22) xor c(25) xor c(27) xor c(29) xor c(30) xor c(31);
        newcrc(5) := d(31) xor d(30) xor d(28) xor d(26) xor d(23) xor d(22) xor d(21) xor d(17) xor d(14) xor d(13) xor d(12) xor d(11) xor d(10) xor d(9) xor d(5) xor c(5) xor c(9) xor c(10) xor c(11) xor c(12) xor c(13) xor c(14) xor c(17) xor c(21) xor c(22) xor c(23) xor c(26) xor c(28) xor c(30) xor c(31);
        newcrc(6) := d(30) xor d(29) xor d(28) xor d(26) xor d(25) xor d(24) xor d(22) xor d(21) xor d(17) xor d(16) xor d(15) xor d(14) xor d(13) xor d(11) xor d(10) xor d(9) xor d(8) xor d(7) xor d(5) xor d(4) xor d(0) xor c(0) xor c(4) xor c(5) xor c(7) xor c(8) xor c(9) xor c(10) xor c(11) xor c(13) xor c(14) xor c(15) xor c(16) xor c(17) xor c(21) xor c(22) xor c(24) xor c(25) xor c(26) xor c(28) xor c(29) xor c(30);
        newcrc(7) := d(31) xor d(30) xor d(29) xor d(27) xor d(26) xor d(25) xor d(23) xor d(22) xor d(18) xor d(17) xor d(16) xor d(15) xor d(14) xor d(12) xor d(11) xor d(10) xor d(9) xor d(8) xor d(6) xor d(5) xor d(1) xor c(1) xor c(5) xor c(6) xor c(8) xor c(9) xor c(10) xor c(11) xor c(12) xor c(14) xor c(15) xor c(16) xor c(17) xor c(18) xor c(22) xor c(23) xor c(25) xor c(26) xor c(27) xor c(29) xor c(30) xor c(31);
        newcrc(8) := d(25) xor d(24) xor d(21) xor d(19) xor d(15) xor d(13) xor d(11) xor d(10) xor d(8) xor d(5) xor d(4) xor d(2) xor d(0) xor c(0) xor c(2) xor c(4) xor c(5) xor c(8) xor c(10) xor c(11) xor c(13) xor c(15) xor c(19) xor c(21) xor c(24) xor c(25);
        newcrc(9) := d(31) xor d(30) xor d(28) xor d(27) xor d(23) xor d(22) xor d(21) xor d(20) xor d(18) xor d(17) xor d(14) xor d(11) xor d(8) xor d(7) xor d(4) xor d(3) xor d(1) xor d(0) xor c(0) xor c(1) xor c(3) xor c(4) xor c(7) xor c(8) xor c(11) xor c(14) xor c(17) xor c(18) xor c(20) xor c(21) xor c(22) xor c(23) xor c(27) xor c(28) xor c(30) xor c(31);
        newcrc(10) := d(30) xor d(29) xor d(27) xor d(26) xor d(25) xor d(24) xor d(22) xor d(19) xor d(17) xor d(16) xor d(15) xor d(7) xor d(6) xor d(2) xor d(1) xor d(0) xor c(0) xor c(1) xor c(2) xor c(6) xor c(7) xor c(15) xor c(16) xor c(17) xor c(19) xor c(22) xor c(24) xor c(25) xor c(26) xor c(27) xor c(29) xor c(30);
        newcrc(11) := d(21) xor d(20) xor d(12) xor d(9) xor d(6) xor d(5) xor d(4) xor d(3) xor d(2) xor d(1) xor d(0) xor c(0) xor c(1) xor c(2) xor c(3) xor c(4) xor c(5) xor c(6) xor c(9) xor c(12) xor c(20) xor c(21);
        newcrc(12) := d(22) xor d(21) xor d(13) xor d(10) xor d(7) xor d(6) xor d(5) xor d(4) xor d(3) xor d(2) xor d(1) xor c(1) xor c(2) xor c(3) xor c(4) xor c(5) xor c(6) xor c(7) xor c(10) xor c(13) xor c(21) xor c(22);
        newcrc(13) := d(31) xor d(30) xor d(28) xor d(27) xor d(26) xor d(25) xor d(22) xor d(21) xor d(18) xor d(17) xor d(16) xor d(14) xor d(12) xor d(11) xor d(9) xor d(3) xor d(2) xor d(0) xor c(0) xor c(2) xor c(3) xor c(9) xor c(11) xor c(12) xor c(14) xor c(16) xor c(17) xor c(18) xor c(21) xor c(22) xor c(25) xor c(26) xor c(27) xor c(28) xor c(30) xor c(31);
        newcrc(14) := d(30) xor d(29) xor d(25) xor d(22) xor d(21) xor d(19) xor d(16) xor d(15) xor d(13) xor d(10) xor d(9) xor d(8) xor d(7) xor d(6) xor d(5) xor d(3) xor d(1) xor d(0) xor c(0) xor c(1) xor c(3) xor c(5) xor c(6) xor c(7) xor c(8) xor c(9) xor c(10) xor c(13) xor c(15) xor c(16) xor c(19) xor c(21) xor c(22) xor c(25) xor c(29) xor c(30);
        newcrc(15) := d(31) xor d(30) xor d(26) xor d(23) xor d(22) xor d(20) xor d(17) xor d(16) xor d(14) xor d(11) xor d(10) xor d(9) xor d(8) xor d(7) xor d(6) xor d(4) xor d(2) xor d(1) xor c(1) xor c(2) xor c(4) xor c(6) xor c(7) xor c(8) xor c(9) xor c(10) xor c(11) xor c(14) xor c(16) xor c(17) xor c(20) xor c(22) xor c(23) xor c(26) xor c(30) xor c(31);
        newcrc(16) := d(31) xor d(27) xor d(24) xor d(23) xor d(21) xor d(18) xor d(17) xor d(15) xor d(12) xor d(11) xor d(10) xor d(9) xor d(8) xor d(7) xor d(5) xor d(3) xor d(2) xor c(2) xor c(3) xor c(5) xor c(7) xor c(8) xor c(9) xor c(10) xor c(11) xor c(12) xor c(15) xor c(17) xor c(18) xor c(21) xor c(23) xor c(24) xor c(27) xor c(31);
        newcrc(17) := d(28) xor d(25) xor d(24) xor d(22) xor d(19) xor d(18) xor d(16) xor d(13) xor d(12) xor d(11) xor d(10) xor d(9) xor d(8) xor d(6) xor d(4) xor d(3) xor c(3) xor c(4) xor c(6) xor c(8) xor c(9) xor c(10) xor c(11) xor c(12) xor c(13) xor c(16) xor c(18) xor c(19) xor c(22) xor c(24) xor c(25) xor c(28);
        newcrc(18) := d(31) xor d(30) xor d(29) xor d(28) xor d(27) xor d(21) xor d(20) xor d(19) xor d(18) xor d(16) xor d(14) xor d(13) xor d(11) xor d(10) xor d(8) xor d(6) xor d(0) xor c(0) xor c(6) xor c(8) xor c(10) xor c(11) xor c(13) xor c(14) xor c(16) xor c(18) xor c(19) xor c(20) xor c(21) xor c(27) xor c(28) xor c(29) xor c(30) xor c(31);
        newcrc(19) := d(29) xor d(27) xor d(26) xor d(25) xor d(23) xor d(22) xor d(20) xor d(19) xor d(18) xor d(16) xor d(15) xor d(14) xor d(11) xor d(8) xor d(6) xor d(5) xor d(4) xor d(1) xor d(0) xor c(0) xor c(1) xor c(4) xor c(5) xor c(6) xor c(8) xor c(11) xor c(14) xor c(15) xor c(16) xor c(18) xor c(19) xor c(20) xor c(22) xor c(23) xor c(25) xor c(26) xor c(27) xor c(29);
        newcrc(20) := d(31) xor d(25) xor d(24) xor d(20) xor d(19) xor d(18) xor d(15) xor d(8) xor d(4) xor d(2) xor d(1) xor d(0) xor c(0) xor c(1) xor c(2) xor c(4) xor c(8) xor c(15) xor c(18) xor c(19) xor c(20) xor c(24) xor c(25) xor c(31);
        newcrc(21) := d(26) xor d(25) xor d(21) xor d(20) xor d(19) xor d(16) xor d(9) xor d(5) xor d(3) xor d(2) xor d(1) xor c(1) xor c(2) xor c(3) xor c(5) xor c(9) xor c(16) xor c(19) xor c(20) xor c(21) xor c(25) xor c(26);
        newcrc(22) := d(31) xor d(30) xor d(28) xor d(25) xor d(23) xor d(22) xor d(20) xor d(18) xor d(16) xor d(12) xor d(10) xor d(9) xor d(8) xor d(7) xor d(5) xor d(3) xor d(2) xor d(0) xor c(0) xor c(2) xor c(3) xor c(5) xor c(7) xor c(8) xor c(9) xor c(10) xor c(12) xor c(16) xor c(18) xor c(20) xor c(22) xor c(23) xor c(25) xor c(28) xor c(30) xor c(31);
        newcrc(23) := d(30) xor d(29) xor d(28) xor d(27) xor d(25) xor d(24) xor d(19) xor d(18) xor d(16) xor d(13) xor d(12) xor d(11) xor d(10) xor d(7) xor d(5) xor d(3) xor d(1) xor d(0) xor c(0) xor c(1) xor c(3) xor c(5) xor c(7) xor c(10) xor c(11) xor c(12) xor c(13) xor c(16) xor c(18) xor c(19) xor c(24) xor c(25) xor c(27) xor c(28) xor c(29) xor c(30);
        newcrc(24) := d(31) xor d(30) xor d(29) xor d(28) xor d(26) xor d(25) xor d(20) xor d(19) xor d(17) xor d(14) xor d(13) xor d(12) xor d(11) xor d(8) xor d(6) xor d(4) xor d(2) xor d(1) xor c(1) xor c(2) xor c(4) xor c(6) xor c(8) xor c(11) xor c(12) xor c(13) xor c(14) xor c(17) xor c(19) xor c(20) xor c(25) xor c(26) xor c(28) xor c(29) xor c(30) xor c(31);
        newcrc(25) := d(29) xor d(28) xor d(25) xor d(23) xor d(20) xor d(17) xor d(16) xor d(15) xor d(14) xor d(13) xor d(8) xor d(6) xor d(4) xor d(3) xor d(2) xor d(0) xor c(0) xor c(2) xor c(3) xor c(4) xor c(6) xor c(8) xor c(13) xor c(14) xor c(15) xor c(16) xor c(17) xor c(20) xor c(23) xor c(25) xor c(28) xor c(29);
        newcrc(26) := d(31) xor d(29) xor d(28) xor d(27) xor d(25) xor d(24) xor d(23) xor d(15) xor d(14) xor d(12) xor d(8) xor d(6) xor d(3) xor d(1) xor d(0) xor c(0) xor c(1) xor c(3) xor c(6) xor c(8) xor c(12) xor c(14) xor c(15) xor c(23) xor c(24) xor c(25) xor c(27) xor c(28) xor c(29) xor c(31);
        newcrc(27) := d(31) xor d(29) xor d(27) xor d(24) xor d(23) xor d(21) xor d(18) xor d(17) xor d(15) xor d(13) xor d(12) xor d(8) xor d(6) xor d(5) xor d(2) xor d(1) xor d(0) xor c(0) xor c(1) xor c(2) xor c(5) xor c(6) xor c(8) xor c(12) xor c(13) xor c(15) xor c(17) xor c(18) xor c(21) xor c(23) xor c(24) xor c(27) xor c(29) xor c(31);
        newcrc(28) := d(31) xor d(27) xor d(26) xor d(24) xor d(23) xor d(22) xor d(21) xor d(19) xor d(17) xor d(14) xor d(13) xor d(12) xor d(8) xor d(5) xor d(4) xor d(3) xor d(2) xor d(1) xor d(0) xor c(0) xor c(1) xor c(2) xor c(3) xor c(4) xor c(5) xor c(8) xor c(12) xor c(13) xor c(14) xor c(17) xor c(19) xor c(21) xor c(22) xor c(23) xor c(24) xor c(26) xor c(27) xor c(31);
        newcrc(29) := d(28) xor d(27) xor d(25) xor d(24) xor d(23) xor d(22) xor d(20) xor d(18) xor d(15) xor d(14) xor d(13) xor d(9) xor d(6) xor d(5) xor d(4) xor d(3) xor d(2) xor d(1) xor c(1) xor c(2) xor c(3) xor c(4) xor c(5) xor c(6) xor c(9) xor c(13) xor c(14) xor c(15) xor c(18) xor c(20) xor c(22) xor c(23) xor c(24) xor c(25) xor c(27) xor c(28);
        newcrc(30) := d(29) xor d(28) xor d(26) xor d(25) xor d(24) xor d(23) xor d(21) xor d(19) xor d(16) xor d(15) xor d(14) xor d(10) xor d(7) xor d(6) xor d(5) xor d(4) xor d(3) xor d(2) xor c(2) xor c(3) xor c(4) xor c(5) xor c(6) xor c(7) xor c(10) xor c(14) xor c(15) xor c(16) xor c(19) xor c(21) xor c(23) xor c(24) xor c(25) xor c(26) xor c(28) xor c(29);
        newcrc(31) := d(30) xor d(29) xor d(27) xor d(26) xor d(25) xor d(24) xor d(22) xor d(20) xor d(17) xor d(16) xor d(15) xor d(11) xor d(8) xor d(7) xor d(6) xor d(5) xor d(4) xor d(3) xor c(3) xor c(4) xor c(5) xor c(6) xor c(7) xor c(8) xor c(11) xor c(15) xor c(16) xor c(17) xor c(20) xor c(22) xor c(24) xor c(25) xor c(26) xor c(27) xor c(29) xor c(30);

        return newcrc;
    end function;



    function count_bits_4(
        data : std_logic_vector(3 downto 0)--;
    ) return natural is
    begin
        case data is
        when "0000" => return 0;
        when "0001" | "0010" | "0100" | "1000" => return 1;
        when "0111" | "1011" | "1101" | "1110" => return 3;
        when "1111" => return 4;
        when others => return 2;
        end case;
    end function;

    function count_bits_32(
        data : std_logic_vector(31 downto 0)--;
    ) return natural is
    begin
        return (
            (
                count_bits_4(data(31 downto 28)) +
                count_bits_4(data(27 downto 24))
            ) + (
                count_bits_4(data(23 downto 20)) +
                count_bits_4(data(19 downto 16))
            )
        ) + (
            (
                count_bits_4(data(15 downto 12)) +
                count_bits_4(data(11 downto  8))
            ) + (
                count_bits_4(data( 7 downto  4)) +
                count_bits_4(data( 3 downto  0))
            )
        );
    end function;

    function count_bits (
        data : std_logic_vector--;
    ) return natural is
        variable data_v : std_logic_vector(data'length-1 downto 0);
    begin
        data_v := data;
        if ( data_v'length > 1 ) then
            return count_bits(data_v(data_v'length-1 downto data_v'length/2)) + count_bits(data_v(data_v'length/2-1 downto 0));
        else
            return to_integer(unsigned(data_v));
        end if;
    end function;

    function to_string (
        v : in std_logic--;
    ) return string is
        variable s : string(1 to 1);
    begin
        s(1) := std_logic'image(v)(2);
        return s;
    end function;

    function to_string (
        v : in std_logic_vector--;
    ) return string is
        variable s : string(1 to v'length);
        variable j : integer := 1;
    begin
        for i in v'range loop
            s(j) := to_string(v(i))(1);
            j := j + 1;
        end loop;
        return s;
    end function;

    function to_string (
        v : in unsigned--;
    ) return string is
    begin
        return to_string(std_logic_vector(v));
    end function;

    function to_hstring (
        v : std_logic_vector--;
    ) return string is
        variable r : string(1 to (v'length + 3) / 4) := (others => 'X');
        variable u : unsigned(v'length+3 downto 0);
        constant lut : string(1 to 16) := "0123456789ABCDEF";
    begin
        u := resize(unsigned(v), u'length);
        for i in r'range loop
            next when ( is_x(std_logic_vector(u(4*i-1 downto 4*i-4))) );
            r(r'length-i+1) := lut(1 + to_integer(u(4*i-1 downto 4*i-4)));
        end loop;
        return r;
    end function;

    function to_hstring (
        v : unsigned--;
    ) return string is
    begin
        return to_hstring(std_logic_vector(v));
    end function;

    function sgr (
        n : natural--;
    ) return string is
    begin
        return ESC & "[" & natural'image(n) & "m";
    end function;

    function round_robin_next (
        -- one hot encoded active link
        i : std_logic_vector;
        -- bit encoded available links
        req : std_logic_vector--;
    ) return std_logic_vector is
        variable mask, nxt : std_logic_vector(i'range);
    begin
        -- bits to the right of active link
        mask := std_logic_vector(unsigned(i) - 1);
        -- ... to the left ...
        mask := not mask xor i;
        -- selects availabe links to the left of active link
        nxt := req and mask;
        if ( nxt = (nxt'range => '0') ) then
            -- select all available links
            nxt := req or i;
        end if;
        -- return least significant set bit
        return nxt and std_logic_vector(unsigned(not nxt) + 1);
    end function;

end package body;
