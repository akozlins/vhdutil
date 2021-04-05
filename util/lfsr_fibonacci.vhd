library ieee;
use ieee.std_logic_1164.all;

-- https://en.wikipedia.org/wiki/Linear-feedback_shift_register
entity lfsr_fibonacci is
generic (
    -- taps (e.g. poly 'x^8 + x^6 + x^5 + x^4 + 1' corresponds to "10111000")
    g_TAPS : std_logic_vector;
    g_INIT : std_logic_vector := "1"--;
);
port (
    o_lfsr      : out   std_logic_vector(g_TAPS'length-1 downto 0);

    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of lfsr_fibonacci is

    signal lfsr : std_logic_vector(o_lfsr'range);
    signal feedback : std_logic;

begin

    o_lfsr <= lfsr;

    feedback <= work.util.xor_reduce((lfsr & '0') and g_TAPS);

    e_lfsr : entity work.shift_register
    generic map (
        g_W => lfsr'length,
        g_INIT => g_INIT--,
    )
    port map (
        o_q         => lfsr,
        i_d         => feedback,

        i_reset_n   => i_reset_n,
        i_clk       => i_clk--,
    );

end architecture;
