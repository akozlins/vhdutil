library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ff (chain) synchronizer
entity ff_sync is
    generic (
        -- bus width
        W : positive := 1;
        -- number of stages
        N : positive := 1--;
    );
    port (
        d       :   in  std_logic_vector(W-1 downto 0);
        q       :   out std_logic_vector(W-1 downto 0);
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of ff_sync is

    type ff_array_t is array (natural range <>) of std_logic_vector(d'range);
    signal ff : ff_array_t(N downto 0);

begin

    q <= ff(N);

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        ff <= (others => (others => '0'));
    elsif rising_edge(clk) then
        ff <= ff(N-1 downto 0) & d;
    end if;
    end process;

end architecture;
