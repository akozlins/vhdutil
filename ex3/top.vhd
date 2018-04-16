library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util.all;

entity top is
    Port (
        pl_clk_100  :   in  std_logic;
        pl_led      :   out std_logic_vector(7 downto 0);
        pl_btn      :   in  std_logic_vector(4 downto 0);
        pl_sw       :   in  std_logic_vector(7 downto 0)--;
    );
end entity;

architecture arch of top is

    signal areset_i : std_logic;
    signal cnt_i : std_logic_vector(31 downto 0);
    signal cnt_o : std_logic_vector(31 downto 0);

begin

    debounce_i : component debounce
    generic map (
        N => 1,
        C => X"FFFF"--,
    )
    port map (
        input(0 downto 0) => pl_btn(0 downto 0),
        output(0) => areset_i,
        clk => pl_clk_100--,
    );

    pl_led <= cnt_o(31 downto 24);

    adder_i : component ripple_adder
    generic map (
        W => 32--,
    )
    port map (
        a => cnt_i,
        b => (others => '0'),
        ci => '1',
        s => cnt_o,
        co => open--,
    );

    process(pl_clk_100, areset_i)
    begin
    if ( areset_i = '1' ) then
        cnt_i <= (others => '0');
    elsif rising_edge(pl_clk_100) then
        cnt_i <= cnt_o;
    end if; -- rising_edge
    end process;

end architecture;
