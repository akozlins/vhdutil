--
-- Author : Alexandr Kozlinskiy
-- Date : 2019-05-27
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rv32i_reg_file is
    generic (
        W   : positive := 32; -- word width in bits
        N   : positive := 5--; -- addr bits (2**N words)
    );
    port (
        raddr1  :   in  std_logic_vector(N-1 downto 0);
        rdata1  :   out std_logic_vector(W-1 downto 0);
        raddr2  :   in  std_logic_vector(N-1 downto 0);
        rdata2  :   out std_logic_vector(W-1 downto 0);
        waddr   :   in  std_logic_vector(N-1 downto 0);
        wdata   :   in  std_logic_vector(W-1 downto 0);
        we      :   in  std_logic;
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of rv32i_reg_file is

    type ram_t is array (natural range <>) of std_logic_vector(W-1 downto 0);
    signal ram : ram_t(0 to 2**N-1);

begin

    process(clk, rst_n)
    begin
    if rising_edge(clk) then
        if ( we = '1' and waddr /= (waddr'range => '0') ) then
            ram(to_integer(unsigned(waddr))) <= wdata;
        end if;
    end if; -- rising_edge
    end process;

    rdata1 <= ram(to_integer(unsigned(raddr1))) when ( raddr1 /= (raddr1'range => '0') ) else (others => '0');
    rdata2 <= ram(to_integer(unsigned(raddr2))) when ( raddr2 /= (raddr2'range => '0') ) else (others => '0');

end architecture;
