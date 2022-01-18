--

library ieee;
use ieee.std_logic_1164.all;

entity ip_ram_2rw is
generic (
    g_ADDR0_WIDTH : positive := 8;
    g_DATA0_WIDTH : positive := 8;
    g_ADDR1_WIDTH : positive := 8;
    g_DATA1_WIDTH : positive := 8;
    g_DEVICE_FAMILY : string := "Arria 10"--;
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

architecture arch of ip_ram_2rw is

begin

    -- <https://www.intel.co.jp/content/dam/altera-www/global/ja_JP/pdfs/literature/ug/ug_ram_rom.pdf>
    -- <https://www.intel.com/content/www/us/en/programmable/quartushelp/17.0/hdl/mega/mega_file_altsynch_ram.htm>
    altsyncram_component : altsyncram
    generic map (
        lpm_type => "altsyncram",
        operation_mode => "BIDIR_DUAL_PORT",
        numwords_a => 2**g_ADDR0_WIDTH,
        numwords_b => 2**g_ADDR1_WIDTH,
        widthad_a => g_ADDR0_WIDTH,
        widthad_b => g_ADDR1_WIDTH,
        width_a => g_DATA0_WIDTH,
        width_b => g_DATA1_WIDTH,
        -- Optional parameters to specify the clock used for the output ports.
        -- The values are CLOCK0, CLOCK1 and UNREGISTERED.
        outdata_reg_a => "UNREGISTERED",
        outdata_reg_b => "UNREGISTERED",
        read_during_write_mode_port_a => "DONT_CARE",
        read_during_write_mode_port_b => "DONT_CARE",
        clock_enable_input_a => "BYPASS",
        clock_enable_input_b => "BYPASS",
        clock_enable_output_a => "BYPASS",
        clock_enable_output_b => "BYPASS",
        -- Default value of 1 is only allowed when byte-enable is not used.
        width_byteena_a => 1,
        width_byteena_b => 1,
        -- Optional parameter to specify whether to initialize memory content data to X on power-up simulation.
        power_up_uninitialized => "FALSE",
        -- Optional parameter to specify the target device family.
        -- This parameter is used for modeling and behavioral simulation purposes.
        intended_device_family => g_DEVICE_FAMILY--,
    )
    port map (
        address_a => i_addr0,
        q_a => o_rdata0,
        data_a => i_wdata0,
        wren_a => i_we0,
        clock0 => i_clk0,

        address_b => i_addr1,
        q_b => o_rdata1,
        data_b => i_wdata1,
        wren_b => i_we1,
        clock1 => i_clk1--,
    );

end architecture;
