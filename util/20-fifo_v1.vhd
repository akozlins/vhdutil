library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

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

    signal re_i, we_i : std_logic;
    signal empty_i, full_i : std_logic;
    signal rptr, wptr : std_logic_vector(N-1 downto 0);

begin

    i_ram : entity work.ram_dp
    generic map (
        W => W,
        N => N--,
    )
    port map (
        a_addr  => rptr,
        a_rd    => rd,
        b_addr  => wptr,
        b_rd    => open,
        b_wd    => wd,
        b_we    => we_i,
        clk     => clk--,
    );

    empty <= empty_i;
    full <= full_i;
    re_i <= ( re and not empty_i );
    we_i <= ( we and not full_i );

    process(clk, rst_n)
        variable rptr_i : std_logic_vector(rptr'range);
        variable wptr_i : std_logic_vector(wptr'range);
    begin
    if ( rst_n = '0' ) then
        empty_i <= '1';
        full_i <= '0';
        rptr <= (others => '0');
        wptr <= (others => '0');
        --
    elsif rising_edge(clk) then
        rptr_i := rptr;
        wptr_i := wptr;

        if ( re_i = '1' ) then
            rptr_i := rptr_i + 1;
        end if;

        if ( we_i = '1' ) then
            wptr_i := wptr_i + 1;
        end if;

        if ( re_i = '1' and we_i = '0' ) then
            empty_i <= work.util.bool_to_logic( rptr_i = wptr_i and full_i = '0' );
            full_i <= '0';
        end if;
        if ( we_i = '1' and re_i = '0' ) then
            empty_i <= '0';
            full_i <= work.util.bool_to_logic( wptr_i = rptr_i and empty_i = '0' );
        end if;

        rptr <= rptr_i;
        wptr <= wptr_i;
        --
    end if; -- rising_edge
    end process;

end architecture;
