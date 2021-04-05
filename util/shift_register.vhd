library ieee;
use ieee.std_logic_1164.all;

entity shift_register is
generic (
    g_W : positive;
    g_INIT : std_logic_vector := "1"--;
);
port (
    o_q         : out   std_logic_vector(g_W-1 downto 0);
    i_d         : in    std_logic;

    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of shift_register is

    signal q : std_logic_vector(g_W-1 downto 0);

begin

    o_q <= q;

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        q <= (others => '0');
        q(g_INIT'length-1 downto 0) <= g_INIT;
        --
    elsif rising_edge(i_clk) then
        q <= q(g_W-2 downto 0) & i_d;
        --
    end if;
    end process;

end architecture;
