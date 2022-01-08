--
-- fifo based on registers
--
-- author : Alexandr Kozlinskiy
-- date : 2021-06-11
--

library ieee;
use ieee.std_logic_1164.all;

--
--
--
entity fifo_reg is
generic (
    g_DATA_WIDTH : positive := 32;
    g_N : positive := 2--;
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

architecture arch of fifo_reg is

    type data_array_t is array (natural range <>) of std_logic_vector(g_DATA_WIDTH-1 downto 0);
    signal data : data_array_t(0 to g_N+1) := (others => (others => '-'));
    signal empty : std_logic_vector(0 to g_N+1) := (0 => '0', others => '1');

begin

    -- empty(0) is used when i_rack = '0' and index is 1
    empty(0) <= '0';
    data(0) <= (others => '-');
    -- data(g_N+1) is used when i_rack = '1' and index is g_N
    empty(g_N+1) <= '1';
    data(g_N+1) <= (others => '-');

    -- data(1) contains readable data
    o_rdata <= data(1);
    o_rempty <= empty(1);
    o_wfull <= not empty(g_N);

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        for i in 1 to g_N loop
            data(i) <= (others => '-');
            empty(i) <= '1';
        end loop;
    elsif rising_edge(i_clk) then
        for i in 1 to g_N loop
            if ( i_rack = '1' and empty(1) = '0' ) then
                -- read from data(1) and shift all data left
                data(i) <= data(i+1);
                empty(i) <= empty(i+1);
                -- read from fifo to first empty data
                -- NOTE: do not touch last data (o_wfull is '1')
                if ( empty(i to i+1) = "01" and i < g_N ) then
                    data(i) <= i_wdata;
                    empty(i) <= not i_we;
                end if;
            else
                -- read from fifo to first empty data
                if ( empty(i-1 to i) = "01" ) then
                    data(i) <= i_wdata;
                    empty(i) <= not i_we;
                end if;
            end if;
        end loop;
    end if;
    end process;

end architecture;
