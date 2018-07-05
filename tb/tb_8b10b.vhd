library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_8b10b is
end entity;

architecture arch of tb_8b10b is

    constant CLK_MHZ : positive := 100;
    signal clk, rst_n : std_logic;

    signal e8b : std_logic_vector(8 downto 0);
    signal e10b : std_logic_vector(9 downto 0);
    signal edin, edout, eerr : std_logic;
    signal d8b : std_logic_vector(8 downto 0);
    signal d10b : std_logic_vector(9 downto 0);
    signal ddin, ddout, dderr, derr : std_logic;

begin

    process
    begin
        clk <= '0';
        for i in 1 to CLK_MHZ*2000 loop
            wait for (500 ns / CLK_MHZ);
            clk <= not clk;
        end loop;
        wait;
    end process;

    process
    begin
        rst_n <= '0';
        for i in 1 to 10 loop
            wait until rising_edge(clk);
        end loop;
        rst_n <= '1';
        wait;
    end process;

    i_enc : entity work.enc_8b10b
    port map (
        datain => e8b,
        dispin => edin,
        dataout => e10b,
        dispout => edout,
        err => eerr--,
    );

    i_dec : entity work.dec_8b10b
    port map (
        datain => d10b,
        dispin => ddin,
        dataout => d8b,
        dispout => ddout,
        disperr => dderr,
        err => derr--,
    );

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        edin <= '0';
        ddin <= '0';
    elsif rising_edge(clk) then
        edin <= edout;
        ddin <= ddout;
    end if;
    end process;

    d10b <= e10b;

    process
    begin
        wait until rising_edge(rst_n);

        for i in 0 to 511 loop
            e8b <= std_logic_vector(to_unsigned(i, e8b'length));
            wait until rising_edge(clk);
            if ( e8b(7 downto 0) /= d8b(7 downto 0) or ( eerr /= e8b(8) ) ) then
                report "--" & integer'image(i) & "--";
                report "enc: " & work.util.to_string(e8b) & " => " & work.util.to_string(e10b) & " " & work.util.to_string(eerr);
                report "dec: " & work.util.to_string(d8b) & " <= " & work.util.to_string(d10b) & " " & work.util.to_string(derr);
            end if;
            assert edout = ddout report "edout /= ddout" severity failure;
        end loop;

        wait;
    end process;

end architecture;
