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

    signal fifo_rdata : std_logic_vector(g_DATA_WIDTH-1 downto 0);
    type data_array_t is array (natural range <>) of std_logic_vector(g_DATA_WIDTH-1 downto 0);
    signal data : data_array_t(g_N-1 downto 0);
    signal empty : std_logic_vector(g_N-1 downto 0);

begin

    fifo_rdata <= i_fifo_rdata when ( i_fifo_rempty = '0' ) else (others => '0');

    generate_N_0 : if ( g_N = 0 ) generate
        o_rdata <= fifo_rdata;
        o_fifo_re <= i_re;
        o_rempty <= i_fifo_rempty;
    end generate;

    generate_N_1 : if ( g_N > 0 ) generate
        o_rdata <= data(0);
        o_fifo_re <= work.util.or_reduce(empty) and not i_fifo_rempty;
        o_rempty <= empty(0);

        process(i_clk, i_reset_n)
        begin
        if ( i_reset_n = '0' ) then
            data <= (others => (others => '0'));
            empty <= (others => '1');
        elsif rising_edge(i_clk) then
            if ( i_re = '0' and empty(0) = '0' ) then
                if ( empty(1) = '1' ) then
                    data(1) <= fifo_rdata;
                    empty(1) <= i_fifo_rempty;
                end if;
            elsif ( empty(1) = '0' ) then
                -- read and both not empty
                data(0) <= data(1);
                empty(0) <= empty(1);
                data(1) <= (others => '0');
                empty(1) <= '1';
            else
                -- read and 1 is empty
                -- or both are empty
                data(0) <= fifo_rdata;
                empty(0) <= i_fifo_rempty;
            end if;
        end if;
        end process;
    end generate;

end architecture;
