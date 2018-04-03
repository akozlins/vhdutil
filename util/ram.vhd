library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity ram is
    generic (
        W   : integer := 8;
        N   : integer := 8--;
    );
    port (
        clk     :   in  std_logic;
        address :   in  std_logic_vector(N-1 downto 0);
        rdata   :   out std_logic_vector(W-1 downto 0);
        wdata   :   in  std_logic_vector(W-1 downto 0);
        we      :   in  std_logic--;
    );
end entity ram;

architecture arch of ram is

    type ram_t is array (0 to 2**N-1) of std_logic_vector(W-1 downto 0);
    signal ram : ram_t;

begin

    process(clk)
    begin
    if rising_edge(clk) then
        if(we = '1') then
            ram(to_integer(unsigned(address))) <= wdata;
        end if;
    end if; -- rising_edge
    end process;

    rdata <= ram(to_integer(unsigned(address)));

end;
