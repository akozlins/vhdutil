library ieee;
use ieee.std_logic_1164.all;

-- https://en.wikipedia.org/wiki/Scrambler
entity multiplicative_descrambler is
generic (
    -- taps (e.g. poly 'x^8 + x^6 + x^5 + x^4 + 1' corresponds to "101110001")
    g_TAPS : std_logic_vector;
    g_INIT : std_logic_vector := "1"--;
);
port (
    o_q         : out   std_logic;
    i_d         : in    std_logic;

    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of multiplicative_descrambler is

    signal lfsr : std_logic_vector(g_TAPS'length-2 downto 0);
    signal feedback : std_logic;

begin

    o_q <= feedback;

    feedback <= work.util.xor_reduce((lfsr & i_d) and g_TAPS);

    e_lfsr : entity work.shift_register
    generic map (
        g_W => lfsr'length,
        g_INIT => g_INIT--,
    )
    port map (
        o_q         => lfsr,
        i_d         => i_d,

        i_reset_n   => i_reset_n,
        i_clk       => i_clk--,
    );

end architecture;
