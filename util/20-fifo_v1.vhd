--
-- single clock fifo
--
-- Author: Alexandr Kozlinskiy
-- Date: 2018-04-29
--

library ieee;
use ieee.std_logic_1164.all;

entity fifo_v1 is
    generic (
        W   : positive := 8;
        N   : positive := 8--;
    );
    port (
        we      :   in  std_logic;
        wd      :   in  std_logic_vector(W-1 downto 0);
        full    :   out std_logic;
        re      :   in  std_logic;
        rd      :   out std_logic_vector(W-1 downto 0);
        empty   :   out std_logic;
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned."+";

architecture arch of fifo_v1 is

    subtype addr_t is std_logic_vector(N-1 downto 0);
    subtype ptr_t is std_logic_vector(N downto 0);

    constant XOR_FULL : ptr_t := ( N => '1', others => '0' );

    signal re_i, we_i : std_logic;
    signal empty_i, full_i : std_logic;
    signal rptr, wptr : ptr_t;

begin

    i_ram : entity work.ram_dp
    generic map (
        W => W,
        N => N--,
    )
    port map (
        a_addr  => rptr(addr_t'range),
        a_rd    => rd,
        b_addr  => wptr(addr_t'range),
        b_rd    => open,
        b_wd    => wd,
        b_we    => we_i,
        clk     => clk--,
    );

    empty <= empty_i;
    full <= full_i;
    re_i <= ( re and not empty_i );
    we_i <= ( we and not full_i );

    process(clk, rst_n)
        variable rptr_v : std_logic_vector(rptr'range);
        variable wptr_v : std_logic_vector(wptr'range);
    begin
    if ( rst_n = '0' ) then
        empty_i <= '1';
        full_i <= '0';
        rptr <= (others => '0');
        wptr <= (others => '0');
        --
    elsif rising_edge(clk) then
        rptr_v := rptr + re_i;
        wptr_v := wptr + we_i;
        rptr <= rptr_v;
        wptr <= wptr_v;

        empty_i <= work.util.to_std_logic( rptr_v = wptr_v );
        full_i <= work.util.to_std_logic( (rptr_v xor wptr_v) = XOR_FULL );
        --
    end if; -- rising_edge
    end process;

end architecture;
