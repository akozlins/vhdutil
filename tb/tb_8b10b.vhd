library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_8b10b is
end entity;

architecture arch of tb_8b10b is

    constant CLK_MHZ : positive := 100;
    signal clk, rst_n : std_logic;

    signal data8b : std_logic_vector(8 downto 0);
    signal data10b : std_logic_vector(9 downto 0);
    signal dispin, dispout, err : std_logic;

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
        report "rst_n <= '1'";
        wait;
    end process;

    i_enc : entity work.enc_8b10b
    port map (
        datain => data8b,
        dispin => dispin,
        dataout => data10b,
        dispout => dispout,
        err => err--,
    );

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        dispin <= '0';
    elsif rising_edge(clk) then
        dispin <= dispout;
    end if;
    end process;

    process
    begin
        wait until rising_edge(rst_n);

        for i in 0 to 511 loop
            data8b <= std_logic_vector(to_unsigned(i, data8b'length));
            wait until rising_edge(clk);
            report "data8b = " & work.util.to_string(data8b) & " / err = " & work.util.to_string(err);
            report "data10b => " & work.util.to_string(data10b);
        end loop;

        wait;
    end process;

end architecture;
