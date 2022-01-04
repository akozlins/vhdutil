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
    g_N : natural := 1--;
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

    signal data0, data1 : std_logic_vector(g_DATA_WIDTH-1 downto 0);
    signal empty0, empty1 : std_logic;

begin

    generate_N_0 : if ( g_N = 0 ) generate
        o_rdata <= i_fifo_rdata;
        o_fifo_re <= i_re;
        o_rempty <= i_fifo_rempty;
    end generate;

    generate_N_1 : if ( g_N > 0 ) generate
        o_rdata <=
            data0 when ( empty0 = '0' ) else
            data1 when ( empty1 = '0' ) else
            (others => '0');
        o_fifo_re <= (empty0 or empty1) and not i_fifo_rempty;
        o_rempty <= empty0 and empty1;

        process(i_clk, i_reset_n)
        begin
        if ( i_reset_n = '0' ) then
            data0 <= (others => '0');
            data1 <= (others => '0');
            empty0 <= '1';
            empty1 <= '1';
        elsif rising_edge(i_clk) then
            if ( empty0 = '1' ) then
                data0 <= data1;
                empty0 <= empty1;
            end if;
            if ( empty0 = '1' or empty1 = '1' ) then
                data1 <= i_fifo_rdata;
                if ( i_fifo_rempty = '1' ) then
                    data1 <= (others => '0');
                end if;
                empty1 <= i_fifo_rempty;
            end if;

            if ( i_re = '1' ) then
                data0 <= (others => '0');
                empty0 <= '1';
            end if;
        end if;
        end process;
    end generate;

end architecture;
