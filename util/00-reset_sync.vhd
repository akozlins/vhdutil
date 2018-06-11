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

begin

    i_sync_chain : entity work.sync_chain
    generic map ( N => N, W => 1 )
    port map (
        data_out(0) => rstout_n,
        data_in(0) => '1',
        rst_n => rst_n,
        clk => clk--,
    );

end architecture;
