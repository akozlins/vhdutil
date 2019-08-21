--
-- author : Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;

-- flip-flop synchronizer
entity ff_sync is
generic (
    -- bus width
    W : positive := 1;
    -- number of stages
    N : positive := 1--;
);
port (
    i_d         : in    std_logic_vector(W-1 downto 0);
    o_q         : out   std_logic_vector(W-1 downto 0);
    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of ff_sync is

    type ff_array_t is array (N downto 0) of std_logic_vector(W-1 downto 0);
    signal ff : ff_array_t;

    -- xilinx
    attribute KEEP : string;
    attribute KEEP of ff : signal is "true";
    attribute ASYNC_REG : string;
    attribute ASYNC_REG of ff : signal is "TRUE";

    -- altera
    attribute PRESERVE : boolean;
    attribute PRESERVE of ff : signal is true;
    attribute ALTERA_ATTRIBUTE : string;
    attribute ALTERA_ATTRIBUTE of ff : signal is "-name SYNCHRONIZER_IDENTIFICATION ""FORCED IF ASYNCHRONOUS""";

begin

    o_q <= ff(N);

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        ff <= (others => (others => '0'));
        --
    elsif rising_edge(i_clk) then
        ff <= ff(N-1 downto 0) & i_d;
        --
    end if;
    end process;

end architecture;
