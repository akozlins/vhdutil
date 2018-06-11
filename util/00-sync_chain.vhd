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
        data_out    :   out std_logic_vector(W-1 downto 0);
        data_in     :   in  std_logic_vector(W-1 downto 0);
        rst_n       :   in  std_logic;
        clk         :   in  std_logic--;
    );
end entity;

architecture arch of sync_chain is

    type array_t is array (natural range <>) of std_logic_vector(W-1 downto 0);
    signal data_q : array_t(N downto 0);

begin

    data_out <= data_q(N);

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        data_q <= (others => (others => '0'));
    elsif rising_edge(clk) then
        data_q(N downto 1) <= data_q(N-1 downto 0);
        data_q(0) <= data_in;
    end if;
    end process;

end architecture;
