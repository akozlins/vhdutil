library ieee;
use ieee.std_logic_1164.all;

-- dual clock fifo
entity fifo_dc is
    generic (
        W   : positive := 8;
        N   : positive := 8--;
    );
    port (
        we      :   in  std_logic;
        wd      :   in  std_logic_vector(W-1 downto 0);
        wfull   :   out std_logic;
        wrst_n  :   in  std_logic;
        wclk    :   in  std_logic;
        re      :   in  std_logic;
        rd      :   out std_logic_vector(W-1 downto 0);
        rempty  :   out std_logic;
        rrst_n  :   in  std_logic;
        rclk    :   in  std_logic--;
    );
end entity;

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned."+";

architecture arch of fifo_dc is

    subtype addr_t is std_logic_vector(N-1 downto 0);
    subtype ptr_t is std_logic_vector(N downto 0);

    constant XOR_FULL : ptr_t := ( N downto N-1 => '1', others => '0' );

    signal re_i, we_i : std_logic;
    signal rempty_i, wfull_i : std_logic;
    signal rptr, rgray, rwgray, wptr, wgray, wrgray : ptr_t;

    attribute KEEP : string;
    attribute KEEP of rgray : signal is "true";
    attribute KEEP of wgray : signal is "true";

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

    i_rwgray : entity work.ff_sync
    generic map ( W => rwgray'length )
    port map (
        d => wgray,
        q => rwgray,
        rst_n => rrst_n,
        clk => rclk--,
    );

    process(rclk, rrst_n)
        variable rptr_v, rgray_v : std_logic_vector(ptr_t'range);
    begin
    if ( rrst_n = '0' ) then
        rempty_i <= '1';
        rptr <= (others => '0');
        rgray <= (others => '0');
        --
    elsif rising_edge(rclk) then
        rptr_v := rptr + re_i;
        rgray_v := work.util.bin2gray(rptr_v);
        rptr <= rptr_v;
        rgray <= rgray_v;

        rempty_i <= work.util.to_std_logic( rgray_v = rwgray );
        --
    end if; -- rising_edge
    end process;

    i_wrgray : entity work.ff_sync
    generic map ( W => wrgray'length )
    port map (
        d => rgray,
        q => wrgray,
        rst_n => wrst_n,
        clk => wclk--,
    );

    process(wclk, wrst_n)
        variable wptr_v, wgray_v : std_logic_vector(ptr_t'range);
    begin
    if ( wrst_n = '0' ) then
        wfull_i <= '0';
        wptr <= (others => '0');
        wgray <= (others => '0');
        --
    elsif rising_edge(wclk) then
        wptr_v := wptr + we_i;
        wgray_v := work.util.bin2gray(wptr_v);
        wptr <= wptr_v;
        wgray <= wgray_v;

        wfull_i <= work.util.to_std_logic( (wgray_v xor wrgray) = XOR_FULL );
        --
    end if; -- rising_edge
    end process;

end architecture;
