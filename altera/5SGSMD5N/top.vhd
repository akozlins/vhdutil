library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
port (
    user_led_g                  : out   std_logic_vector(7 downto 0);

    clkin_50                    : in    std_logic--;
);
end entity;

architecture arch of top is

    signal clk_50 : std_logic;

    signal cnt_50 : unsigned(31 downto 0);

begin

    clk_50 <= clkin_50;

    process(clk_50)
    begin
    if rising_edge(clk_50) then
        cnt_50 <= cnt_50 + 1;
    end if;
    end process;

    user_led_g <= not std_logic_vector(cnt_50(31 downto 24));

end architecture;
