library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity reg_file is
    generic (
        W   : integer := 8; -- word width in bits
        N   : integer := 2--; -- addr bits (2**N words)
    );
    port (
        clk     :   in  std_logic;
        a_addr  :   in  std_logic_vector(N-1 downto 0);
        b_addr  :   in  std_logic_vector(N-1 downto 0);
        c_addr  :   in  std_logic_vector(N-1 downto 0);
        a_dout  :   out std_logic_vector(W-1 downto 0);
        b_dout  :   out std_logic_vector(W-1 downto 0);
        c_dout  :   out std_logic_vector(W-1 downto 0);
        c_din   :   in  std_logic_vector(W-1 downto 0);
        c_we    :   in  std_logic;
        areset  :   in  std_logic--;
    );
end entity reg_file;

architecture arch of reg_file is

    type ram_t is array (0 to 2**N-1) of std_logic_vector(W-1 downto 0);
    signal ram : ram_t;

begin

    process(clk, areset)
    begin
    if areset = '1' then
        ram <= (others => (others => '0'));
    elsif rising_edge(clk) then
        if c_we = '1' and c_addr /= 0 then
            ram(to_integer(unsigned(c_addr))) <= c_din;
        end if;
    end if; -- rising_edge
    end process;

    a_dout <= ram(to_integer(unsigned(a_addr)));
    b_dout <= ram(to_integer(unsigned(b_addr)));
    c_dout <= ram(to_integer(unsigned(c_addr)));

end;
