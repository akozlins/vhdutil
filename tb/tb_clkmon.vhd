library ieee;
use ieee.std_logic_1164.all;

entity tb_clkmon is
end entity;

architecture arch of tb_clkmon is

    constant CLK_MHZ : positive := 100;
    signal clk, reset_n : std_logic := '0';

    constant TST_MHZ : positive := 30;
    signal tst_clk, tst_ok : std_logic := '0';

begin

    clk <= not clk after (500 ns / CLK_MHZ);
    reset_n <= '0', '1' after 100 ns;

    tst_clk <= not tst_clk after (500 ns / TST_MHZ);

    e_clkmon : entity work.clkmon
    generic map ( CLK_MHZ => CLK_MHZ, TST_MHZ => TST_MHZ )
    port map (
        i_tst_clk => tst_clk,
        o_tst_ok => tst_ok,
        i_reset_n => reset_n,
        i_clk => clk--,
    );

end architecture;
