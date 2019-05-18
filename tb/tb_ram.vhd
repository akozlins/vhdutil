library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ram is
end entity;

architecture arch of tb_ram is

    constant CLK_MHZ : positive := 100;
    signal clk, rst_n : std_logic := '0';

    constant W : integer := 16;
    constant N : integer := 4;

    signal addr : std_logic_vector(N-1 downto 0);
    signal dout : std_logic_vector(W-1 downto 0);
    signal din : std_logic_vector(W-1 downto 0);
    signal we : std_logic;

begin

    clk <= not clk after (500 ns / CLK_MHZ);
    rst_n <= '0', '1' after 100 ns;

    i_ram : entity work.ram_sp
    generic map (
        W => W,
        N => N,
        INIT_FILE_HEX => "tb/tb_ram.hex"--,
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
        addr <= (others => '0');
        din <= (others => '0');
        we <= '0';
        wait until rising_edge(rst_n);

        for i in 0 to 2**N-1 loop
            wait until rising_edge(clk);
            addr <= std_logic_vector(to_unsigned(i, N));
            din <= std_logic_vector(to_unsigned(i, W));
            we <= '1';
        end loop;

        for i in 0 to 2**N-1 loop
            wait until rising_edge(clk);
            addr <= std_logic_vector(to_unsigned(i, N));
            we <= '0';
        end loop;

        wait;
    end process;

end architecture;
