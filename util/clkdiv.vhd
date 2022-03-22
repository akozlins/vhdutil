--
-- author : Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;

-- clock divider
-- period_{o_clk} = P * period_{i_clk}
entity clkdiv is
generic (
    -- period
    P : positive := 1--;
);
port (
    o_clk       : out   std_logic;
    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of clkdiv is

    signal clk1, clk2 : std_logic;
    signal cnt1, cnt2 : integer range 0 to P-1;

begin

    gen_none :
    if ( P = 1 ) generate
        o_clk <= i_clk;
    end generate;

    gen_even :
    if ( P > 1 and P mod 2 = 0 ) generate
        o_clk <= clk1;

        process(i_clk, i_reset_n)
        begin
        if ( i_reset_n /= '1' ) then
            clk1 <= '0';
            cnt1 <= 0;
            --
        elsif rising_edge(i_clk) then
            if ( cnt1 = P/2-1 or cnt1 = P-1 ) then
                cnt1 <= 0;
                clk1 <= not clk1;
            else
                cnt1 <= cnt1 + 1;
            end if;
            --
        end if;
        end process;

    end generate;

    gen_odd :
    if ( P > 1 and P mod 2 = 1 ) generate
        o_clk <= clk1 and clk2;

        process(i_clk, i_reset_n)
        begin
        if ( i_reset_n /= '1' ) then
            clk1 <= '0';
            cnt1 <= 0;
            --
        elsif rising_edge(i_clk) then
            if ( cnt1 = 0 or cnt1 = (P+1)/2 ) then
                clk1 <= not clk1;
            end if;
            if ( cnt1 = P-1 ) then
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;
            end if;
            --
        end if;
        end process;

        process(i_clk, i_reset_n)
        begin
        if ( i_reset_n /= '1' ) then
            clk2 <= '0';
            cnt2 <= 0;
            --
        elsif falling_edge(i_clk) then
            if ( cnt2 = 0 or cnt2 = (P+1)/2 ) then
                clk2 <= not clk2;
            end if;
            if ( cnt2 = P-1 ) then
                cnt2 <= 0;
            else
                cnt2 <= cnt2 + 1;
            end if;
            --
        end if;
        end process;

    end generate;

end architecture;
