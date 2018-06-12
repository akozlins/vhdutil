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

    signal q0, q1, q2 : std_logic_vector(d'range);

    type cnt_t is array(natural range <>) of integer range 0 to N;
    signal cnt : cnt_t(d'range);

begin

    process(clk, rst_n)
    begin
    if rst_n = '0' then
        q <= (others => '0');
        q0 <= (others => '0');
        q1 <= (others => '0');
        q2 <= (others => '0');
        cnt <= (others => 0);
        --
    elsif rising_edge(clk) then
        q0 <= d;
        q1 <= q0;
        q2 <= q1;
        for i in d'range loop
            if ( q1(i) /= q2(i) ) then
                cnt(i) <= 0;
            elsif ( cnt(i) = N ) then
                q(i) <= q2(i);
            else
                cnt(i) <= cnt(i) + 1;
            end if;
        end loop;
    end if; -- rising_edge
    end process;

end architecture;
