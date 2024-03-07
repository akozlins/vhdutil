--
-- double clock fifo
--
-- author : Alexandr Kozlinskiy
-- date : 2018-05-02
--

library ieee;
use ieee.std_logic_1164.all;

entity fifo_dc is
generic (
    g_ADDR_WIDTH : positive := 8;
    g_DATA_WIDTH : positive := 8--;
);
port (
    i_we        : in    std_logic;
    i_wdata     : in    std_logic_vector(g_DATA_WIDTH-1 downto 0);
    o_wfull     : out   std_logic;
    i_wreset_n  : in    std_logic;
    i_wclk      : in    std_logic;
    i_re        : in    std_logic;
    o_rdata     : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    o_rempty    : out   std_logic;
    i_rreset_n  : in    std_logic;
    i_rclk      : in    std_logic--;
);
end entity;

library ieee;
use ieee.numeric_std.all;

architecture arch of fifo_dc is

    subtype addr_t is std_logic_vector(g_ADDR_WIDTH-1 downto 0);
    subtype ptr_t is std_logic_vector(g_ADDR_WIDTH downto 0);

    constant XOR_FULL : ptr_t := "11" & ( g_ADDR_WIDTH-2 downto 0 => '0' );

    signal re, we : std_logic;
    signal rempty, wfull : std_logic;
    signal rptr, rgray, rwgray, wptr, wgray, wrgray : ptr_t := (others => '0');

    attribute KEEP : string;
    attribute KEEP of rgray : signal is "true";
    attribute KEEP of wgray : signal is "true";

begin

    -- psl assert always ( i_re = '0' or rempty = '0' ) @ i_rclk;
    -- psl assert always ( i_we = '0' or wfull = '0' ) @ i_wclk;

    -- psl assert always ( wfull = '1' |=> i_we = '0' ) @ i_wclk;
    -- psl assert always ( rempty = '1' |=> i_re = '0' ) @ i_rclk;



    e_ram : entity work.ram_1r1w
    generic map (
        g_DATA_WIDTH => g_DATA_WIDTH,
        g_ADDR_WIDTH => g_ADDR_WIDTH--,
    )
    port map (
        i_raddr => rptr(addr_t'range),
        o_rdata => o_rdata,
        i_rclk  => i_wclk,
        i_waddr => wptr(addr_t'range),
        i_wdata => i_wdata,
        i_we    => we,
        i_wclk  => i_wclk--,
    );

    o_rempty <= rempty;
    o_wfull <= wfull;
    re <= ( i_re and not rempty );
    we <= ( i_we and not wfull );

    e_rwgray : entity work.ff_sync
    generic map ( W => rwgray'length )
    port map (
        i_d => wgray,
        o_q => rwgray,
        i_reset_n => i_rreset_n,
        i_clk => i_rclk--,
    );

    process(i_rclk, i_rreset_n)
        variable rptr_v, rgray_v : ptr_t;
    begin
    if ( i_rreset_n = '0' ) then
        rempty <= '1';
        rptr <= (others => '0');
        rgray <= (others => '0');
        --
    elsif rising_edge(i_rclk) then
        rptr_v := std_logic_vector(unsigned(rptr) + ("" & re));
        rgray_v := work.util.bin2gray(rptr_v);
        rptr <= rptr_v;
        rgray <= rgray_v;

        rempty <= work.util.to_std_logic( rgray_v = rwgray );
        --
    end if; -- rising_edge
    end process;

    e_wrgray : entity work.ff_sync
    generic map ( W => wrgray'length )
    port map (
        i_d => rgray,
        o_q => wrgray,
        i_reset_n => i_wreset_n,
        i_clk => i_wclk--,
    );

    process(i_wclk, i_wreset_n)
        variable wptr_v, wgray_v : ptr_t;
    begin
    if ( i_wreset_n = '0' ) then
        wfull <= '1';
        wptr <= (others => '0');
        wgray <= (others => '0');
        --
    elsif rising_edge(i_wclk) then
        wptr_v := std_logic_vector(unsigned(wptr) + ("" & we));
        wgray_v := work.util.bin2gray(wptr_v);
        wptr <= wptr_v;
        wgray <= wgray_v;

        wfull <= work.util.to_std_logic( (wgray_v xor wrgray) = XOR_FULL );
        --
    end if; -- rising_edge
    end process;

end architecture;
