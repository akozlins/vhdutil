library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util.all;

entity reg_file_v1 is
    generic (
        W   : integer := 8; -- word width in bits
        N   : integer := 2--; -- addr bits (2**N words)
    );
    port (
        a_addr  :   in  std_logic_vector(N-1 downto 0);
        b_addr  :   in  std_logic_vector(N-1 downto 0);
        c_addr  :   in  std_logic_vector(N-1 downto 0);
        a_rd    :   out std_logic_vector(W-1 downto 0);
        b_rd    :   out std_logic_vector(W-1 downto 0);
        c_rd    :   out std_logic_vector(W-1 downto 0);
        c_wd    :   in  std_logic_vector(W-1 downto 0);
        c_we    :   in  std_logic;
        areset  :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of reg_file_v1 is

    type ram_t is array (0 to 2**N-1) of std_logic_vector(W-1 downto 0);
    signal ram : ram_t;

begin

    process(clk, areset)
    begin
    if areset = '1' then
        ram <= (others => (others => '0'));
    elsif rising_edge(clk) then
        if c_we = '1' and unsigned(c_addr) /= 0 then
            ram(to_integer(unsigned(c_addr))) <= c_wd;
        end if;
    end if; -- rising_edge
    end process;

    a_rd <= ram(to_integer(unsigned(a_addr)));
    b_rd <= ram(to_integer(unsigned(b_addr)));
    c_rd <= ram(to_integer(unsigned(c_addr)));

end architecture;
