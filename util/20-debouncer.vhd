library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
    generic (
        W   : positive := 1;
        N   : positive := 16#FFFF#--;
    );
    port (
        d     :   in  std_logic_vector(W-1 downto 0);
        q     :   out std_logic_vector(W-1 downto 0);
        rst_n :   in  std_logic;
        clk   :   in  std_logic--;
    );
end entity;

architecture arch of debouncer is

    type ff_array_t is array (natural range <>) of std_logic_vector(d'range);
    signal ff : ff_array_t(2 downto 0);

    type cnt_array_t is array(natural range <>) of integer range 0 to N;
    signal cnt : cnt_array_t(d'range);

begin

    process(clk, rst_n)
    begin
    if rst_n = '0' then
        q <= (others => '0');
        ff <= (others => (others => '0'));
        cnt <= (others => 0);
        --
    elsif rising_edge(clk) then
        ff <= ff(ff'left-1 downto 0) & d;

        for i in d'range loop
            if ( ff(ff'left)(i) /= ff(ff'left-1)(i) ) then
                cnt(i) <= 0;
            elsif ( cnt(i) = N ) then
                q(i) <= ff(ff'left)(i);
            else
                cnt(i) <= cnt(i) + 1;
            end if;
        end loop;
    end if; -- rising_edge
    end process;

end architecture;
