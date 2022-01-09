library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
port (
    o_led_n                     : out   std_logic_vector(3 downto 0);

    FLASH_A                     : out   std_logic_vector(26 downto 1);
    FLASH_D                     : inout std_logic_vector(31 downto 0);
    FLASH_OE_n                  : inout std_logic;
    FLASH_WE_n                  : out   std_logic;
    FLASH_CE_n                  : out   std_logic_vector(1 downto 0);
    FLASH_ADV_n                 : out   std_logic;
    FLASH_CLK                   : out   std_logic;
    FLASH_RESET_n               : out   std_logic;

    FAN_I2C_SCL                 : inout std_logic;
    FAN_I2C_SDA                 : inout std_logic;

    PCIE_RX_p                   : in    std_logic_vector(7 downto 0);
    PCIE_TX_p                   : out   std_logic_vector(7 downto 0);
    PCIE_PERST_n                : in    std_logic;
    PCIE_REFCLK_p               : in    std_logic;

    CPU_RESET_n                 : in    std_logic;
    CLK_50_B2J                  : in    std_logic--;
);
end entity;

architecture arch of top is

    signal clk_50               : std_logic;
    signal reset_50_n           : std_logic;

    signal flash_addr_unused    : std_logic_vector(1 downto 0);
    signal flash_cs_n           : std_logic;
    signal flash_rst_n          : std_logic;
    signal nios_reset_n         : std_logic;

    signal nios_i2c_scl         : std_logic;
    signal nios_i2c_scl_oe      : std_logic;
    signal nios_i2c_sda         : std_logic;
    signal nios_i2c_sda_oe      : std_logic;
    signal nios_i2c_mask        : std_logic_vector(31 downto 0);

    signal nios_pio             : std_logic_vector(31 downto 0);

begin

    clk_50 <= CLK_50_B2J;

    e_reset_50_n : entity work.reset_sync
    port map ( o_reset_n => reset_50_n, i_reset_n => CPU_RESET_n, i_clk => clk_50 );

    -- 50 MHz -> 1 Hz
    e_clk_50_hz : entity work.clkdiv
    generic map ( P => 50000000 )
    port map ( o_clk => o_led_n(0), i_reset_n => reset_50_n, i_clk => clk_50 );

    -- 100 MHz
    e_pcie_clk_hz : entity work.clkdiv
    generic map ( P => 100000000 )
    port map ( o_clk => o_led_n(3), i_reset_n => CPU_RESET_n, i_clk => PCIE_REFCLK_p );



    -- generate reset sequence for flash and nios
    e_nios_reset_n : entity work.debouncer
    generic map (
        W => 2,
        N => integer(50.0e6 * 0.100) -- 100ms
    )
    port map (
        i_d(0) => '1',         i_d(1) => flash_rst_n,
        o_q(0) => flash_rst_n, o_q(1) => nios_reset_n,

        i_reset_n       => reset_50_n,
        i_clk           => clk_50--,
    );
    flash_reset_n <= flash_rst_n;

    o_led_n(1) <= flash_rst_n;
    o_led_n(2) <= nios_reset_n;



    e_nios : component work.components.nios
    port map (
        pcie_hip_ctrl_test_in => X"00000188", -- see 'UG-01145_avmm / 5.8.4. Test Signals'
        pcie_hip_ctrl_simu_mode_pipe => '0',
        pcie_hip_serial_rx_in0 => PCIE_RX_p(0),
        pcie_hip_serial_rx_in1 => PCIE_RX_p(1),
        pcie_hip_serial_rx_in2 => PCIE_RX_p(2),
        pcie_hip_serial_rx_in3 => PCIE_RX_p(3),
        pcie_hip_serial_rx_in4 => PCIE_RX_p(4),
        pcie_hip_serial_rx_in5 => PCIE_RX_p(5),
        pcie_hip_serial_rx_in6 => PCIE_RX_p(6),
        pcie_hip_serial_rx_in7 => PCIE_RX_p(7),
        pcie_hip_serial_tx_out0 => PCIE_TX_p(0),
        pcie_hip_serial_tx_out1 => PCIE_TX_p(1),
        pcie_hip_serial_tx_out2 => PCIE_TX_p(2),
        pcie_hip_serial_tx_out3 => PCIE_TX_p(3),
        pcie_hip_serial_tx_out4 => PCIE_TX_p(4),
        pcie_hip_serial_tx_out5 => PCIE_TX_p(5),
        pcie_hip_serial_tx_out6 => PCIE_TX_p(6),
        pcie_hip_serial_tx_out7 => PCIE_TX_p(7),
        pcie_npor_npor => PCIE_PERST_n,
        pcie_npor_pin_perst => PCIE_PERST_n,
        pcie_refclk_clk => PCIE_REFCLK_p,

        flash_tcm_address_out(27 downto 2) => FLASH_A,
        flash_tcm_address_out(1 downto 0) => flash_addr_unused,
        flash_tcm_data_out => FLASH_D,
        flash_tcm_read_n_out(0) => FLASH_OE_n,
        flash_tcm_write_n_out(0) => FLASH_WE_n,
        flash_tcm_chipselect_n_out(0) => flash_cs_n,

        i2c_scl_in              => nios_i2c_scl,
        i2c_scl_oe              => nios_i2c_scl_oe,
        i2c_sda_in              => nios_i2c_sda,
        i2c_sda_oe              => nios_i2c_sda_oe,
        i2c_mask_export         => nios_i2c_mask,

        pio_export              => nios_pio,

        rst_reset_n             => nios_reset_n,
        clk_clk                 => clk_50--,
    );

    FLASH_CE_n <= (flash_cs_n, flash_cs_n);
    FLASH_ADV_n <= '0';
    FLASH_CLK <= '0';

--    o_led_n(3) <= nios_pio(7);



    e_i2c_mux : entity work.i2c_mux
    port map (
        io_scl(0)       => FAN_I2C_SCL,
        io_sda(0)       => FAN_I2C_SDA,

        o_scl           => nios_i2c_scl,
        i_scl_oe        => nios_i2c_scl_oe,
        o_sda           => nios_i2c_sda,
        i_sda_oe        => nios_i2c_sda_oe,
        i_mask          => nios_i2c_mask--,
    );

end architecture;
