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
    addr    :   in  std_logic_vector(N-1 downto 0);
    rd      :   out std_logic_vector(W-1 downto 0);
    wd      :   in  std_logic_vector(W-1 downto 0);
    we      :   in  std_logic;
    clk     :   in  std_logic--;
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
        a_addr  => addr,
        a_rd    => open,
        b_addr  => addr,
        b_rd    => rd,
        b_wd    => wd,
        b_we    => we,
        clk     => clk--,
    );

end architecture;
