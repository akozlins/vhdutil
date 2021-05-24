library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_spi is
end entity;

architecture arch of tb_spi is

    constant CLK_MHZ : real := 1000.0; -- MHz
    signal clk, reset_n : std_logic := '0';

    signal DONE : std_logic_vector(0 downto 0) := (others => '0');

    signal wdata : std_logic_vector(7 downto 0);
    signal we, wfull, rack, rempty : std_logic := '0';

    signal sdo, sdi : std_logic;

begin

    clk <= not clk after (0.5 us / CLK_MHZ);
    reset_n <= '0', '1' after (1.0 us / CLK_MHZ);

    e_spi_master : entity work.spi_master
    generic map (
        g_N => 1--,
    )
    port map (
        o_ss_n => open,
        o_sck => open,
        o_sdo => sdo,
        i_sdi => sdi,

        i_slave => (others => '1'),

        i_wdata => wdata,
        i_we => we,
        o_wfull => open,

        o_rdata => open,
        i_rack => rack,
        o_rempty => open,

        i_sck_div => X"0010",
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
        wdata <= X"AA";
        we <= '1';

        wait until rising_edge(clk);
        we <= '0';

        wait;
    end process;

end architecture;
