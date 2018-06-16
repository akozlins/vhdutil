library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- reset synchronizer
entity reset_sync is
    generic (
        N : positive := 1--;
    );
    port (
        rstout_n    :   out std_logic;
        arst_n      :   in  std_logic;
        clk         :   in  std_logic--;
    );
end entity;

architecture arch of reset_sync is

    signal ff : std_logic_vector(N downto 0);

begin

    rstout_n <= ff(N);

    process(clk, arst_n)
    begin
    if ( arst_n = '0' ) then
        ff <= (others => '0');
    elsif rising_edge(clk) then
        ff <= ff(N-1 downto 0) & '1';
    end if;
    end process;

end architecture;
