library ieee;
use ieee.std_logic_1164.all;

-- dual port ram
entity ram_dp is
    generic (
        W   : positive := 8;
        N   : positive := 8;
        INIT_FILE_HEX : string := ""--;
    );
    port (
        a_addr  :   in  std_logic_vector(N-1 downto 0);
        a_rd    :   out std_logic_vector(W-1 downto 0);
        b_addr  :   in  std_logic_vector(N-1 downto 0);
        b_rd    :   out std_logic_vector(W-1 downto 0);
        b_wd    :   in  std_logic_vector(W-1 downto 0);
        b_we    :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

library ieee;
use ieee.numeric_std.all;

architecture arch of ram_dp is

    type ram_t is array (natural range <>) of std_logic_vector(W-1 downto 0);

    function ram_read (
        data : in std_logic_vector--;
    ) return ram_t is
        variable ram : ram_t(2**N-1 downto 0);
    begin
        for i in ram'range loop
            ram(i) := data(W-1+i*W downto i*W);
        end loop;
        return ram;
    end function;

    signal ram : ram_t(2**N-1 downto 0) := ram_read(work.util.read_hex(INIT_FILE_HEX, 2**N, W));

begin

    process(clk)
    begin
    if rising_edge(clk) then
        if ( b_we = '1' ) then
            ram(to_integer(unsigned(b_addr))) <= b_wd;
        end if;
    end if; -- rising_edge
    end process;

    a_rd <= ram(to_integer(unsigned(a_addr)));
    b_rd <= ram(to_integer(unsigned(b_addr)));

end architecture;
