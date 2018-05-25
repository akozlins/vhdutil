library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    Port (
        pl_clk_100  :   in  std_logic;
        pl_led      :   out std_logic_vector(7 downto 0);
        pl_btn      :   in  std_logic_vector(4 downto 0);
        pl_sw       :   in  std_logic_vector(7 downto 0)--;
    );
end entity;

architecture arch of top is

    signal rst_n : std_logic;

    signal btn_i : std_logic_vector(pl_btn'range);
    signal dbg_i : std_logic_vector(15 downto 0);

begin

    i_rst : entity work.debouncer
    generic map (
        N => 1,
        C => X"FF"--,
    )
    port map (
        input(0) => '1',
        output(0) => rst_n,
        rst_n => not pl_btn(0),
        clk => pl_clk_100--,
    );

    i_btn : entity work.debouncer
    generic map (
        N => pl_btn'length,
        C => X"FFFF"--,
    )
    port map (
        input => pl_btn,
        output => btn_i,
        rst_n => rst_n,
        clk => pl_clk_100--,
    );

    i_cpu : entity work.cpu16_v4
    port map (
        dbg_out => dbg_i,
        dbg_in => (others => '-'),
        clk => pl_clk_100,
        rst_n => rst_n--,
    );

    pl_led <= dbg_i(15 downto 8);

end architecture;
