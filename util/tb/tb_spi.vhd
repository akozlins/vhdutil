library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_spi is
generic (
    g_STOP_TIME_US : integer := 1;
    g_SEED : integer := 0;
    g_CLK_MHZ : real := 1000.0--;
);
end entity;

architecture arch of tb_spi is

    signal clk, reset_n : std_logic := '0';

    signal DONE : std_logic_vector(0 downto 0) := (others => '0');

    signal wdata, rdata : std_logic_vector(7 downto 0);
    signal we, wfull, rack, rempty : std_logic := '0';

    signal sdo, sdi : std_logic;

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (1.0 us / g_CLK_MHZ);

    e_spi_master : entity work.spi_master
    generic map (
        g_N => 1--,
    )
    port map (
        o_sclk => open,
        o_sdo => sdo,
        i_sdi => sdi,
        o_ss_n => open,

        i_slave => (others => '1'),

        i_wdata => wdata,
        i_we => we,
        o_wfull => wfull,

        o_rdata => rdata,
        i_rack => rack,
        o_rempty => rempty,

        i_sclk_div => X"0010",
        i_cpol => '0',
        i_sdo_cpha => '0',
        i_sdi_cpha => '0',

        i_reset_n => reset_n,
        i_clk => clk--,
    );

    sdi <= sdo;

    process
    begin
        wait until rising_edge(reset_n);

        wait until rising_edge(clk);
        wdata <= std_logic_vector(to_signed(g_SEED, 32)(7 downto 0));
        we <= '1';

        wait until rising_edge(clk);
        we <= '0';

        wait until rising_edge(clk) and rempty = '0';
        assert ( rdata = wdata ) report "" severity error;

        DONE(0) <= '1';

        wait;
    end process;

    process
    begin
        wait for g_STOP_TIME_US * 1 us;
        if ( DONE = (DONE'range => '1') ) then
            report work.util.sgr(32) & "DONE" & work.util.sgr(0);
        else
            report work.util.sgr(31) & "NOT DONE" & work.util.sgr(0);
        end if;
        assert ( DONE = (DONE'range => '1') ) severity error;
        wait;
    end process;

end architecture;
