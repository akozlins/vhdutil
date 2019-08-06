library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ram is
end entity;

architecture arch of tb_ram is

    constant CLK_MHZ : positive := 100;
    signal clk, reset_n : std_logic := '0';

    constant W : integer := 4;
    constant N : integer := 4;

    signal i : unsigned(N downto 0);

    signal addr : std_logic_vector(N-1 downto 0);
    signal rd, wd : std_logic_vector(W-1 downto 0);
    signal we : std_logic;

begin

    clk <= not clk after (500 ns / CLK_MHZ);
    reset_n <= '0', '1' after 100 ns;

    e_ram : entity work.ram_sp
    generic map (
        W => W,
        N => N,
        INIT_FILE_HEX => "tb/tb_ram.hex"--,
    )
    port map (
        addr => addr,
        rd => rd,
        wd => wd,
        we => we,
        clk => clk--,
    );

    process(clk, reset_n)
    begin
    if ( reset_n = '0' ) then
        i <= (others => '0');
        we <= '0';
        --
    elsif rising_edge(clk) then
        addr <= std_logic_vector(i(addr'range));

        if ( i(N) = '0' ) then
            wd <= std_logic_vector(i(wd'range));
            we <= '1';
        else
            we <= '0';
            assert ( rd = addr(rd'range) ) severity error;
        end if;

        i <= i + 1;
        --
    end if;
    end process;

end architecture;
