library ieee;
use ieee.std_logic_1164.all;

entity top is
    port (
        pl_led      :   out std_logic_vector(7 downto 0);
        pl_btn      :   in  std_logic_vector(4 downto 0);
        pl_sw       :   in  std_logic_vector(7 downto 0);
        pl_clk_100  :   in  std_logic--;
    );
end entity;

architecture arch of top is

    signal clk_100, rst_100_n : std_logic;

begin

    clk_100 <= pl_clk_100;

    i_rst_100_n : entity work.reset_sync
    port map ( rstout_n => rst_100_n, arst_n => not pl_btn(0), clk => clk_100 );

end architecture;
