--
-- author : Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 1-port RAM (1 read/write port)
entity ram_1rw is
generic (
    g_DATA_WIDTH : positive := 8;
    g_ADDR_WIDTH : positive := 8;
    g_ALTERA_RAM_STYLE : string := "no_rw_check"--;
);
port (
    i_addr      : in    std_logic_vector(g_ADDR_WIDTH-1 downto 0);

    o_rdata     : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_wdata     : in    std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_we        : in    std_logic;

    i_clk       : in    std_logic--;
);
end entity;

architecture arch of ram_1rw is

begin

    e_ram : entity work.ram_1r1w
    generic map (
        g_DATA_WIDTH => g_DATA_WIDTH,
        g_ADDR_WIDTH => g_ADDR_WIDTH,
        g_ALTERA_RAM_STYLE => g_ALTERA_RAM_STYLE--,
    )
    port map (
        i_raddr     => i_addr,
        o_rdata     => o_rdata,
        i_rclk      => i_clk,

        i_waddr     => i_addr,
        i_wdata     => i_wdata,
        i_we        => i_we,
        i_wclk      => i_clk--,
    );

end architecture;
