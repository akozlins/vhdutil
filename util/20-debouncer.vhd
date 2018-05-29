library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
    generic (
        N   : positive := 1;
        C   : unsigned := X"FFFF"--;
    );
    port (
        d     :   in  std_logic_vector(N-1 downto 0);
        q     :   out std_logic_vector(N-1 downto 0);
        rst_n :   in  std_logic;
        clk   :   in  std_logic--;
    );
end entity;

architecture arch of debouncer is

    signal q0, q1 : std_logic_vector(d'range);

    type cnt_t is array(natural range <>) of unsigned(C'range);
    signal cnt : cnt_t(d'range);

begin

    process(clk, rst_n)
    begin
    if rst_n = '0' then
        q <= (others => '0');
        q0 <= (others => '0');
        q1 <= (others => '0');
        cnt <= (others => (others => '0'));
        --
    elsif rising_edge(clk) then
        q0 <= d;
        q1 <= q0;
        for i in d'range loop
            if ( q0(i) /= q1(i) ) then
                cnt(i) <= (others => '0');
            elsif ( cnt(i) = C ) then
                q(i) <= q1(i);
            else
                cnt(i) <= cnt(i) + 1;
            end if;
        end loop;
    end if; -- rising_edge
    end process;

end architecture;
