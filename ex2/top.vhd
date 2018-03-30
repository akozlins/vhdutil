library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity top is
    Port (
        pl_clk_100  :   in  std_logic;
        pl_leds     :   out std_logic_vector(7 downto 0);
        pl_btns     :   in  std_logic_vector(4 downto 0)
    );
end top;

architecture arch of top is

    signal cnt_i : std_logic_vector(31 downto 0);
    signal reset_i : std_logic;

begin

    debounce_i : debounce
    generic map (
        N => 1,
        C => X"FFFF"
    )
    port map (
        input(0 downto 0) => pl_btns(0 downto 0),
        output(0) => reset_i,
        clk => pl_clk_100
    );

    pl_leds <= cnt_i(31 downto 24);

    p : process(pl_clk_100)
    begin
    if rising_edge(pl_clk_100) then
    if reset_i = '1' then
        cnt_i <= (others => '0');
    else
        cnt_i <= cnt_i + 1;
    end if;
    end if; -- rising_edge(clk)
    end process p;

end arch;
