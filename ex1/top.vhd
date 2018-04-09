library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    Port (
        pl_clk_100  :   in  std_logic;
        pl_leds     :   out std_logic_vector(7 downto 0)
    );
end top;

architecture arch of top is

    signal cnt_i : unsigned(31 downto 0);

begin

    pl_leds <= std_logic_vector(cnt_i(31 downto 24));

    process(pl_clk_100)
    begin
    if rising_edge(pl_clk_100) then
        cnt_i <= cnt_i + 1;
    end if;
    end process;

end arch;
