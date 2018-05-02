library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file_dp is
    generic (
        W   : positive := 8; -- word width in bits
        N   : positive := 2--; -- addr bits (2**N words)
    );
    port (
        a_addr  :   in  std_logic_vector(N-1 downto 0);
        a_rd    :   out std_logic_vector(W-1 downto 0);
        b_addr  :   in  std_logic_vector(N-1 downto 0);
        b_rd    :   out std_logic_vector(W-1 downto 0);
        b_wd    :   in  std_logic_vector(W-1 downto 0);
        b_we    :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of reg_file_dp is

    type ram_t is array (0 to 2**N-1) of std_logic_vector(W-1 downto 0);
    signal ram : ram_t := (
        0 => (others => '0'),
        others => (others => '-')
    );

begin

    process(clk)
    begin
    if rising_edge(clk) then
        if ( b_we = '1' and unsigned(b_addr) /= 0 ) then
            ram(to_integer(unsigned(b_addr))) <= b_wd;
        end if;
    end if; -- rising_edge
    end process;

    a_rd <= ram(to_integer(unsigned(a_addr)));
    b_rd <= ram(to_integer(unsigned(b_addr)));

end architecture;
