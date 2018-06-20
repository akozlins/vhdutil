library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- clock monitor
-- ...
entity clkmon is
    generic (
        TST_MHZ : positive := 100;
        CLK_MHZ : positive := 100--;
    );
    port (
        tst_clk :   in  std_logic;
        tst_ok  :   out std_logic;
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of clkmon is

    constant W : positive := 8 + work.util.vector_width(CLK_MHZ / TST_MHZ);

    -- clk clock domain
    signal cnt : std_logic_vector(W-1 downto 0);
    signal ff0, ff1 : std_logic;

    -- tst_clk clock domain
    signal tst_rst_n : std_logic;
    signal tst_clk_slow : std_logic;

begin

    -- sync tst_clk_slow to clk domain
    i_ff_sync : entity work.ff_sync
    generic map ( W => 1 )
    port map ( d(0) => tst_clk_slow, q(0) => ff0, rst_n => rst_n, clk => clk );

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        cnt <= (others => '0');
        ff1 <= '0';
        tst_ok <= '0';
        --
    elsif rising_edge(clk) then
        -- sync tst_clk_slow to clk domain
        ff1 <= ff0;

        if ( ff0 /= ff1 ) then
            cnt <= (others => '0');
            tst_ok <= work.util.and_reduce(cnt(cnt'left downto cnt'left - 4));
        elsif ( cnt = 2**W - 1 ) then
            tst_ok <= '0';
        else
            cnt <= cnt + 1;
        end if;
        --
    end if;
    end process;

    -- sync rst_n to tst_clk domain
    i_tst_rst : entity work.reset_sync
    port map ( rstout_n => tst_rst_n, arst_n => rst_n, clk => tst_clk );

    i_tst_clk_slow : entity work.clkdiv
    generic map (
        P => 2**W * 63 / 64 * TST_MHZ / CLK_MHZ * 2--,
    )
    port map (
        clkout => tst_clk_slow,
        rst_n => tst_rst_n,
        clk => tst_clk--,
    );

end architecture;
