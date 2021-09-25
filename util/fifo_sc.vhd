--
-- single clock fifo
--
-- author : Alexandr Kozlinskiy
-- date : 2019-08-07
--

library ieee;
use ieee.std_logic_1164.all;

--
-- FIFO
-- - Single Clock
-- - Fall-Through (Show-Ahead)
--
entity fifo_sc is
generic (
    g_DATA_WIDTH : positive := 8;
    g_ADDR_WIDTH : positive := 8--;
);
port (
    o_rdata     : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_rack      : in    std_logic;
    o_rempty    : out   std_logic;

    i_wdata     : in    std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_we        : in    std_logic;
    o_wfull     : out   std_logic;

    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

library ieee;
use ieee.numeric_std.all;

architecture arch of fifo_sc is

    subtype addr_t is std_logic_vector(g_ADDR_WIDTH-1 downto 0);
    subtype ptr_t is std_logic_vector(g_ADDR_WIDTH downto 0);

    constant XOR_FULL_c : ptr_t := "10" & ( g_ADDR_WIDTH-2 downto 0 => '0' );

    signal rack, we : std_logic;
    signal rempty, wfull : std_logic;
    signal rptr, wptr, rptr_next, wptr_next : ptr_t := (others => '0');

    signal rdata : std_logic_vector(g_DATA_WIDTH-1 downto 0);

    signal rdw : std_logic;
    signal rdata_rdw : std_logic_vector(g_DATA_WIDTH-1 downto 0);

begin

    -- psl assert always ( i_rack = '0' or rempty = '0' ) @ i_clk ;
    -- psl assert always ( i_we = '0' or wfull = '0' ) @ i_clk ;

    -- psl assert always ( we = '1' |=> rempty = '0' ) @ i_clk ;



    o_rempty <= rempty;
    o_wfull <= wfull;

    -- check for underflow and overflow
    rack <= ( i_rack and not rempty );
    we <= ( i_we and not wfull );

    rptr_next <= std_logic_vector(unsigned(rptr) + ("" & rack));
    wptr_next <= std_logic_vector(unsigned(wptr) + ("" & we));

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        rptr <= (others => '0');
        wptr <= (others => '0');
        rempty <= '1';
        wfull <= '1';
        rdw <= '0';
        --
    elsif rising_edge(i_clk) then
        -- advance pointers
        rptr <= rptr_next;
        wptr <= wptr_next;

        rempty <= work.util.to_std_logic( rptr_next = wptr_next );
        wfull <= work.util.to_std_logic( (rptr_next xor wptr_next) = XOR_FULL_c );

        -- read during write
        rdw <= we and work.util.to_std_logic( rptr_next = wptr );
        rdata_rdw <= i_wdata;
        --
    end if; -- rising_edge
    end process;

    e_ram : entity work.ram_1r1w
    generic map (
        g_DATA_WIDTH => g_DATA_WIDTH,
        g_ADDR_WIDTH => g_ADDR_WIDTH--,
    )
    port map (
        i_raddr         => rptr_next(addr_t'range),
        o_rdata         => rdata,
        i_rclk          => i_clk,

        i_waddr         => wptr(addr_t'range),
        i_wdata         => i_wdata,
        i_we            => we,
        i_wclk          => i_clk--,
    );

    o_rdata <=
        (others => '-') when ( rempty = '1' ) else
        rdata_rdw when ( rdw = '1' ) else
        rdata;

end architecture;
