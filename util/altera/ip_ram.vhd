library ieee;
use ieee.std_logic_1164.all;

entity ip_ram is
generic (
    g_ADDR0_WIDTH : positive := 8;
    g_DATA0_WIDTH : positive := 8;
    g_ADDR1_WIDTH : positive := 8;
    g_DATA1_WIDTH : positive := 8;
    -- DEVICE_FAMILY parameter is set by quartus
    DEVICE_FAMILY : string--;
);
port (
    i_addr0     : in    std_logic_vector(g_ADDR0_WIDTH-1 downto 0);
    o_rdata0    : out   std_logic_vector(g_DATA0_WIDTH-1 downto 0);
    i_wdata0    : in    std_logic_vector(g_DATA0_WIDTH-1 downto 0) := (others => '0');
    i_we0       : in    std_logic := '0';
    i_clk0      : in    std_logic;

    i_addr1     : in    std_logic_vector(g_ADDR1_WIDTH-1 downto 0);
    o_rdata1    : out   std_logic_vector(g_DATA1_WIDTH-1 downto 0);
    i_wdata1    : in    std_logic_vector(g_DATA1_WIDTH-1 downto 0) := (others => '0');
    i_we1       : in    std_logic := '0';
    i_clk1      : in    std_logic--;
);
end entity;

library altera_mf;
use altera_mf.altera_mf_components.all;

architecture arch of ip_ram is

begin

    altsyncram_component : altsyncram
    generic map (
        address_reg_b => "CLOCK1",
        clock_enable_input_a => "BYPASS",
        clock_enable_input_b => "BYPASS",
        clock_enable_output_a => "BYPASS",
        clock_enable_output_b => "BYPASS",
        indata_reg_b => "CLOCK1",
        intended_device_family => DEVICE_FAMILY,
        lpm_type => "altsyncram",
        numwords_a => 2**g_ADDR0_WIDTH,
        numwords_b => 2**g_ADDR1_WIDTH,
        operation_mode => "BIDIR_DUAL_PORT",
        outdata_aclr_a => "NONE",
        outdata_aclr_b => "NONE",
        outdata_reg_a => "UNREGISTERED",
        outdata_reg_b => "UNREGISTERED",
        power_up_uninitialized => "FALSE",
        read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
        read_during_write_mode_port_b => "NEW_DATA_NO_NBE_READ",
        widthad_a => g_ADDR0_WIDTH,
        widthad_b => g_ADDR1_WIDTH,
        width_a => g_DATA0_WIDTH,
        width_b => g_DATA1_WIDTH,
        width_byteena_a => 1,
        width_byteena_b => 1,
        wrcontrol_wraddress_reg_b => "CLOCK1"
    )
    port map (
        address_a => i_addr0,
        address_b => i_addr1,
        clock0 => i_clk0,
        clock1 => i_clk1,
        data_a => i_wdata0,
        data_b => i_wdata1,
        wren_a => i_we0,
        wren_b => i_we1,
        q_a => o_rdata0,
        q_b => o_rdata1--,
    );

end architecture;
