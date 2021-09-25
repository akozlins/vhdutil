library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xcvr is
port (
    o_tx_serial                 : out   std_logic_vector(3 downto 0);
    i_rx_serial                 : in    std_logic_vector(3 downto 0);

    i_tx_data                   : in    std_logic_vector(127 downto 0) := (others => '0');
    i_tx_datak                  : in    std_logic_vector(15 downto 0) := (others => '0');
    o_rx_data                   : out   std_logic_vector(127 downto 0);
    o_rx_datak                  : out   std_logic_vector(15 downto 0);
    i_tx_clk                    : in    std_logic_vector(3 downto 0);
    o_tx_clk                    : out   std_logic_vector(3 downto 0);
    i_rx_clk                    : in    std_logic_vector(3 downto 0);
    o_rx_clk                    : out   std_logic_vector(3 downto 0);

    i_refclk                    : in    std_logic;

    i_reset_n                   : in    std_logic;
    i_clk                       : in    std_logic--;
);
end entity;

architecture arch of xcvr is

    signal pll_powerdown, pll_locked, tx_cal_busy, rx_cal_busy, rx_is_lockedtodata,
           tx_analogreset, tx_digitalreset, rx_analogreset, rx_digitalreset : std_logic_vector(3 downto 0);

    signal reconfig_to_xcvr :  std_logic_vector(559 downto 0);
    signal reconfig_from_xcvr : std_logic_vector(367 downto 0);

    signal rx_err, rx_disperr, rx_pattern, rx_sync : std_logic_vector(15 downto 0);

begin

    e_phy : work.components.ip_xcvr_phy
    port map (
        tx_serial_data                  => o_tx_serial,
        rx_serial_data                  => i_rx_serial,

        rx_seriallpbken                 => (others => '0'),

        tx_parallel_data                => i_tx_data,
        tx_datak                        => i_tx_datak,
        rx_parallel_data                => o_rx_data,
        rx_datak                        => o_rx_datak,
        tx_std_coreclkin                => i_tx_clk,
        tx_std_clkout                   => o_tx_clk,
        rx_std_coreclkin                => i_rx_clk,
        rx_std_clkout                   => o_rx_clk,

        rx_patterndetect                => rx_pattern,
        rx_syncstatus                   => rx_sync,

        reconfig_to_xcvr                => reconfig_to_xcvr,
        reconfig_from_xcvr              => reconfig_from_xcvr,

        pll_powerdown                   => pll_powerdown,
        pll_locked                      => pll_locked,
        tx_analogreset                  => tx_analogreset,
        tx_digitalreset                 => tx_digitalreset,
        rx_analogreset                  => rx_analogreset,
        rx_digitalreset                 => rx_digitalreset,
        tx_cal_busy                     => tx_cal_busy,
        rx_cal_busy                     => rx_cal_busy,
        rx_is_lockedtodata              => rx_is_lockedtodata,

        tx_pll_refclk                   => (others => i_refclk),
        rx_cdr_refclk                   => (others => i_refclk)--,
    );

    e_reconfig : work.components.ip_xcvr_reconfig
    port map (
        reconfig_to_xcvr                => reconfig_to_xcvr,
        reconfig_from_xcvr              => reconfig_from_xcvr,

        reconfig_busy                   => open,

        reconfig_mgmt_address           => (others => '0'),
        reconfig_mgmt_read              => '0',
        reconfig_mgmt_readdata          => open,
        reconfig_mgmt_waitrequest       => open,
        reconfig_mgmt_write             => '0',
        reconfig_mgmt_writedata         => (others => '0'),

        mgmt_rst_reset                  => not i_reset_n,
        mgmt_clk_clk                    => i_clk--,
    );

    e_reset : work.components.ip_xcvr_reset
    port map (
        pll_powerdown                   => pll_powerdown,
        pll_locked                      => pll_locked,
        tx_analogreset                  => tx_analogreset,
        tx_digitalreset                 => tx_digitalreset,
        rx_analogreset                  => rx_analogreset,
        rx_digitalreset                 => rx_digitalreset,
        tx_cal_busy                     => tx_cal_busy,
        rx_cal_busy                     => rx_cal_busy,
        rx_is_lockedtodata              => rx_is_lockedtodata,

        tx_ready                        => open,
        rx_ready                        => open,
        pll_select                      => "11100100",

        reset                           => not i_reset_n,
        clock                           => i_clk--,
    );

end architecture;
