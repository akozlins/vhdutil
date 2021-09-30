library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
port (
    user_led_g                  : out   std_logic_vector(7 downto 0);

    qsfp_tx_p                   : out   std_logic_vector(3 downto 0);
    qsfp_rx_p                   : in    std_logic_vector(3 downto 0);

    -- QSFP reference clock 282.5 MHz
    refclk4_ql2_p               : in    std_logic;

    clkin_50                    : in    std_logic--;
);
end entity;

architecture arch of top is

    signal clk_50 : std_logic;

    signal cnt_50 : unsigned(31 downto 0);

    signal tx_clk, rx_clk : std_logic_vector(3 downto 0);

begin

    clk_50 <= clkin_50;

    process(clk_50)
    begin
    if rising_edge(clk_50) then
        cnt_50 <= cnt_50 + 1;
    end if;
    end process;

    user_led_g <= not std_logic_vector(cnt_50(31 downto 24));

    e_xcvr : entity work.xcvr
    port map (
        o_tx_serial                     => qsfp_tx_p,
        i_rx_serial                     => qsfp_rx_p,

        o_tx_clk                        => tx_clk,
        o_rx_clk                        => rx_clk,

        i_tx_data                       =>
            X"000000BC" & X"000000BC" & X"000000BC" & X"000000BC",
        i_tx_datak                      =>
            "0001" & "0001" & "0001" & "0001",
        i_tx_clk                        => tx_clk,

        o_rx_data                       => open,
        o_rx_datak                      => open,
        i_rx_clk                        => rx_clk,

        i_refclk                        => refclk4_ql2_p,

        i_reset_n                       => '1',
        i_clk                           => clk_50--,
    );

end architecture;
