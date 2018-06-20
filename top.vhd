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

    constant CLK_MHZ : positive := 50;

    signal clk, rst_n : std_logic;

    signal btn_i : std_logic_vector(pl_btn'range);
    signal dbg_i : std_logic_vector(15 downto 0);

begin

    clk_100 <= pl_clk_100;

    i_rst_100_n : entity work.reset_sync
    port map ( rstout_n => rst_100_n, arst_n => not pl_btn(0), clk => clk_100 );

    i_clk : entity work.clkdiv
    generic map (
        P => 100 / CLK_MHZ--,
    )
    port map (
        clkout => clk,
        rst_n => rst_100_n,
        clk => clk_100--,
    );

    i_clk_ok : entity work.clkmon
    generic map (
        TST_MHZ => CLK_MHZ,
        CLK_MHZ => 100--,
    )
    port map (
        tst_clk => clk,
        tst_ok => pl_led(6),
        rst_n => rst_100_n,
        clk => clk_100--,
    );

    i_rst : entity work.reset_sync
    port map ( rstout_n => rst_n, arst_n => rst_100_n, clk => clk );

    i_clk_hz : entity work.clkdiv
    generic map (
        P => CLK_MHZ * 10**6--;
    )
    port map (
        clkout => pl_led(7),
        rst_n => rst_n,
        clk => clk--,
    );

    i_btn : entity work.debouncer
    generic map (
        W => pl_btn'length,
        N => 16#FFFF#--,
    )
    port map (
        d => pl_btn,
        q => btn_i,
        rst_n => rst_n,
        clk => clk--,
    );

    i_cpu : entity work.cpu16_v4
    port map (
        dbg_out => dbg_i,
        dbg_in => (others => '-'),
        clk => clk_100,
        rst_n => rst_100_n--,
    );

    pl_led(3 downto 0) <= dbg_i(11 downto 8);

end architecture;
