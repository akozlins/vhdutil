library ieee;
use ieee.std_logic_1164.all;

entity tb_cpu is
end entity;

architecture arch of tb_cpu is

    constant CLK_MHZ : positive := 100;
    signal clk, rst_n : std_logic;

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

    i_cpu : entity work.cpu16_v4
    port map (
        dbg_out => open,
        dbg_in => (others => '0'),
        rst_n => rst_n,
        clk => clk--,
    );

end architecture;
