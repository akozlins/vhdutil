--
-- author : Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 2-port RAM (1 read port and 1 write port)
entity ram_1r1w is
generic (
    DATA_WIDTH_g : positive := 8;
    ADDR_WIDTH_g : positive := 8;
    ALTERA_RAM_STYLE_g : string := "no_rw_check"--;
);
port (
    i_raddr     : in    std_logic_vector(ADDR_WIDTH_g-1 downto 0);
    o_rdata     : out   std_logic_vector(DATA_WIDTH_g-1 downto 0);
    i_rclk      : in    std_logic;

    i_waddr     : in    std_logic_vector(ADDR_WIDTH_g-1 downto 0);
    i_wdata     : in    std_logic_vector(DATA_WIDTH_g-1 downto 0);
    i_we        : in    std_logic;
    i_wclk      : in    std_logic--;
);
end entity;

architecture arch of ram_1r1w is

    type ram_t is array (natural range <>) of std_logic_vector(DATA_WIDTH_g-1 downto 0);
    signal ram : ram_t(2**ADDR_WIDTH_g-1 downto 0);
    attribute ramstyle : string;
    attribute ramstyle of ram : signal is ALTERA_RAM_STYLE_g;

begin

    process(i_wclk)
    begin
    if rising_edge(i_wclk) then
        if ( i_we = '1' ) then
            ram(to_integer(unsigned(i_waddr))) <= i_wdata;
        end if;
    end if;
    end process;

    process(i_rclk)
    begin
    if rising_edge(i_rclk) then
        o_rdata <= ram(to_integer(unsigned(i_raddr)));
    end if;
    end process;

end architecture;
