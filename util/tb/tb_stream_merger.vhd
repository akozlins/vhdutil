library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_stream_merger is
end entity;

architecture arch of tb_stream_merger is

    constant CLK_MHZ : real := 1000.0; -- MHz
    signal clk, reset_n, reset : std_logic := '0';

    signal DONE : std_logic_vector(0 downto 0) := (others => '0');

    constant N : positive := 4;
    constant W : positive := 16;

    -- empty cycle
    constant XXXX : std_logic_vector(W-1 downto 0) := (others => 'X');

    type links_array_t is array ( natural range <> ) of std_logic_vector(W-1 downto 0);
    signal links : links_array_t(0 to 32*N-1) := (
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX , X"00BC",   XXXX ,   XXXX ,
        X"00BC", X"BABE",   XXXX ,   XXXX ,
        X"CAFE", X"BABE",   XXXX ,   XXXX ,
        X"009C", X"009C", X"00BC",   XXXX ,
          XXXX ,   XXXX , X"DEAD",   XXXX ,
          XXXX ,   XXXX , X"DEAD",   XXXX ,
          XXXX ,   XXXX ,   XXXX , X"00BC",
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX , X"DEAD", X"BEEF",
          XXXX ,   XXXX , X"009C", X"BEEF",
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX , X"009C",
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX ,
          XXXX ,   XXXX ,   XXXX ,   XXXX 
    );

    type offsets_array_t is array ( natural range <> ) of integer;
    signal offsets : offsets_array_t(N-1 downto 0) := ( others => 0 );

    signal rdata : std_logic_vector(N*W-1 downto 0);
    signal rsop, reop, rempty, rack : std_logic_vector(N-1 downto 0);
    signal wdata : std_logic_vector(W-1 downto 0);
    signal we : std_logic;

begin

    clk <= not clk after (0.5 us / CLK_MHZ);
    reset_n <= '0', '1' after (1.0 us / CLK_MHZ);
    reset <= not reset_n;

    g_data : for i in N-1 downto 0 generate
    begin
        rdata(W-1 + i*W downto 0 + i*W) <= links(offsets(i)*N+i);
        rsop(i) <= '1' when ( links(offsets(i)*N+i) = X"00BC" ) else '0';
        reop(i) <= '1' when ( links(offsets(i)*N+i) = X"009C" ) else '0';
        rempty(i) <= '1' when ( is_x(links(offsets(i)*N+i)) ) else '0';
    end generate;

    e_stream_merger : entity work.stream_merger
    generic map (
        W => W,
        N => N--,
    )
    port map (
        i_rdata         => rdata,
        i_rsop          => rsop,
        i_reop          => reop,
        i_rempty        => rempty,
        o_rack          => rack,

        o_wdata         => wdata,
        i_wfull         => '0',
        o_we            => we,

        i_reset_n       => reset_n,
        i_clk           => clk--,
    );

    process
    begin
        wait until rising_edge(reset_n);

        loop
            wait until rising_edge(clk);
            report "rdata = " & work.util.to_hstring(rdata);
            for i in N-1 downto 0 loop
                if ( (rack(i) = '1' or rempty(i) = '1') and offsets(i) < links'length/N-1 ) then
                    offsets(i) <= offsets(i) + 1;
                end if;
            end loop;
            exit when ( offsets = (N-1 downto 0 => links'length/N-1) );
        end loop;

        DONE(0) <= '1';
        wait;
    end process;

    process
    begin
        wait until rising_edge(reset_n);

        loop
            wait until rising_edge(clk) and we = '1';
            report "wdata = " & work.util.to_hstring(wdata);
        end loop;

        wait;
    end process;

    process
    begin
        wait for 4000 ns;
        assert ( DONE = (DONE'range => '1') ) severity failure;
        wait;
    end process;

end architecture;
