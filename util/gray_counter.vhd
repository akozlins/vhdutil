library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util.all;

entity gray_counter is
    generic (
        W   : integer := 8--;
    );
    port (
        cnt     :   out std_logic_vector(W-1 downto 0);
        clk     :   in  std_logic;
        ena     :   in  std_logic;
        areset  :   in  std_logic--;
    );
end entity gray_counter;

architecture arch of gray_counter is

    signal cnt_i : unsigned(W-1 downto 0);

begin

    process(clk)
    begin
    if ( areset = '1' ) then
        cnt_i <= (others => '0');
    elsif ( rising_edge(clk) and ena = '1' ) then
        cnt_i <= cnt_i + 1;
    end if; -- rising_edge
    end process;

    cnt <= std_logic_vector(cnt_i xor ('0' & cnt_i(W-1 downto 1)));

end;
