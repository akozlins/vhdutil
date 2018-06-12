library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- synchronizer chain
entity sync_chain is
    generic (
        W : positive := 8;
        N : positive := 2--;
    );
    port (
        d       :   in  std_logic_vector(W-1 downto 0);
        q       :   out std_logic_vector(W-1 downto 0);
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of sync_chain is

    type array_t is array (natural range <>) of std_logic_vector(d'range);
    signal chain : array_t(N downto 0);

begin

    q <= chain(N);

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        chain <= (others => (others => '0'));
    elsif rising_edge(clk) then
        chain <= chain(N-1 downto 0) & d;
    end if;
    end process;

end architecture;
