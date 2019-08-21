--
-- author : Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;

-- single port ram
entity ram_sp is
generic (
    W   : positive := 8;
    N   : positive := 8;
    INIT_FILE_HEX : string := ""--;
);
port (
    i_addr  : in    std_logic_vector(N-1 downto 0);
    o_rdata : out   std_logic_vector(W-1 downto 0);
    i_we    : in    std_logic;
    i_wdata : in    std_logic_vector(W-1 downto 0);
    i_clk   : in    std_logic--;
);
end entity;

architecture arch of ram_sp is
begin

    e_ram : entity work.ram_dp
    generic map (
        W => W,
        N => N,
        INIT_FILE_HEX => INIT_FILE_HEX--,
    )
    port map (
        a_addr  => i_addr,
        a_rd    => open,
        b_addr  => i_addr,
        b_rd    => o_rdata,
        b_wd    => i_wdata,
        b_we    => i_we,
        clk     => i_clk--,
    );

end architecture;
