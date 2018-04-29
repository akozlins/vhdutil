library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_v1 is
    generic (
        W   : integer := 8;
        N   : integer := 8--;
    );
    port (
        re      :   in  std_logic;
        rd      :   out std_logic_vector(W-1 downto 0);
        empty   :   out std_logic;
        we      :   in  std_logic;
        wd      :   in  std_logic_vector(W-1 downto 0);
        full    :   out std_logic;
        clk     :   in  std_logic;
        rst_n   :   in  std_logic--;
    );
end entity;

architecture arch of fifo_v1 is

    type ram_t is array (natural range <>) of std_logic_vector(W-1 downto 0);
    signal ram : ram_t(2**N-1 downto 0);

    signal re_i, we_i : boolean;
    signal empty_i, full_i : boolean;
    signal rptr, wptr : unsigned(N-1 downto 0);

begin

    empty <= '1' when empty_i else '0';
    full <= '1' when full_i else '0';
    re_i <= ( re = '1' and not empty_i );
    we_i <= ( we = '1' and not full_i );

    process(clk, rst_n)
        variable rptr_i : unsigned(rptr'range);
        variable wptr_i : unsigned(wptr'range);
    begin
    if ( rst_n = '0' ) then
        rd <= (others => '-');
        rptr <= (others => '0');
        wptr <= (others => '0');
        empty_i <= true;
        full_i <= false;
        --
    elsif rising_edge(clk) then
        rptr_i := rptr;
        wptr_i := wptr;

        if ( re_i ) then
            rd <= ram(to_integer(rptr));
            rptr_i := rptr_i + 1;
        end if;

        if ( we_i ) then
            ram(to_integer(wptr)) <= wd;
            wptr_i := wptr_i + 1;
        end if;

        empty_i <= ( rptr_i = wptr_i );
        full_i <= ( wptr_i + 1 = rptr_i );

        rptr <= rptr_i;
        wptr <= wptr_i;
        --
    end if; -- rising_edge
    end process;

end architecture;
