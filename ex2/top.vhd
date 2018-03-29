library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity top is
    Port (
        clk     :   in  std_logic;
--        reset   :   in  std_logic;
        led_out :   out std_logic_vector(7 downto 0);
        btn_in  :   in std_logic_vector(0 downto 0)
    );
end top;

architecture arch of top is

    signal cnt_i : std_logic_vector(31 downto 0);
    signal reset_i : std_logic;

begin

    led_out <= cnt_i(31 downto 24);
    reset_i <= btn_in(0);

    p : process
    begin
    if rising_edge(clk) then
    if reset_i = '1' then
        cnt_i <= (others => '0');
    else
        cnt_i <= cnt_i + 1;
        wait for 1 ns;
    end if;
    end if; -- rising_edge(clk)
    end process p;

end arch;
