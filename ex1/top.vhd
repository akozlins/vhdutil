library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity top is
    Port (
        clk     :   in  std_logic;
        led_out :   out std_logic_vector(7 downto 0)
    );
end top;

architecture arch of top is

    signal cnt_i : std_logic_vector(31 downto 0);

begin

    led_out <= cnt_i(31 downto 24);

    p : process
    begin
    if rising_edge(clk) then
        cnt_i <= cnt_i + 1;
        wait for 1 ns;
    end if;
    end process p;

end arch;
