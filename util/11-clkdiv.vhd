library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clkdiv_half is
    generic (
        -- counter reset value
        R : natural := 0;
        -- half period
        P : positive := 1--;
    );
    port (
        clkout  :   out std_logic;
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of clkdiv_half is

    signal clkout_i : std_logic;

    function max (
        l, r: integer
    ) return integer is
    begin
        if l > r then
            return l;
        else
            return r;
        end if;
    end function;

    constant W : positive := positive(ceil(log2(real(max(P,2)))));
    signal cnt : unsigned(W-1 downto 0);

begin

    clkout <= clkout_i;

    process(clk, rst_n)
    begin
    if rst_n = '0' then
        clkout_i <= '0';
        cnt <= to_unsigned(R, W);
        --
    elsif rising_edge(clk) then
        cnt <= cnt + 1;
        if ( cnt = P - 1 ) then
            clkout_i <= not clkout_i;
            cnt <= (others => '0');
        end if;
        --
    end if;
    end process;

end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

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

begin

    gen_none :
    if ( P = 1 ) generate
        clkout <= clk;
    end generate;

    gen_even :
    if ( P > 1 and P mod 2 = 0 ) generate
        i_clkdiv_even :
        entity work.clkdiv_half
        generic map (
            P => P/2--,
        )
        port map (
            clkout => clkout,
            rst_n => rst_n,
            clk => clk--,
        );
    end generate;

    gen_odd :
    if ( P > 1 and P mod 2 = 1 ) generate
        clkout <= clkout1 xnor clkout2;

        i_clkdiv_odd1 :
        entity work.clkdiv_half
        generic map (
            P => P--,
        )
        port map (
            clkout => clkout1,
            rst_n => rst_n,
            clk => clk--,
        );

        i_clkdiv_odd2 :
        entity work.clkdiv_half
        generic map (
            R => P/2,
            P => P--,
        )
        port map (
            clkout => clkout2,
            rst_n => rst_n,
            clk => not clk--,
        );
    end generate;

end architecture;
