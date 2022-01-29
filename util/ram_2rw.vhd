--
-- author : Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- true dual port ram (2 read/write ports)
--
--              _______         _______
-- addr     XXX|ADDR1  |XXXXXXX|ADDR2  |XXXXXXXXXXX
--                      _______         _______
-- rdata    XXXXXXXXXXX|DATA*  |XXXXXXX|DATA2  |XXX
--              _______
-- wdata    XXX|DATA3  |XXXXXXXXXXXXXXXXXXXXXXXXXXX
--              _______
-- we       ___|       |___________________________
--              ___     ___     ___     ___     ___
-- clk      ___|   |___|   |___|   |___|   |___|   
--
entity ram_tdp is
generic (
    g_ADDR_WIDTH : positive := 8;
    g_DATA_WIDTH : positive := 8;
    g_ALTERA_RAM_STYLE : string := "no_rw_check"--;
);
port (
    i_addr0     : in    std_logic_vector(g_ADDR_WIDTH-1 downto 0);
    i_wdata0    : in    std_logic_vector(g_DATA_WIDTH-1 downto 0) := (others => '0');
    i_we0       : in    std_logic := '0';
    o_rdata0    : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_clk0      : in    std_logic;

    i_addr1     : in    std_logic_vector(g_ADDR_WIDTH-1 downto 0);
    i_wdata1    : in    std_logic_vector(g_DATA_WIDTH-1 downto 0) := (others => '0');
    i_we1       : in    std_logic := '0';
    o_rdata1    : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_clk1      : in    std_logic--;
);
end entity;

architecture arch of ram_tdp is

    constant c_DEPTH : positive := 2**g_ADDR_WIDTH;

    type ram_t is array (natural range <>) of std_logic_vector(g_DATA_WIDTH-1 downto 0);
    signal ram : ram_t(c_DEPTH-1 downto 0);
    attribute ramstyle : string;
    attribute ramstyle of ram : signal is g_ALTERA_RAM_STYLE;

begin

    -- process with two clock in sensitivity list and two clocked if blocks
    -- is required by ghdl to infer true dual port ram
    process(i_clk0, i_clk1)
    begin
    -- port 0
    if rising_edge(i_clk0) then
        if is_x(i_addr0) then
            o_rdata0 <= (others => 'X');
        else
            if ( i_we0 = '1' ) then
                ram(to_integer(unsigned(i_addr0))) <= i_wdata0;
            end if;
            o_rdata0 <= ram(to_integer(unsigned(i_addr0)));
        end if;
    end if;
    -- port 1
    if rising_edge(i_clk1) then
        if is_x(i_addr1) then
            o_rdata1 <= (others => 'X');
        else
            if ( i_we1 = '1' ) then
                ram(to_integer(unsigned(i_addr1))) <= i_wdata1;
            end if;
            o_rdata1 <= ram(to_integer(unsigned(i_addr1)));
        end if;
    end if;
    end process;

end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 2-port mixed-width RAM (2 read/write ports)
entity ram_2rw is
generic (
    g_DATA0_WIDTH : positive := 8;
    g_ADDR0_WIDTH : positive := 8;
    g_DATA1_WIDTH : positive := 8;
    g_ADDR1_WIDTH : positive := 8;
    g_ALTERA_RAM_STYLE : string := "no_rw_check"--;
);
port (
    i_addr0     : in    std_logic_vector(g_ADDR0_WIDTH-1 downto 0);
    o_rdata0    : out   std_logic_vector(g_DATA0_WIDTH-1 downto 0);
    i_wdata0    : in    std_logic_vector(g_DATA0_WIDTH-1 downto 0) := (others => '0');
    i_we0       : in    std_logic := '0';
    i_clk0      : in    std_logic;

    i_addr1     : in    std_logic_vector(g_ADDR1_WIDTH-1 downto 0);
    o_rdata1    : out   std_logic_vector(g_DATA1_WIDTH-1 downto 0);
    i_wdata1    : in    std_logic_vector(g_DATA1_WIDTH-1 downto 0) := (others => '0');
    i_we1       : in    std_logic := '0';
    i_clk1      : in    std_logic--;
);
end entity;

architecture arch of ram_2rw is

begin

    assert ( g_DATA0_WIDTH * 2**g_ADDR0_WIDTH = g_DATA1_WIDTH * 2**g_ADDR1_WIDTH ) report "" severity failure;

    -- g_DATA0_WIDTH < g_DATA1_WIDTH
    generate_0 : for i in g_DATA1_WIDTH/g_DATA0_WIDTH-1 downto 0 generate
        e_ram : entity work.ram_tdp
        generic map (
            g_DATA_WIDTH => g_DATA0_WIDTH,
            g_ADDR_WIDTH => g_ADDR0_WIDTH,
            g_ALTERA_RAM_STYLE => g_ALTERA_RAM_STYLE--,
        )
        port map (
            i_addr0 => i_addr0,
            o_rdata0 => o_rdata0, -- FIXME:
            i_wdata0 => i_wdata0,
            i_we0 => i_we0,
            i_clk0 => i_clk0,

            i_addr1 => std_logic_vector(to_unsigned(i,g_ADDR0_WIDTH-g_ADDR1_WIDTH)) & i_addr1,
            o_rdata1 => o_rdata1((i+1)*g_DATA0_WIDTH-1 downto i*g_DATA0_WIDTH),
            i_wdata1 => i_wdata1((i+1)*g_DATA0_WIDTH-1 downto i*g_DATA0_WIDTH),
            i_we1 => i_we1,
            i_clk1 => i_clk1--,
        );
    end generate;

    -- g_DATA1_WIDTH < g_DATA0_WIDTH
    generate_1 : for i in g_DATA0_WIDTH/g_DATA1_WIDTH-1 downto 0 generate
        e_ram : entity work.ram_tdp
        generic map (
            g_DATA_WIDTH => g_DATA1_WIDTH,
            g_ADDR_WIDTH => g_ADDR1_WIDTH,
            g_ALTERA_RAM_STYLE => g_ALTERA_RAM_STYLE--,
        )
        port map (
            i_addr0 => std_logic_vector(to_unsigned(i,g_ADDR1_WIDTH-g_ADDR0_WIDTH)) & i_addr0,
            o_rdata0 => o_rdata0((i+1)*g_DATA1_WIDTH-1 downto i*g_DATA1_WIDTH),
            i_wdata0 => i_wdata0((i+1)*g_DATA1_WIDTH-1 downto i*g_DATA1_WIDTH),
            i_we0 => i_we0,
            i_clk0 => i_clk0,

            i_addr1 => i_addr1,
            o_rdata1 => o_rdata1, -- FIXME:
            i_wdata1 => i_wdata1,
            i_we1 => i_we1,
            i_clk1 => i_clk1--,
        );
    end generate;

end architecture;
