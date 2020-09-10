--
-- author : Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- generate one cycle reset signal if input (d) is stable for N cycles
entity watchdog is
generic (
    W : positive := 1;
    N : positive := 16#FFFF#--;
);
port (
    d           : in    std_logic_vector(W-1 downto 0);

    rstout_n    : out   std_logic;

    rst_n       : in    std_logic;
    clk         : in    std_logic--;
);
end entity;

architecture arch of watchdog is

    signal ff0 : std_logic_vector(d'range);
    signal cnt : integer range 0 to N;

begin

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        rstout_n <= '0';
        ff0 <= (others => '0');
        cnt <= 0;
        --
    elsif rising_edge(clk) then
        rstout_n <= '1';
        ff0 <= d;
        cnt <= 0;

        if cnt = N then
            rstout_n <= '0';
        elsif ( ff0 = d ) then
            cnt <= cnt + 1;
        end if;
        --
    end if;
    end process;

end architecture;
