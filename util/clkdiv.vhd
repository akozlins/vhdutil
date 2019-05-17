--
-- Author: Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;

-- clock divider
-- period_{clkout} = P * period_{clk}
entity clkdiv is
    generic (
        -- period
        P : positive := 1--;
    );
    port (
        clkout  :   out std_logic;
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of clkdiv is

    signal clkout1, clkout2 : std_logic;
    signal cnt1, cnt2 : integer range 0 to P-1;

begin

    gen_none :
    if ( P = 1 ) generate
        clkout <= clk;
    end generate;

    gen_even :
    if ( P > 1 and P mod 2 = 0 ) generate
        clkout <= clkout1;

        process(clk, rst_n)
        begin
        if rst_n = '0' then
            clkout1 <= '0';
            cnt1 <= 0;
            --
        elsif rising_edge(clk) then
            if ( cnt1 = P/2-1 or cnt1 = P-1 ) then
                cnt1 <= 0;
                clkout1 <= not clkout1;
            else
                cnt1 <= cnt1 + 1;
            end if;
            --
        end if;
        end process;

    end generate;

    gen_odd :
    if ( P > 1 and P mod 2 = 1 ) generate
        clkout <= clkout1 and clkout2;

        process(clk, rst_n)
        begin
        if rst_n = '0' then
            clkout1 <= '0';
            cnt1 <= 0;
            --
        elsif rising_edge(clk) then
            if ( cnt1 = 0 or cnt1 = (P+1)/2 ) then
                clkout1 <= not clkout1;
            end if;
            if ( cnt1 = P-1 ) then
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;
            end if;
            --
        end if;
        end process;

        process(clk, rst_n)
        begin
        if rst_n = '0' then
            clkout2 <= '0';
            cnt2 <= 0;
            --
        elsif falling_edge(clk) then
            if ( cnt2 = 0 or cnt2 = (P+1)/2 ) then
                clkout2 <= not clkout2;
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
