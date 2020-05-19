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
    i_raddr1    : in    std_logic_vector(N-1 downto 0);
    o_rdata1    : out   std_logic_vector(W-1 downto 0);
    i_raddr2    : in    std_logic_vector(N-1 downto 0);
    o_rdata2    : out   std_logic_vector(W-1 downto 0);
    i_waddr     : in    std_logic_vector(N-1 downto 0);
    i_wdata     : in    std_logic_vector(W-1 downto 0);
    i_we        : in    std_logic;
    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of rv32i_reg_file is

    type ram_t is array (natural range <>) of std_logic_vector(W-1 downto 0);
    signal ram : ram_t(0 to 2**N-1);

begin

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        --
    elsif rising_edge(i_clk) then
        if ( i_we = '1' and i_waddr /= (i_waddr'range => '0') ) then
            ram(to_integer(unsigned(i_waddr))) <= i_wdata;
        end if;
    end if; -- rising_edge
    end process;

    o_rdata1 <=
        (others => 'X') when is_x(i_raddr1) else
        (others => '0') when ( i_raddr1 = (i_raddr1'range => '0') ) else
        ram(to_integer(unsigned(i_raddr1)));
    o_rdata2 <=
        (others => 'X') when is_x(i_raddr2) else
        (others => '0') when ( i_raddr2 = (i_raddr2'range => '0') ) else
        ram(to_integer(unsigned(i_raddr2)));

end architecture;
