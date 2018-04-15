library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

use work.util.all;

entity ram_v1 is
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
end entity;

architecture arch of ram_v1 is

--    attribute RAM_STYLE : string;
--    attribute RAM_STYLE of <entity_name>: entity is { "DISTRIBUTED" | "BLOCK" };
    type ram_t is array (0 to 2**N-1) of std_logic_vector(W-1 downto 0);

    impure
    function ram_read(
        fname : in string--;
    ) return ram_t is
        variable ram : ram_t;
        variable i : integer := 0;
        file f : text;
        variable fs : file_open_status;
        variable l : line;
        variable c : character;
        variable s : string(1 to W/4);
        variable ok : boolean;
    begin
        if fname = "" then
            return ram;
        end if;
        file_open(fs, f, fname, READ_MODE);
        while ( endfile(f) /= true ) loop
            readline(f, l);
            read(l, c, ok);
            next when ( not ok or c = '#' );
            s(1) := c;
            read(l, s(2 to s'right), ok);
            next when ( not ok );
            string_to_hex(s, ram(i), ok);
            next when ( not ok );
            i := i + 1;
        end loop;
        file_close(f);
        return ram;
    end function;

    signal ram : ram_t := ram_read(INIT_FILE_HEX);

begin

    process(clk)
    begin
    if rising_edge(clk) then
        if(we = '1') then
            ram(to_integer(unsigned(addr))) <= wd;
        end if;
    end if; -- rising_edge
    end process;

    rd <= ram(to_integer(unsigned(addr)));

end architecture;
