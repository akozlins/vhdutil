library ieee;
use ieee.std_logic_1164.all;

entity top is
port (
    o_led       : out   std_logic_vector(7 downto 0);
    i_btn       : in    std_logic_vector(4 downto 0);
    i_sw        : in    std_logic_vector(7 downto 0);

    i_clk_100   : in    std_logic--;
);
end entity;

architecture arch of top is

    signal reset_100_n : std_logic;

begin

    e_reset_100_n : entity work.reset_sync
    port map ( o_reset_n => reset_100_n, i_reset_n => not i_btn(0), i_clk => i_clk_100 );

    process(i_clk_100)
    begin
    if ( reset_100_n = '1' ) then
        o_led <= (others => '0');
        --
    elsif rising_edge(i_clk_100) then
        o_led <= i_sw;
        --
    end if;
    end process;

end architecture;
