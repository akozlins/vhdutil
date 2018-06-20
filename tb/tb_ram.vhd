library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ram is
end entity;

architecture arch of tb_ram is

    constant clk_period : time := 10 ns;

    constant W : integer := 16;
    constant N : integer := 4;

    signal addr : std_logic_vector(N-1 downto 0);
    signal dout : std_logic_vector(W-1 downto 0);
    signal din : std_logic_vector(W-1 downto 0);
    signal we : std_logic := '0';
    signal clk : std_logic := '0';

begin

    i_ram : entity work.ram_sp
    generic map (
        W => W,
        N => N,
        INIT_FILE_HEX => "../tb/tb_ram.hex"--,
    )
    port map (
        addr => addr,
        rd => dout,
        wd => din,
        we => we,
        clk => clk--,
    );

    process
    begin
        clk <= not clk;
        wait for (clk_period / 2);
    end process;

    process
    begin
        for i in 0 to 9 loop
            wait until rising_edge(clk);
        end loop;

        for i in 0 to 2**N-1 loop
            addr <= std_logic_vector(to_unsigned(i, N));
            din <= std_logic_vector(to_unsigned(i, W));
            we <= '1';
            wait until rising_edge(clk);
        end loop;

        for i in 0 to 2**N-1 loop
            we <= '0';
            addr <= std_logic_vector(to_unsigned(i, N));
            wait until rising_edge(clk);
        end loop;

        wait;
    end process;

end architecture;
