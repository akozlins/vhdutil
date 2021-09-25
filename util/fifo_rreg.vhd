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
    -- to user
    o_rdata     : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_re        : in    std_logic;
    o_rempty    : out   std_logic;

    -- from fifo
    i_rdata     : in    std_logic_vector(g_DATA_WIDTH-1 downto 0);
    o_re        : out   std_logic;
    i_rempty    : in    std_logic;

    -- read side reset and clock
    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of fifo_rreg is

    signal rdata : std_logic_vector(o_rdata'range);
    signal re : std_logic;
    signal rempty : std_logic;

begin

    assert ( g_N < 2 ) report "" severity failure;

    o_rdata <= rdata;
    o_re <= re;
    o_rempty <= rempty;

    generate_N_0 : if ( g_N = 0 ) generate
        rdata <= i_rdata;
        re <= i_re;
        rempty <= i_rempty;
    end generate;

    generate_N_1 : if ( g_N = 1 ) generate
        re <= ( i_re or rempty ) and not i_rempty;

        process(i_clk, i_reset_n)
        begin
        if ( i_reset_n = '0' ) then
            rdata <= (others => '0');
            rempty <= '1';
        elsif rising_edge(i_clk) then
            if ( i_re = '1' or rempty = '1' ) then
                rdata <= i_rdata;
                rempty <= i_rempty;
                if ( i_rempty = '1' ) then
                    rdata <= (others => '0');
                end if;
            end if;
        end if;
        end process;
    end generate;

end architecture;
