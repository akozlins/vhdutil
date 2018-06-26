library ieee;
use ieee.std_logic_1164.all;

entity tb_top is
end entity;

architecture arch of tb_top is

    constant CLK_MHZ : positive := 100;
    signal clk, rst_n : std_logic;

    signal btn : std_logic_vector(4 downto 0);

begin

    process
    begin
        clk <= '0';
        for i in 1 to CLK_MHZ*2000 loop
            wait for (500 ns / CLK_MHZ);
            clk <= not clk;
        end loop;
        wait;
    end process;

    process
    begin
        rst_n <= '0';
        for i in 1 to 10 loop
            wait until rising_edge(clk);
        end loop;
        rst_n <= '1';
        wait;
    end process;

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
