library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pcie_block is
port (
    i_avs_address       : in    std_logic_vector(5 downto 0);
    i_avs_read          : in    std_logic;
    o_avs_readdata      : out   std_logic_vector(31 downto 0);
    i_avs_write         : in    std_logic;
    i_avs_writedata     : in    std_logic_vector(31 downto 0);
    o_avs_waitrequest   : out   std_logic;

    i_pcie_rx           : in    std_logic_vector(7 downto 0);
    o_pcie_tx           : out   std_logic_vector(7 downto 0);
    i_pcie_perst_n      : in    std_logic;
    i_pcie_refclk       : in    std_logic;

    o_reset_n           : out   std_logic;
    o_clk               : out   std_logic--;
);
end entity;

architecture arch of pcie_block is

    signal rx : work.pcie.st_t;
    signal rx_bar : std_logic_vector(7 downto 0);
    signal tx : work.pcie.st_t;
    signal tx_ready_q : std_logic;

    signal rx_data : std_logic_vector(255 downto 0);
    alias rx_header_length : std_logic_vector(9 downto 0) is rx_data(9 downto 0);
    alias rx_header_address : std_logic_vector(31 downto 0) is rx_data(95 downto 64);



    signal app_msi_req, app_msi_ack : std_logic;

    signal cfg : work.pcie.cfg_t;

    signal tl_cfg_add : std_logic_vector(3 downto 0);
    signal tl_cfg_ctl : std_logic_vector(31 downto 0);

    signal lane_act : std_logic_vector(3 downto 0);
    signal currentspeed : std_logic_vector(1 downto 0);
    signal ltssmstate : std_logic_vector(4 downto 0);

    signal serdes_pll_locked, coreclkout_hip, pld_clk_inuse : std_logic;

    signal clk, reset_n : std_logic;

begin

    process(clk, reset_n)
    begin
    if ( reset_n = '0' ) then
        rx_data <= (others => '0');
        tx.data <= (others => '0');
        rx.ready <= '0';
        app_msi_req <= '0';
        --
    elsif rising_edge(clk) then
        rx.ready <= '1';
        if ( rx.sop = '1' ) then
            rx_data <= rx.data;
        end if;

        app_msi_req <= '0';
        -- generate MSI for MWr TLP
        if ( rx.sop = '1' and rx.data(31 downto 24) = "010" & "00000" ) then
            app_msi_req <= '1';
        end if;

--        tx.data <= (others => '0');
        tx.sop <= '0';
        tx.eop <= '0';
        tx.empty <= "00";
        tx_ready_q <= tx.ready;
        tx.valid <= '0';

        -- handle MRd TLP
        if ( rx_data(31 downto 24) = X"00" and rx_header_length /= (rx_header_length'range => '0') ) then
            tx.data <= (others => '0');

            tx.data(31 downto 0) <=
                "010" & -- fmt
                "01010" & -- type
                X"000" & -- tc, td, ep, attr
                X"001"; -- length
            tx.data(63 downto 32) <=
                cfg.busdev & "000" & -- completer id & function
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

        --
    end if;
    end process;



    block_avs : block
    begin
        process(clk, reset_n)
        begin
        if ( reset_n = '0' ) then
            o_avs_waitrequest <= '1';
            --
        elsif rising_edge(clk) then
            o_avs_waitrequest <= '0';
            o_avs_readdata <= X"CCCCCCCC";

            if ( i_avs_read = '1' and i_avs_address(5 downto 4) = "00" ) then
                o_avs_readdata <= (others => '0');
                case i_avs_address(3 downto 0) is
                when X"0" => o_avs_readdata(lane_act'range) <= lane_act;
                when X"1" => o_avs_readdata(currentspeed'range) <= currentspeed;
                when X"2" => o_avs_readdata(ltssmstate'range) <= ltssmstate;
                when others =>
                    o_avs_readdata <= X"CCCCCCCC";
                end case;
            end if;

            -- pcie config regs
            if ( i_avs_read = '1' and i_avs_address(5 downto 4) = "01" ) then
                o_avs_readdata <= (others => '0');
                case i_avs_address(3 downto 0) is
                when X"0" => o_avs_readdata(cfg.busdev'range) <= cfg.busdev;
                when X"1" => o_avs_readdata <= cfg.dev_ctrl2 & cfg.dev_ctrl;
                when X"2" => o_avs_readdata <= cfg.link_ctrl2 & cfg.link_ctrl;
                when X"3" => o_avs_readdata(cfg.prm_cmd'range) <= cfg.prm_cmd;
                when X"4" => o_avs_readdata <= cfg.msixcsr & cfg.msicsr;
                when X"5" => o_avs_readdata(cfg.msi_data'range) <= cfg.msi_data;
                when X"6" => o_avs_readdata <= cfg.msi_addr(31 downto 0);
                when X"7" => o_avs_readdata <= cfg.msi_addr(63 downto 32);
                when X"8" => o_avs_readdata(cfg.tcvcmap'range) <= cfg.tcvcmap;
                when others =>
                    o_avs_readdata <= X"CCCCCCCC";
                end case;
            end if;

            -- RX TLP
            if ( i_avs_read = '1' and i_avs_address(5 downto 3) = "100" ) then
                o_avs_readdata <= rx_data(
                    32*to_integer(unsigned(i_avs_address(2 downto 0)))
                    + 31 downto 0 +
                    32*to_integer(unsigned(i_avs_address(2 downto 0)))
                );
            end if;

            -- TX TLP
            if ( i_avs_read = '1' and i_avs_address(5 downto 3) = "110" ) then
                o_avs_readdata <= tx.data(
                    32*to_integer(unsigned(i_avs_address(2 downto 0)))
                    + 31 downto 0 +
                    32*to_integer(unsigned(i_avs_address(2 downto 0)))
                );
            end if;

        --
        end if;
        end process;
    end block;



    -- see "5.12. Transaction Layer Configuration Space Signals"
    block_cfg : block
        signal tl_cfg : work.pcie.tl_cfg_t;
        signal tl_cfg_add0_q : std_logic_vector(3 downto 0);
    begin
        cfg <= work.pcie.to_cfg(tl_cfg);

        process(clk, reset_n)
        begin
        if ( reset_n = '0' ) then
            tl_cfg_add0_q <= (others => '0');
            tl_cfg <= (others => (others => '0'));
            --
        elsif rising_edge(clk) then
            tl_cfg_add0_q <= tl_cfg_add(0) & tl_cfg_add0_q(tl_cfg_add0_q'left downto 1);
            if ( tl_cfg_add0_q(1) /= tl_cfg_add0_q(0) ) then
                tl_cfg(to_integer(unsigned(tl_cfg_add))) <= tl_cfg_ctl;
            end if;
            --
        end if;
        end process;
    end block;



    e_ip_pcie : component work.components.ip_pcie
    port map (
        -- RX Port
        rx_st_data          => rx.data,
        rx_st_sop(0)        => rx.sop,
        rx_st_eop(0)        => rx.eop,
        rx_st_empty         => rx.empty,
        rx_st_valid(0)      => rx.valid,
        rx_st_err(0)        => rx.err,
        rx_st_ready         => rx.ready,

        rx_st_mask          => '0',
        rx_st_bar           => rx_bar,

        -- TX Port
        tx_st_data          => tx.data,
        tx_st_sop(0)        => tx.sop,
        tx_st_eop(0)        => tx.eop,
        tx_st_empty         => tx.empty,
        tx_st_valid(0)      => tx.valid,
        tx_st_err(0)        => tx.err,
        tx_st_ready         => tx.ready,

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

        -- Interrupt for Endpoints
        app_msi_req         => app_msi_req,
        app_msi_ack         => app_msi_ack,
        app_msi_tc          => (others => '0'),
        app_msi_num         => (others => '0'),
        app_int_sts         => '0',
        app_int_ack         => open,

        -- Transaction Layer Configuration
        tl_cfg_add          => tl_cfg_add,
        tl_cfg_ctl          => tl_cfg_ctl,
        tl_cfg_sts          => open,
        hpg_ctrler          => (others => '0'),

        -- Power Management
        pme_to_cr           => '0',
        pme_to_sr           => open,
        pm_event            => '0',
        pm_data             => (others => '0'),
        pm_auxpwr           => '0',

        lane_act            => lane_act,
        currentspeed        => currentspeed,
        ltssmstate          => ltssmstate,

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
        rx_in0 => i_pcie_rx(0),
        rx_in1 => i_pcie_rx(1),
        rx_in2 => i_pcie_rx(2),
        rx_in3 => i_pcie_rx(3),
        rx_in4 => i_pcie_rx(4),
        rx_in5 => i_pcie_rx(5),
        rx_in6 => i_pcie_rx(6),
        rx_in7 => i_pcie_rx(7),
        tx_out0 => o_pcie_tx(0),
        tx_out1 => o_pcie_tx(1),
        tx_out2 => o_pcie_tx(2),
        tx_out3 => o_pcie_tx(3),
        tx_out4 => o_pcie_tx(4),
        tx_out5 => o_pcie_tx(5),
        tx_out6 => o_pcie_tx(6),
        tx_out7 => o_pcie_tx(7),
        npor => i_pcie_perst_n,
        pin_perst => i_pcie_perst_n,
        refclk => i_pcie_refclk--,
    );



    clk <= coreclkout_hip;
    reset_n <= pld_clk_inuse;

    o_clk <= clk;
    o_reset_n <= reset_n;

end architecture;
