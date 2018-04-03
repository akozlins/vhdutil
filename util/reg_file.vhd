library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity reg_file is
    generic (
        W   : integer := 8; -- word width in bits
        N   : integer := 2--; -- addr bits (2**N words)
    );
    port (
        clk     :   in  std_logic;
        aA      :   in  std_logic_vector(N-1 downto 0);
        aB      :   in  std_logic_vector(N-1 downto 0);
        aC      :   in  std_logic_vector(N-1 downto 0);
        rdA     :   out std_logic_vector(W-1 downto 0);
        rdB     :   out std_logic_vector(W-1 downto 0);
        rdC     :   out std_logic_vector(W-1 downto 0);
        wdC     :   in  std_logic_vector(W-1 downto 0);
        weC     :   in  std_logic;
        areset  :   in  std_logic--;
    );
end entity reg_file;

architecture arch of reg_file is

    type ram_t is array (0 to 2**N-1) of std_logic_vector(W-1 downto 0);
    signal ram : ram_t;

begin

    process(clk)
    begin
    if areset = '1' then
        ram <= (others => (others => '0'));
    elsif rising_edge(clk) then
        if weC = '1' and aC /= 0 then
            ram(to_integer(unsigned(aC))) <= wdC;
        end if;
    end if; -- rising_edge
    end process;

    rdA <= ram(to_integer(unsigned(aA)));
    rdB <= ram(to_integer(unsigned(aB)));
    rdC <= ram(to_integer(unsigned(aC)));

end;
