library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fifo is
end entity;

architecture arch of tb_fifo is

    signal wclk, rclk, reset_n : std_logic := '0';

    signal wdata, rdata : std_logic_vector(15 downto 0) := (others => '0');
    signal wfull, rempty, we, re : std_logic := '0';

begin

    wclk <= not wclk after 5.1 ns;
    rclk <= not rclk after 9.1 ns;
    reset_n <= '0', '1' after 100 ns;

    re <= not rempty;

    e_fifo : entity work.fifo_dc
    generic map (
        W => wdata'length,
        N => 4--,
    )
    port map (
        i_re => re,
        o_rdata => rdata,
        o_rempty => rempty,
        i_rreset_n => reset_n,
        i_rclk => rclk,

        i_we => we,
        i_wdata => wdata,
        o_wfull => wfull,
        i_wreset_n => reset_n,
        i_wclk => wclk--,
    );

    process
        variable i : unsigned(wdata'range) := (others => '0');
    begin
        wait until rising_edge(wclk);
        if ( wfull = '0' and we = '1' ) then
            i := i + 1;
        end if;
        we <= '0';
        if ( wfull = '0' ) then
            wdata <= std_logic_vector(i);
            we <= '1';
        end if;
    end process;

    process
        variable i : unsigned(rdata'range) := (others => '0');
    begin
        wait until rising_edge(rclk);
        if ( rempty = '0' ) then
            report "i = " & work.util.to_string(i) & ", rdata = " & work.util.to_string(rdata);
            assert ( rdata = std_logic_vector(i) ) report "error" severity failure;
            i := i + 1;
        end if;
    end process;

end architecture;
