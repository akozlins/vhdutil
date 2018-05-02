library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gray_counter is
    generic (
        W   : positive := 8--;
    );
    port (
        cnt     :   out std_logic_vector(W-1 downto 0);
        ce      :   in  std_logic;
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of gray_counter is

    signal cnt_i : unsigned(W-1 downto 0);

begin

    process(clk)
    begin
    if ( rst_n = '0' ) then
        cnt_i <= (others => '0');
    elsif ( rising_edge(clk) and ce = '1' ) then
        cnt_i <= cnt_i + 1;
    end if; -- rising_edge
    end process;

    cnt <= std_logic_vector(cnt_i xor ('0' & cnt_i(W-1 downto 1)));

end architecture;
