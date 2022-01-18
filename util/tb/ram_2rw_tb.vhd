library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_2rw_tb is
generic (
    g_STOP_TIME_US : integer := 1;
    g_SEED : integer := 0;
    g_CLK_MHZ : real := 1000.0--;
);
end entity;

architecture arch of ram_2rw_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    signal prbs_array : work.util.slv32_array_t(0 to 1023);
    signal prbs : work.util.slv32_t;
    signal DONE : std_logic_vector(1 downto 0) := (others => '0');

    signal rdata : std_logic_vector(3 downto 0) := (others => '0');

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (1.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    process
        variable lfsr : std_logic_vector(31 downto 0);
    begin
        lfsr := std_logic_vector(to_signed(g_SEED, lfsr'length));
        for i in prbs_array'range loop
            for j in prbs_array(0)'range loop
                lfsr := lfsr sll 1;
                lfsr(0) := work.util.xor_reduce(lfsr and "10000000001000000000000000000011");
                prbs_array(i)(j) <= lfsr(0);
            end loop;
        end loop;
        wait;
    end process;

    prbs <= prbs_array(cycle) when ( cycle < prbs_array'length ) else (others => 'X');

    e_ram : entity work.ram_2rw
    generic map (
        g_ADDR_WIDTH => 4,
        g_DATA_WIDTH => 4--,
    )
    port map (
        i_addr0     => prbs(3 downto 0),
        o_rdata0    => rdata,
        i_wdata0    => prbs(7 downto 4),
        i_we0       => prbs(8),
        i_clk0      => clk,

        i_addr1     => prbs(19 downto 16),
        o_rdata1    => rdata,
        i_wdata1    => prbs(23 downto 20),
--        i_we1       => prbs(24),
        i_clk1      => clk--,
    );

    process
    begin
        wait for g_STOP_TIME_US * 1 us;
        if ( DONE = (DONE'range => '1') ) then
            report work.util.SGR_FG_GREEN & "DONE" & work.util.SGR_RESET;
        else
            report work.util.SGR_FG_RED & "NOT DONE" & work.util.SGR_RESET;
        end if;
        assert ( DONE = (DONE'range => '1') ) severity error;
        wait;
    end process;

end architecture;
