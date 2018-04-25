library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top is
end entity;

architecture arch of tb_top is

    constant clk_period : time := 10 ns;

    signal clk : std_logic := '0';
    signal led : std_logic_vector(7 downto 0);
    signal btn : std_logic_vector(4 downto 0) := (others => '0');
    signal sw  : std_logic_vector(7 downto 0) := (others => '0');

begin

    i_top : entity work.top
    port map (
        pl_clk_100  => clk,
        pl_led      => led,
        pl_btn      => btn,
        pl_sw       => sw--;
    );

    -- clock generator
    process
    begin
        clk <= not clk;
        wait for (clk_period / 2);
    end process;

    process
    begin
        -- press button 0
        btn(0) <= '1';
        -- wait for 10 clock cycles
        for i in 0 to 9 loop
            wait until rising_edge(clk);
        end loop;
        -- release button 0
        btn(0) <= '0';

        wait;
    end process;

end architecture;
