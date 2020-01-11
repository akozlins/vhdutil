library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
port (
    o_led_n         : out   std_logic_vector(3 downto 0);

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

    signal led : std_logic_vector(o_led_n'range) := (others => '0');

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
    signal flash_reset_n_i : std_logic;
    signal flash_ce_n_i : std_logic;

    signal pcie_reset_n : std_logic;
    signal pcie_clk : std_logic;

    type avalon_t is record
        address         :   std_logic_vector(31 downto 0);
        read            :   std_logic;
        readdata        :   std_logic_vector(31 downto 0);
        write           :   std_logic;
        writedata       :   std_logic_vector(31 downto 0);
        waitrequest     :   std_logic;
        readdatavalid   :   std_logic;
    end record;
    signal av_test : avalon_t;

begin

    e_pcie_block : entity work.pcie_block
    port map (
        i_avs_address       => av_test.address(7 downto 0),
        i_avs_read          => av_test.read,
        o_avs_readdata      => av_test.readdata,
        i_avs_write         => av_test.write,
        i_avs_writedata     => av_test.writedata,
        o_avs_waitrequest   => av_test.waitrequest,

        i_pcie_rx           => PCIE_RX_p,
        o_pcie_tx           => PCIE_TX_p,
        i_pcie_perst_n      => PCIE_PERST_n,
        i_pcie_refclk       => PCIE_REFCLK_p,

        o_reset_n           => pcie_reset_n,
        o_clk               => pcie_clk--,
    );



    o_led_n <= not led;

    nios_clk <= CLK_50_B2J;

    -- 50 MHz
    e_nios_clk_hz : entity work.clkdiv
    generic map ( P => 50000000 )
    port map ( o_clk => led(0), i_reset_n => CPU_RESET_n, i_clk => nios_clk );

    led(1) <= flash_reset_n_i;
    led(2) <= nios_reset_n;

    -- 100 MHz
    e_pcie_clk_hz : entity work.clkdiv
    generic map ( P => 100000000 )
    port map ( o_clk => led(3), i_reset_n => CPU_RESET_n, i_clk => PCIE_REFCLK_p );



    -- generate reset sequence for flash and nios
    e_debouncer : entity work.debouncer
    generic map (
        W => 2,
        N => integer(50e6 * 0.200) -- 200ms
    )
    port map (
        i_d(0) => '1',
        o_q(0) => flash_reset_n_i,

        i_d(1) => flash_reset_n_i,
        o_q(1) => nios_reset_n,

        i_reset_n => CPU_RESET_n,
        i_clk => nios_clk--,
    );

    e_nios : component work.components.nios
    port map (
        clk_pcie_reset_reset_n  => pcie_reset_n,
        clk_pcie_clock_clk      => pcie_clk,
        avm_test_address        => av_test.address(7 downto 0),
        avm_test_read           => av_test.read,
        avm_test_readdata       => av_test.readdata,
        avm_test_write          => av_test.write,
        avm_test_writedata      => av_test.writedata,
        avm_test_waitrequest    => av_test.waitrequest,

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

    -- flash
    FLASH_CE_n <= (flash_ce_n_i, flash_ce_n_i);
    FLASH_ADV_n <= '0';
    FLASH_CLK <= '0';
    FLASH_RESET_n <= flash_reset_n_i;

    -- I2C clock
    i2c_scl_in <= not i2c_scl_oe;
    FAN_I2C_SCL <= ZERO when i2c_scl_oe = '1' else 'Z';

    -- I2C data
    i2c_sda_in <=
        FAN_I2C_SDA and
        '1';
    FAN_I2C_SDA <= ZERO when i2c_sda_oe = '1' else 'Z';

end architecture;
