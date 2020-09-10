library ieee;
use ieee.std_logic_1164.all;

entity dec_8b10b_n is
generic (
    N_BYTES_g : positive := 4--;
);
port (
    i_data      : in    std_logic_vector(N_BYTES_g*10-1 downto 0);

    o_data      : out   std_logic_vector(N_BYTES_g*8-1 downto 0);
    o_datak     : out   std_logic_vector(N_BYTES_g-1 downto 0);

    o_err       : out   std_logic;

    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of dec_8b10b_n is

    signal data : std_logic_vector(o_data'range);
    signal datak : std_logic_vector(o_datak'range);
    signal disp : std_logic_vector(N_BYTES_g downto 0);
    signal disperr, err : std_logic_vector(N_BYTES_g-1 downto 0);

begin

    generate_dec_8b10b : for i in 0 to N_BYTES_g-1 generate
    begin
        e_enc_8b10b : entity work.dec_8b10b
        port map (
            i_data => i_data(i*10 + 9 downto 0 + i*10),
            i_disp => disp(i),
            o_data(7 downto 0) => data(i*8 + 7 downto 0 + i*8),
            o_data(8) => datak(i),
            o_disp => disp(i+1),
            o_disperr => disperr(i),
            o_err => err(i)--,
        );
    end generate;

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        o_data <= (others => '0');
        o_datak <= (others => '0');
        disp(0) <= '0';
        o_err <= '0';
        --
    elsif rising_edge(i_clk) then
        o_data <= data;
        o_datak <= datak;
        disp(0) <= disp(N_BYTES_g);
        o_err <= '0';
        if ( disperr /= (disperr'range => '0') or err /= (err'range => '0') ) then
            o_err <= '1';
        end if;
        --
    end if;
    end process;

end architecture;
