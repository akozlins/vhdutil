library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
port (
    LED             : out   std_logic_vector(3 downto 0);

    FLASH_A         : out   std_logic_vector(26 downto 1);
    FLASH_D         : inout std_logic_vector(31 downto 0);
    FLASH_OE_n      : inout std_logic;
    FLASH_WE_n      : out   std_logic;
    FLASH_CE_n      : out   std_logic_vector(1 downto 0);
    FLASH_ADV_n     : out   std_logic;
    FLASH_CLK       : out   std_logic;
    FLASH_RESET_n   : out   std_logic;

    FAN_I2C_SCL     : out   std_logic;
    FAN_I2C_SDA     : inout std_logic;

    PCIE_RX_p       : in    std_logic_vector(7 downto 0);
    PCIE_TX_p       : out   std_logic_vector(7 downto 0);
    PCIE_PERST_n    : in    std_logic;
    PCIE_REFCLK_p   : in    std_logic;

    CPU_RESET_n     : in    std_logic;
    CLK_50_B2J      : in    std_logic--;
);
end entity;

architecture arch of top is

    -- https://www.altera.com/support/support-resources/knowledge-base/solutions/rd01262015_264.html
    signal ZERO : std_logic := '0';
    attribute keep : boolean;
    attribute keep of ZERO : signal is true;

    signal i2c_scl_in : std_logic;
    signal i2c_scl_oe : std_logic;
    signal i2c_sda_in : std_logic;
    signal i2c_sda_oe : std_logic;

    signal nios_clk : std_logic;
    signal nios_reset_n : std_logic;
    signal flash_rst_n : std_logic;

    signal flash_ce_n_i : std_logic;

begin

    nios_clk <= CLK_50_B2J;

    -- 50 MHz
    e_nios_clk_hz : entity work.clkdiv
    generic map ( P => 50000000 )
    port map ( o_clk => LED(0), i_reset_n => CPU_RESET_n, i_clk => nios_clk );

    -- 100 MHz
    e_pcie_clk_hz : entity work.clkdiv
    generic map ( P => 100000000 )
    port map ( o_clk => LED(3), i_reset_n => CPU_RESET_n, i_clk => PCIE_REFCLK_p );

    -- generate reset sequence for flash and nios
    e_debouncer : entity work.debouncer
    generic map (
        W => 2,
        N => 50 * 10**5 -- 100ms
    )
    port map (
        i_d(0) => '1',
        o_q(0) => flash_rst_n,

        i_d(1) => flash_rst_n,
        o_q(1) => nios_reset_n,

        i_reset_n => CPU_RESET_n,
        i_clk => nios_clk--,
    );

    LED(1) <= not flash_rst_n;
    LED(2) <= not nios_reset_n;



    e_nios : component work.components.nios
    port map (
        flash_tcm_address_out(27 downto 2) => FLASH_A,
        flash_tcm_data_out => FLASH_D,
        flash_tcm_read_n_out(0) => FLASH_OE_n,
        flash_tcm_write_n_out(0) => FLASH_WE_n,
        flash_tcm_chipselect_n_out(0) => flash_ce_n_i,

        i2c_scl_in  => i2c_scl_in,
        i2c_scl_oe  => i2c_scl_oe,
        i2c_sda_in  => i2c_sda_in,
        i2c_sda_oe  => i2c_sda_oe,

        rst_reset_n => nios_reset_n,
        clk_clk     => nios_clk--,
    );



    FLASH_CE_n <= (flash_ce_n_i, flash_ce_n_i);
    FLASH_ADV_n <= '0';
    FLASH_CLK <= '0';
    FLASH_RESET_n <= flash_rst_n;



    -- I2C clock
    i2c_scl_in <= not i2c_scl_oe;
    FAN_I2C_SCL <= ZERO when i2c_scl_oe = '1' else 'Z';

    -- I2C data
    i2c_sda_in <= FAN_I2C_SDA and
                  '1';
    FAN_I2C_SDA <= ZERO when i2c_sda_oe = '1' else 'Z';




    e_pcie : component work.components.pcie
    port map (
        rx_in0 => PCIE_RX_p(0),
        rx_in1 => PCIE_RX_p(1),
        rx_in2 => PCIE_RX_p(2),
        rx_in3 => PCIE_RX_p(3),
        rx_in4 => PCIE_RX_p(4),
        rx_in5 => PCIE_RX_p(5),
        rx_in6 => PCIE_RX_p(6),
        rx_in7 => PCIE_RX_p(7),
        tx_out0 => PCIE_TX_p(0),
        tx_out1 => PCIE_TX_p(1),
        tx_out2 => PCIE_TX_p(2),
        tx_out3 => PCIE_TX_p(3),
        tx_out4 => PCIE_TX_p(4),
        tx_out5 => PCIE_TX_p(5),
        tx_out6 => PCIE_TX_p(6),
        tx_out7 => PCIE_TX_p(7),

        npor => PCIE_PERST_n,
        pin_perst => PCIE_PERST_n,
        refclk => PCIE_REFCLK_p--,
    );

end architecture;
