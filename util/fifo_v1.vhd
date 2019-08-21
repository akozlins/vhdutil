--
-- single clock fifo
--
-- author : Alexandr Kozlinskiy
-- date : 2018-04-29
--

library ieee;
use ieee.std_logic_1164.all;

entity fifo_v1 is
generic (
    W   : positive := 8;
    N   : positive := 8--;
);
port (
    i_we        : in    std_logic;
    i_wdata     : in    std_logic_vector(W-1 downto 0);
    o_wfull     : out   std_logic;
    i_re        : in    std_logic;
    o_rdata     : out   std_logic_vector(W-1 downto 0);
    o_rempty    : out   std_logic;
    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

library ieee;
use ieee.numeric_std.all;

architecture arch of fifo_v1 is

    subtype addr_t is std_logic_vector(N-1 downto 0);
    subtype ptr_t is std_logic_vector(N downto 0);

    constant XOR_FULL : ptr_t := "10" & ( N-2 downto 0 => '0' );

    signal re, we : std_logic;
    signal empty, full : std_logic;
    signal rptr, wptr : ptr_t;

begin

    e_ram : entity work.ram_dp
    generic map (
        W => W,
        N => N--,
    )
    port map (
        a_addr  => rptr(addr_t'range),
        a_rd    => o_rdata,
        b_addr  => wptr(addr_t'range),
        b_rd    => open,
        b_wd    => i_wdata,
        b_we    => we,
        clk     => i_clk--,
    );

    o_rempty <= empty;
    o_wfull <= full;
    re <= ( i_re and not empty );
    we <= ( i_we and not full );

    process(i_clk, i_reset_n)
        variable rptr_v, wptr_v : ptr_t;
    begin
    if ( i_reset_n = '0' ) then
        empty <= '1';
        full <= '1';
        rptr <= (others => '0');
        wptr <= (others => '0');
        --
    elsif rising_edge(i_clk) then
        rptr_v := std_logic_vector(unsigned(rptr) + ("" & re));
        wptr_v := std_logic_vector(unsigned(wptr) + ("" & we));
        rptr <= rptr_v;
        wptr <= wptr_v;

        empty <= work.util.to_std_logic( rptr_v = wptr_v );
        full <= work.util.to_std_logic( (rptr_v xor wptr_v) = XOR_FULL );
        --
    end if; -- rising_edge
    end process;

end architecture;
