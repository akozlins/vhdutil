library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity tb_ram is
end tb_ram;

architecture arch of tb_ram is

    constant clk_period : time := 10 ns;

    constant W : integer := 16;
    constant N : integer := 4;

    signal clk : std_logic := '0';
    signal address : std_logic_vector(N-1 downto 0);
    signal rdata : std_logic_vector(W-1 downto 0);
    signal wdata : std_logic_vector(W-1 downto 0);
    signal we : std_logic := '0';

begin

    ram_i : ram
    generic map (
        W => W,
        N => N,
        INIT_FILE_HEX => "ram.hex"--,
    )
    port map (
        clk => clk,
        address => address,
        rdata => rdata,
        wdata => wdata,
        we => we--,
    );

    process
    begin
        clk <= not clk;
        wait for (clk_period / 2);
    end process;

    process
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        for i in 0 to 2**N-1 loop
            address <= std_logic_vector(to_unsigned(i, N));
            wdata <= std_logic_vector(to_unsigned(i, W));
            we <= '1';
            wait until rising_edge(clk);
        end loop;

        for i in 0 to 2**N-1 loop
            we <= '0';
            address <= std_logic_vector(to_unsigned(i, N));
            wait until rising_edge(clk);
        end loop;

        wait;
    end process;

end arch;
