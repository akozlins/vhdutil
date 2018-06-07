library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;

entity clkmon is
    generic (
        TST_MHZ : positive := 125;
        CLK_MHZ : positive := 100;
        K       : positive := 1000--;
    );
    port (
        tst_clk :   in  std_logic;
        tst_hz  :   out std_logic;
        tst_ok  :   out std_logic;
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of clkmon is

    constant Wtst : positive := positive(ceil(log2(real(TST_MHZ*K))));

    signal tst_rst_n : std_logic;
    signal tst_cnt, tst_gcnt : std_logic_vector(Wtst-1 downto 0);

    constant Wclk : positive := positive(ceil(log2(real(CLK_MHZ*K))));

    signal cnt : std_logic_vector(Wclk-1 downto 0);
    signal gcnt_q0 : std_logic_vector(tst_gcnt'range);
    signal gcnt_q1 : std_logic_vector(tst_gcnt'range);

begin

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        cnt <= (others => '0');
        gcnt_q0 <= (others => '0');
        gcnt_q1 <= (others => '0');
        tst_rst_n <= '0';
        tst_ok <= '0';
        --
    elsif rising_edge(clk) then
        gcnt_q0 <= tst_gcnt;
        gcnt_q1 <= gcnt_q0;

        cnt <= cnt + 1;
        if ( cnt = CLK_MHZ * K - 1 ) then
            cnt <= (others => '0');
            if ( tst_rst_n = '1' ) then
                tst_ok <= work.util.bool_to_logic(work.util.gray2bin(gcnt_q1) > TST_MHZ*K/2);
            end if;
            tst_rst_n <= not tst_rst_n;
        end if;
        --
    end if;
    end process;

    process(tst_clk, tst_rst_n)
    begin
    if ( tst_rst_n = '0' ) then
        tst_gcnt <= (others => '0');
        --
    elsif rising_edge(tst_clk) then
        tst_cnt <= work.util.gray2bin(tst_gcnt) + 1;
        tst_gcnt <= work.util.bin2gray(work.util.gray2bin(tst_gcnt) + 1);
        --
    end if;
    end process;

    -- 1 Hz test clock
    i_tst_clk_hz :
    entity work.clkdiv
    generic map (
        P => TST_MHZ * 1000 * K--;
    )
    port map (
        clkout => tst_hz,
        rst_n => rst_n,
        clk => tst_clk--,
    );

end architecture;
