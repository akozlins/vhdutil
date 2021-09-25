library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fifo_sc is
generic (
    g_STOP_TIME_US : integer := 1;
    g_SEED : integer := 0;
    g_CLK_MHZ : real := 1000.0--;
);
end entity;

architecture arch of tb_fifo_sc is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    signal wdata, rdata : std_logic_vector(11 downto 0) := (others => '0');
    signal we, wfull, re, rempty : std_logic := '0';

    signal DONE : std_logic_vector(1 downto 0) := (others => '0');

    signal prbs : work.util.slv32_array_t(0 to 1023);

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (1.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    process
        variable lfsr : std_logic_vector(31 downto 0);
    begin
        lfsr := std_logic_vector(to_signed(g_SEED, lfsr'length));
        for i in prbs'range loop
            for j in prbs(0)'range loop
                lfsr := lfsr sll 1;
                lfsr(0) := work.util.xor_reduce(lfsr and "10000000001000000000000000000011");
                prbs(i)(j) <= lfsr(0);
            end loop;
        end loop;
        wait;
    end process;

    e_fifo : entity work.fifo_sc
    generic map (
        g_DATA_WIDTH => wdata'length,
        g_ADDR_WIDTH => 3--,
    )
    port map (
        o_wfull     => wfull,
        i_we        => we,
        i_wdata     => wdata,

        o_rempty    => rempty,
        i_rack      => re,
        o_rdata     => rdata,

        i_reset_n   => reset_n,
        i_clk       => clk--,
    );

    -- write
    we <= reset_n and not wfull and prbs(cycle / 32)(cycle mod 32);

    process
    begin
        for i in 0 to 2**wdata'length-1 loop
            wait until rising_edge(clk) and we = '1';
--            report "write: wdata = " & work.util.to_hstring(wdata);
            wdata <= std_logic_vector(unsigned(wdata) + 1);
        end loop;

        DONE(0) <= '1';
        wait;
    end process;

    -- read
    re <= reset_n and not rempty and prbs(cycle / 32 + prbs'length/2)(cycle mod 32);

    process
    begin
        for i in 0 to 2**rdata'length-1 loop
            wait until rising_edge(clk) and re = '1';
--            report "read: rdata = " & work.util.to_hstring(rdata);
            assert ( rdata = std_logic_vector(to_unsigned(i, rdata'length)) ) severity error;
        end loop;

        DONE(1) <= '1';
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
