library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;

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

    constant W : positive := 10 + positive(ceil(log2(real(work.util.max(1, TST_MHZ / CLK_MHZ)))));

    -- tst_clk clock domain
    signal tst_rst_n : std_logic;
    -- gray counter
    signal tst_gcnt : std_logic_vector(W-1 downto 0);

    constant GCNT_OK : std_logic_vector(4 downto 0) := "10000";

    -- clk clock domain
    signal cnt : integer range 0 to 2**W * CLK_MHZ / TST_MHZ - 1;
    signal gcnt : std_logic_vector(GCNT_OK'range);
    signal tst_arst_n : std_logic;

begin

    -- sync tst_gcnt from tst_clk to clk
    i_gcnt : entity work.sync_chain
    generic map ( W => GCNT_OK'length )
    port map (
        d => tst_gcnt(tst_gcnt'left downto tst_gcnt'left - GCNT_OK'left),
        q => gcnt,
        rst_n => rst_n,
        clk => clk--,
    );

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        cnt <= 0;
        tst_arst_n <= '0';
        tst_ok <= '0';
        --
    elsif rising_edge(clk) then
        cnt <= cnt + 1;
        if ( cnt = 2**W * CLK_MHZ / TST_MHZ - 1 ) then
            cnt <= 0;
            if ( tst_arst_n = '1' ) then
                tst_ok <= work.util.to_std_logic(gcnt = GCNT_OK);
            end if;
            tst_arst_n <= not tst_arst_n;
        end if;
        --
    end if;
    end process;

    -- sync tst_arst from clk to tst_clk
    i_tst_rst : entity work.reset_sync
    port map ( rstout_n => tst_rst_n, rst_n => tst_arst_n, clk => tst_clk );

    process(tst_clk, tst_rst_n)
    begin
    if ( tst_rst_n = '0' ) then
        tst_gcnt <= (others => '0');
        --
    elsif rising_edge(tst_clk) then
        tst_gcnt <= work.util.bin2gray(work.util.gray2bin(tst_gcnt) + 1);
        --
    end if;
    end process;

end architecture;
