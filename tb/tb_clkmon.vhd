library ieee;
use ieee.std_logic_1164.all;

entity tb_clkmon is
end entity;

architecture arch of tb_clkmon is

    constant CLK_MHZ : positive := 100;
    signal clk, rst_n : std_logic;

    constant TST_MHZ : positive := 30;
    signal tst_clk, tst_ok : std_logic;

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

    process
    begin
        tst_clk <= '0';
        for i in 1 to TST_MHZ*1000 loop
            wait for (500 ns / TST_MHZ);
            tst_clk <= not tst_clk;
        end loop;
        wait;
    end process;

    i_clkmon : entity work.clkmon
    generic map ( CLK_MHZ => CLK_MHZ, TST_MHZ => TST_MHZ )
    port map (
        tst_clk => tst_clk,
        tst_ok => tst_ok,
        rst_n => rst_n,
        clk => clk--,
    );

end architecture;
