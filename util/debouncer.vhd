--
-- Author: Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;

entity debouncer is
    generic (
        -- bus width
        W   : positive := 1;
        -- number of clock cycles (stable signal)
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

    signal ff0, ff1 : std_logic_vector(d'range);

    type cnt_array_t is array(natural range <>) of integer range 0 to N;
    signal cnt : cnt_array_t(d'range);

begin

    i_ff_sync : entity work.ff_sync
    generic map ( W => W )
    port map ( d => d, q => ff0, rst_n => rst_n, clk => clk );

    process(clk, rst_n)
    begin
    if rst_n = '0' then
        q <= (others => '0');
        ff1 <= (others => '0');
        cnt <= (others => 0);
        --
    elsif rising_edge(clk) then
        ff1 <= ff0;

        for i in d'range loop
            if ( ff0(i) /= ff1(i) ) then
                cnt(i) <= 0;
            elsif ( cnt(i) = N ) then
                q(i) <= ff1(i);
            else
                cnt(i) <= cnt(i) + 1;
            end if;
        end loop;
    end if; -- rising_edge
    end process;

end architecture;
