--
-- fifo read register
--
-- author : Alexandr Kozlinskiy
-- date : 2021-06-11
--

library ieee;
use ieee.std_logic_1164.all;

--
--
--
entity fifo_rreg is
generic (
    g_DATA_WIDTH : positive := 32;
    g_N : natural := 2--;
);
port (
    o_rdata         : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_re            : in    std_logic;
    o_rempty        : out   std_logic;

    i_fifo_rdata    : in    std_logic_vector(g_DATA_WIDTH-1 downto 0);
    o_fifo_re       : out   std_logic;
    i_fifo_rempty   : in    std_logic;

    i_reset_n       : in    std_logic;
    i_clk           : in    std_logic--;
);
end entity;

architecture arch of fifo_rreg is

    type data_array_t is array (natural range <>) of std_logic_vector(i_fifo_rdata'range);
    signal data : data_array_t(-1 to g_N) := (others => (others => '-'));
    signal empty : std_logic_vector(-1 to g_N) := (-1 => '0', others => '1');

begin

    generate_N_0 : if ( g_N = 0 ) generate
        o_rdata <= i_fifo_rdata;
        o_fifo_re <= i_re;
        o_rempty <= i_fifo_rempty;
    end generate;

    generate_N_1 : if ( g_N > 0 ) generate
        o_rdata <= data(0);
        o_fifo_re <= work.util.or_reduce(empty(0 to g_N-1));
        o_rempty <= empty(0);

        process(i_clk, i_reset_n)
        begin
        if ( i_reset_n = '0' ) then
            data <= (others => (others => '-'));
            empty <= (-1 => '0', others => '1');
        elsif rising_edge(i_clk) then
            for i in 0 to g_N-1 loop
                if ( i_re = '1' and empty(0) = '0' ) then
                    -- shift
                    data(i) <= data(i+1);
                    empty(i) <= empty(i+1);
                    if ( empty(i to i+1) = "01" and i < g_N-1 ) then
                        -- fill first empty slot
                        data(i) <= i_fifo_rdata;
                        empty(i) <= i_fifo_rempty;
                    end if;
                else
                    if ( empty(i-1 to i) = "01" ) then
                        data(i) <= i_fifo_rdata;
                        empty(i) <= i_fifo_rempty;
                    end if;
                end if;
            end loop;
        end if;
        end process;
    end generate;

end architecture;
