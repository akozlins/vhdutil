library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fifo is
end entity;

architecture arch of tb_fifo is

    signal wclk, rclk, rst_n : std_logic := '0';

    signal wd, rd : std_logic_vector(15 downto 0) := (others => '0');
    signal wfull, rempty, we, re : std_logic := '0';

begin

    wclk <= not wclk after 5.1 ns;
    rclk <= not rclk after 9.1 ns;
    rst_n <= '0', '1' after 100 ns;

    re <= not rempty;

    i_fifo : entity work.fifo_dc
    generic map (
        W => wd'length,
        N => 4--,
    )
    port map (
        we => we,
        wd => wd,
        wfull => wfull,
        wrst_n => rst_n,
        wclk => wclk,
        re => re,
        rd => rd,
        rempty => rempty,
        rrst_n => rst_n,
        rclk => rclk--,
    );

    process
        variable i : unsigned(wd'range) := (others => '0');
    begin
        wait until rising_edge(wclk);
        if ( wfull = '0' and we = '1' ) then
            i := i + 1;
        end if;
        we <= '0';
        if ( wfull = '0' ) then
            wd <= std_logic_vector(i);
            we <= '1';
        end if;
    end process;

    process
        variable i : unsigned(rd'range) := (others => '0');
    begin
        wait until rising_edge(rclk);
        if ( rempty = '0' ) then
            report "i = " & work.util.to_string(i) & ", rd = " & work.util.to_string(rd);
            assert ( rd = std_logic_vector(i) ) report "error" severity failure;
            i := i + 1;
        end if;
    end process;

end architecture;
