library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity fifo_dc is
    generic (
        W   : integer := 8;
        N   : integer := 8--;
    );
    port (
        re      :   in  std_logic;
        rd      :   out std_logic_vector(W-1 downto 0);
        rempty  :   out std_logic;
        rclk    :   in  std_logic;
        rrst_n  :   in  std_logic;
        we      :   in  std_logic;
        wd      :   in  std_logic_vector(W-1 downto 0);
        wfull   :   out std_logic;
        wclk    :   in  std_logic;
        wrst_n  :   in  std_logic--;
    );
end entity;

architecture arch of fifo_dc is

    subtype addr_t is std_logic_vector(N-1 downto 0);
    subtype ptr_t is std_logic_vector(N downto 0);

    constant XOR_FULL : ptr_t := ( N downto N-1 => '1', others => '0' );

    signal re_i, we_i : std_logic;
    signal rempty_i, wfull_i : std_logic;
    signal rptr, wptr, rptr_next, wptr_next : ptr_t;
    signal rgray, wgray : ptr_t;
    signal rwgray_q0, rwgray_q1, wrgray_q0, wrgray_q1 : ptr_t;

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
        clk     => wclk--,
    );

    rempty <= rempty_i;
    wfull <= wfull_i;
    re_i <= ( re and not rempty_i );
    we_i <= ( we and not wfull_i );

    process(rclk, rrst_n)
        variable rptr_v, rgray_v : std_logic_vector(ptr_t'range);
    begin
    if ( rrst_n = '0' ) then
        rempty_i <= '1';
        rptr <= (others => '0');
        rgray <= (others => '0');
        rwgray_q0 <= (others => '0');
        rwgray_q1 <= (others => '0');
        --
    elsif rising_edge(rclk) then
        rptr_v := rptr + re_i;
        rgray_v := rptr_v xor work.util.shift_right(rptr_v, 1);
        rptr <= rptr_v;
        rgray <= rgray_v;

        rwgray_q0 <= wgray;
        rwgray_q1 <= rwgray_q0;
        rempty_i <= work.util.bool_to_logic( rgray_v = rwgray_q1 );
        --
    end if; -- rising_edge
    end process;

    process(wclk, wrst_n)
        variable wptr_v, wgray_v : std_logic_vector(ptr_t'range);
    begin
    if ( wrst_n = '0' ) then
        wfull_i <= '0';
        wptr <= (others => '0');
        wgray <= (others => '0');
        wrgray_q0 <= (others => '0');
        wrgray_q1 <= (others => '0');
        --
    elsif rising_edge(wclk) then
        wptr_v := wptr + we_i;
        wgray_v := wptr_v xor work.util.shift_right(wptr_v, 1);
        wptr <= wptr_v;
        wgray <= wgray_v;

        wrgray_q0 <= rgray;
        wrgray_q1 <= wrgray_q0;
        wfull_i <= work.util.bool_to_logic( (wgray_v xor wrgray_q1) = XOR_FULL );
        --
    end if; -- rising_edge
    end process;

end architecture;
