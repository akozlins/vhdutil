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
    signal clk_200, rst_200_n, clk_200_locked : std_logic;

    signal btn_i : std_logic_vector(pl_btn'range);

    signal dbg_i : std_logic_vector(15 downto 0);

begin

    clk_100 <= pl_clk_100;

    i_rst_100_n : entity work.reset_sync
    port map ( rstout_n => rst_100_n, arst_n => not pl_btn(0), clk => clk_100 );

    i_clk_200 : entity work.ip_clk
    generic map ( M => 8, D => 4 )
    port map (
        clkout => clk_200,
        locked => clk_200_locked,
        rst_n => rst_100_n,
        clk => clk_100--,
    );

    i_rst_200_n : entity work.reset_sync
    port map ( rstout_n => rst_200_n, arst_n => rst_100_n and clk_200_locked, clk => clk_200 );

    i_clk_200_ok : entity work.clkmon
    generic map (
        TST_MHZ => 200,
        CLK_MHZ => 100--,
    )
    port map (
        tst_clk => clk_200,
        tst_ok => pl_led(6),
        rst_n => rst_100_n,
        clk => clk_100--,
    );

    i_clk_200_hz : entity work.clkdiv
    generic map (
        P => 200 * 10**6--;
    )
    port map (
        clkout => pl_led(7),
        rst_n => rst_200_n,
        clk => clk_200--,
    );

    i_cpu : entity work.cpu16_v4
    port map (
        dbg_out => dbg_i,
        dbg_in => (others => '-'),
        clk => clk_200,
        rst_n => rst_200_n--,
    );

    pl_led(3 downto 0) <= dbg_i(11 downto 8);

end architecture;
