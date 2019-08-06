library ieee;
use ieee.std_logic_1164.all;

entity tb_top is
end entity;

architecture arch of tb_top is

    constant CLK_MHZ : positive := 100;
    signal clk, reset_n : std_logic := '0';

    signal btn : std_logic_vector(4 downto 0);

begin

    clk <= not clk after (500 ns / CLK_MHZ);
    reset_n <= '0', '1' after 100 ns;

    i_top : entity work.top
    port map (
        pl_led      => open,
        pl_btn      => btn,
        pl_sw       => (others => '0'),
        pl_clk_100  => clk--,
    );

    process
    begin
        btn <= (others => '0');
        btn(0) <= '1';
        wait until rising_edge(clk);
        btn(0) <= '0';
        wait;
    end process;

end architecture;
