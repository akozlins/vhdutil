--
-- edge detector
--
-- author : Alexandr Kozlinskiy
-- date : 2019-05-12
--

library ieee;
use ieee.std_logic_1164.all;

entity edge_det is
generic (
    EDGE : integer := 0;
    -- bus width
    W : positive := 1--;
);
port (
    i_d     : in    std_logic_vector(W-1 downto 0);
    o_q     : out   std_logic_vector(W-1 downto 0);
    i_clk   : in    std_logic--;
);
end entity;

architecture arch of edge_det is

    signal d : std_logic_vector(W-1 downto 0);

begin

    process(i_clk)
    begin
    if rising_edge(i_clk) then
        d <= i_d;
        --
    end if;
    end process;

    gen_rising_edge : if EDGE > 0 generate
        o_q <= i_d and not d;
    end generate;

    gen : if EDGE = 0 generate
        o_q <= i_d xor d;
    end generate;

    gen_faling_edge : if EDGE < 0 generate
        o_q <= not i_d and d;
    end generate;

end architecture;
