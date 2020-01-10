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

    subtype slv32_t is std_logic_vector(31 downto 0);
    type slv32_array_t is array (natural range <>) of slv32_t;
    signal tl_cfg_add : std_logic_vector(3 downto 0);
    signal tl_cfg_add0_q : std_logic_vector(3 downto 0);
    signal tl_cfg_ctl : slv32_t;
    signal tl_cfg : slv32_array_t(0 to 2**tl_cfg_add'length-1);

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

    type st_t is record
        data            :   std_logic_vector(255 downto 0);
        sop             :   std_logic;
        eop             :   std_logic;
        empty           :   std_logic_vector(1 downto 0);
        ready           :   std_logic;
        valid           :   std_logic;
        err             :   std_logic;
    end record;
    signal rx, tx : st_t;
    signal rx_bar : std_logic_vector(7 downto 0);
    signal tx_ready_q : std_logic;

    signal serdes_pll_locked, coreclkout_hip, pld_clk_inuse : std_logic;

    signal rx_data : std_logic_vector(255 downto 0);
    alias rx_header_length : std_logic_vector(9 downto 0) is rx_data(9 downto 0);
    alias rx_header_address : std_logic_vector(31 downto 0) is rx_data(95 downto 64);

begin

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
        clk_pcie_reset_reset_n  => pld_clk_inuse,
        clk_pcie_clock_clk      => coreclkout_hip,
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

    e_pcie : component work.components.pcie
    port map (
        -- RX Port
        rx_st_data          => rx.data,
        rx_st_sop(0)        => rx.sop,
        rx_st_eop(0)        => rx.eop,
        rx_st_empty         => rx.empty,
        rx_st_ready         => rx.ready,
        rx_st_valid(0)      => rx.valid,
        rx_st_err(0)        => rx.err,

        rx_st_mask          => '0',
        rx_st_bar           => rx_bar,

        -- TX Port
        tx_st_data          => tx.data,
        tx_st_sop(0)        => tx.sop,
        tx_st_eop(0)        => tx.eop,
        tx_st_empty         => tx.empty,
        tx_st_ready         => tx.ready,
        tx_st_valid(0)      => tx.valid,
        tx_st_err(0)        => tx.err,

        -- TX credit
--        tx_cred_fc_sel      =>
--        tx_cred_hdr_fc      =>
--        tx_cred_data_fc     =>
--        tx_cred_fc_hip_cons =>
--        tx_cred_fc_infinite =>
        ko_cpl_spc_header   => open,
        ko_cpl_spc_data     => open,

        -- Completion Interface
        cpl_err             => (others => '0'),
        cpl_pending         => '0',

        -- Transaction Layer Configuration
        tl_cfg_add          => tl_cfg_add,
        tl_cfg_ctl          => tl_cfg_ctl,
        tl_cfg_sts          => open,
        hpg_ctrler          => (others => '0'),

        -- Interrupt for Endpoints
        app_msi_req         => '0',
        app_msi_ack         => open,
        app_msi_tc          => (others => '0'),
        app_msi_num         => (others => '0'),
        app_int_sts         => '0',
        app_int_ack         => open,

        -- Power Management
        pme_to_cr           => '0',
        pme_to_sr           => open,
        pm_event            => '0',
        pm_data             => (others => '0'),
        pm_auxpwr           => '0',

        -- Data Link and Transaction Layers clock (output)
        coreclkout_hip      => coreclkout_hip,
        -- Application Layer clock (input)
        pld_clk             => coreclkout_hip,
        -- PLL that generates coreclkout_hip is locked (output)
        serdes_pll_locked   => serdes_pll_locked,
        -- pld_clk is stable (input)
        pld_core_ready      => serdes_pll_locked,
        -- Hard IP Transaction Layer is ready (output)
        pld_clk_inuse       => pld_clk_inuse,

        test_in => X"00000188", -- see 'UG-01145_avmm / 5.8.4. Test Signals'
        simu_mode_pipe => '0',
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

    process(coreclkout_hip, pld_clk_inuse)
    begin
    if ( pld_clk_inuse = '0' ) then
        tl_cfg_add0_q <= (others => '0');
        tl_cfg <= (others => (others => '0'));
        rx_data <= (others => '0');
        tx.data <= (others => '0');
        rx.ready <= '0';
        av_test.waitrequest <= '1';
        --
    elsif rising_edge(coreclkout_hip) then
        tl_cfg_add0_q <= tl_cfg_add(0) & tl_cfg_add0_q(tl_cfg_add0_q'left downto 1);
        if ( tl_cfg_add0_q(1) /= tl_cfg_add0_q(0) ) then
            tl_cfg(to_integer(unsigned(tl_cfg_add))) <= tl_cfg_ctl;
        end if;

        rx.ready <= '1';
        if ( rx.sop = '1' ) then
            rx_data <= rx.data;
        end if;



        av_test.waitrequest <= '0';
        av_test.readdata <= X"CCCCCCCC";

        -- read rx TLP
        if ( av_test.read = '1' and av_test.address(7 downto 3) = X"1" & "0" ) then
            av_test.readdata <= rx_data(
                32*to_integer(unsigned(av_test.address(2 downto 0)))
                + 31 downto 0 +
                32*to_integer(unsigned(av_test.address(2 downto 0)))
            );
        end if;

        -- read Configuration Space Register
        if ( av_test.read = '1' and av_test.address(7 downto 4) = X"0" ) then
            av_test.readdata <= tl_cfg(to_integer(unsigned(av_test.address(3 downto 0))));
        end if;



--        tx.data <= (others => '0');
        tx.sop <= '0';
        tx.eop <= '0';
        tx.empty <= "00";
        tx_ready_q <= tx.ready;
        tx.valid <= '0';

        -- handle MRd
        if ( rx_data(31 downto 24) = X"00" and rx_header_length /= (rx_header_length'range => '0') ) then
            tx.data(31 downto 0) <=
                "010" & -- fmt
                "01010" & -- type
                X"000" & -- tc, td, ep, attr
                X"001"; -- length
            tx.data(63 downto 32) <=
                tl_cfg(15)(12 downto 0) & "000" & -- completer id & function
                "000" & "0" & -- status & bcm
                rx_header_length & "00"; -- byte count
            tx.data(95 downto 64) <=
                rx_data(63 downto 48) & -- requester id
                rx_data(47 downto 40) & -- tag
                '0' &
                rx_header_address(6 downto 0); -- lower address

            -- handle unaligned data
            if ( rx_data(66) = '1' ) then
                tx.data(127 downto 96) <= X"CAFEBABE"; -- data
                tx.empty <= "10"; -- 128-bit
            else
                tx.data(159 downto 128) <= X"CAFEBABE"; -- data
                tx.empty <= "01"; -- 192-bit
            end if;

            tx.sop <= '1';
            tx.eop <= '1';
            tx.valid <= tx_ready_q;

            if ( tx_ready_q = '1' ) then
                rx_header_length <= std_logic_vector(unsigned(rx_header_length) - 1);
                rx_header_address <= std_logic_vector(unsigned(rx_header_address) + 4);
            end if;
        end if;

        -- read tx TLP
        if ( av_test.read = '1' and av_test.address(7 downto 3) = X"1" & "1" ) then
            av_test.readdata <= tx.data(
                32*to_integer(unsigned(av_test.address(2 downto 0)))
                + 31 downto 0 +
                32*to_integer(unsigned(av_test.address(2 downto 0)))
            );
        end if;

        --
    end if;
    end process;

end architecture;
