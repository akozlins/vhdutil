library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- reset synchronizer
entity reset_sync is
    generic (
        N : positive := 2--;
    );
    port (
        rstout_n    :   out std_logic;
        rst_n       :   in  std_logic;
        clk         :   in  std_logic--;
    );
end entity;

architecture arch of reset_sync is

    signal rst_n_q : std_logic_vector(N downto 0);

begin

    rstout_n <= rst_n_q(N);

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        rst_n_q <= (others => '0');
    elsif rising_edge(clk) then
        rst_n_q <= rst_n_q(N-1 downto 0) & '1';
    end if;
    end process;


end architecture;
