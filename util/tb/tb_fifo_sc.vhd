library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fifo_sc is
end entity;

architecture arch of tb_fifo_sc is

    constant CLK_MHZ : real := 1000.0; -- MHz
    signal clk, reset_n, reset : std_logic := '0';

    signal wd, rd : std_logic_vector(7 downto 0) := (others => '0');
    signal wfull, rempty, we, rack : std_logic := '0';

    signal DONE : std_logic_vector(1 downto 0) := (others => '0');

begin

    clk <= not clk after (0.5 us / CLK_MHZ);
    reset_n <= '0', '1' after (1.0 us / CLK_MHZ);
    reset <= not reset_n;

    e_fifo : entity work.fifo_sc
    generic map (
        DATA_WIDTH_g => wd'length,
        ADDR_WIDTH_g => 4--,
    )
    port map (
        o_wfull     => wfull,
        i_we        => we,
        i_wdata     => wd,

        o_rempty    => rempty,
        i_rack      => rack,
        o_rdata     => rd,

        i_reset_n   => reset_n,
        i_clk       => clk--,
    );

    process
    begin
        we <= '0';
        wait until rising_edge(reset_n);

        for i in 0 to 2**wd'length-1 loop
            wait until rising_edge(clk) and wfull = '0';
            we <= '1';
            wd <= std_logic_vector(to_unsigned(i, wd'length));

            wait until rising_edge(clk);
            report "i = " & integer'image(i) & ", wd = 0x" & work.util.to_hstring(wd);
            we <= '0';
        end loop;

        for i in 0 to 2**wd'length-1 loop
            wait until rising_edge(clk) and wfull = '0';
            we <= '1';
            wd <= std_logic_vector(to_unsigned(i, wd'length));

            wait until rising_edge(clk);
            report "i = " & integer'image(i) & ", wd = 0x" & work.util.to_hstring(wd);
            we <= '0';

            -- delay write
            wait until rising_edge(clk);
        end loop;

        DONE(0) <= '1';
        wait;
    end process;

    process
    begin
        rack <= '0';
        wait until rising_edge(reset_n);

        for i in 0 to 2**rd'length-1 loop
            wait until rising_edge(clk) and rempty = '0';
            report "i = " & integer'image(i) & ", rd = 0x" & work.util.to_hstring(rd);
            rack <= '1';

            assert ( rd = std_logic_vector(to_unsigned(i, wd'length)) ) severity failure;

            wait until rising_edge(clk);
            rack <= '0';

            -- delay read
            wait until rising_edge(clk);
        end loop;

        for i in 0 to 2**rd'length-1 loop
            wait until rising_edge(clk) and rempty = '0';
            report "i = " & integer'image(i) & ", rd = 0x" & work.util.to_hstring(rd);
            rack <= '1';

            assert ( rd = std_logic_vector(to_unsigned(i, wd'length)) ) severity failure;

            wait until rising_edge(clk);
            rack <= '0';
        end loop;

        DONE(1) <= '1';
        wait;
    end process;

    process
    begin
        wait for 4000 ns;
        assert ( DONE = (DONE'range => '1') ) severity failure;
        wait;
    end process;

end architecture;
