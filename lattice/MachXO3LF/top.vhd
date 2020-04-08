library ieee;
use ieee.std_logic_1164.all;

entity top is
port (
    o_led       : out   std_logic_vector(7 downto 0);
    i_sw        : in    std_logic_vector(3 downto 0);

    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of top is

    signal reset_n : std_logic;

    signal dbg : std_logic_vector(31 downto 0);

begin

    e_reset_n : entity work.reset_sync
    port map ( o_reset_n => reset_n, i_reset_n => i_reset_n, i_clk => i_clk );

    process(i_clk, reset_n)
    begin
    if ( reset_n = '1' ) then
--        o_led <= (others => '0');
        --
    elsif rising_edge(i_clk) then
--        o_led <= (others => '0');
--        o_led(3 downto 0) <= i_sw;
        --
    end if;
    end process;

    o_led <= dbg(7 downto 0);

    e_cpu : entity work.rv32i_cpu_v1
    port map (
        dbg_out => dbg,
        dbg_in => (others => '-'),
        clk => i_clk,
        rst_n => reset_n--,
    );

end architecture;
