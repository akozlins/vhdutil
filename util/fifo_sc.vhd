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
-- - Fall-Through
--
entity fifo_sc is
generic (
    DATA_WIDTH_g : positive := 8;
    ADDR_WIDTH_g : positive := 8--;
);
port (
    o_rdata     : out   std_logic_vector(DATA_WIDTH_g-1 downto 0);
    i_rack      : in    std_logic;
    o_rempty    : out   std_logic;

    i_wdata     : in    std_logic_vector(DATA_WIDTH_g-1 downto 0);
    i_we        : in    std_logic;
    o_wfull     : out   std_logic;

    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

library ieee;
use ieee.numeric_std.all;

architecture arch of fifo_sc is

    type ram_t is array (2**ADDR_WIDTH_g-1 downto 0) of std_logic_vector(DATA_WIDTH_g-1 downto 0);
    signal ram : ram_t;

    subtype addr_t is unsigned(ADDR_WIDTH_g-1 downto 0);
    subtype ptr_t is unsigned(ADDR_WIDTH_g downto 0);

    constant XOR_FULL_c : ptr_t := "10" & ( ADDR_WIDTH_g-2 downto 0 => '0' );

    signal rack, we : std_logic;
    signal rempty, wfull : std_logic;
    signal rptr, wptr, rptr_next, wptr_next : ptr_t := (others => '0');

begin

    -- psl default clock is rising_edge(i_clk) ;
    -- psl assert always ( i_rack = '0' or o_rempty = '0' ) ;
    -- psl assert always ( i_we = '0' or o_wfull = '0' ) ;



    o_rempty <= rempty;
    o_wfull <= wfull;

    -- check for underflow and overflow
    rack <= ( i_rack and not rempty );
    we <= ( i_we and not wfull );

    rptr_next <= rptr + ("" & rack);
    wptr_next <= wptr + ("" & we);

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        rempty <= '1';
        wfull <= '1';
        rptr <= (others => '0');
        wptr <= (others => '0');
        --
    elsif rising_edge(i_clk) then
        -- advance pointers
        rptr <= rptr_next;
        wptr <= wptr_next;

        rempty <= work.util.to_std_logic( rptr_next = wptr_next );
        wfull <= work.util.to_std_logic( (rptr_next xor wptr_next) = XOR_FULL_c );

        -- infer RAM
        if ( we = '1' ) then
            ram(to_integer(wptr(addr_t'range))) <= i_wdata;
        end if;
        -- TODO : use ramstyle no_rw_check, simulate new data
        --
    end if; -- rising_edge
    end process;

    -- synchronous read (new data)
    o_rdata <= ram(to_integer(rptr(addr_t'range)));

end architecture;
