--
-- dual-clock fifo
--
-- author : Alexandr Kozlinskiy
-- date : 2021-06-09
--

library ieee;
use ieee.std_logic_1164.all;

--
-- Interface to FIFO Intel FPGA IP.
--
entity ip_dcfifo_v2 is
generic (
    g_ADDR_WIDTH : positive := 8;
    g_DATA_WIDTH : positive := 8;
    DEVICE_FAMILY : string := "Arria 10"--;
);
port (
    i_wdata     : in    std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_we        : in    std_logic; -- write enable (request)
    o_wfull     : out   std_logic;
    o_wusedw    : out   std_logic_vector(g_ADDR_WIDTH-1 downto 0);
    i_wclk      : in    std_logic;

    o_rdata     : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_re        : in    std_logic; -- read enable (request, acknowledge)
    o_rempty    : out   std_logic;
    o_rusedw    : out   std_logic_vector(g_ADDR_WIDTH-1 downto 0);
    i_rclk      : in    std_logic;

    -- async clear
    i_reset_n   : in    std_logic--;
);
end entity;

library altera_mf;
use altera_mf.altera_mf_components.all;

architecture arch of ip_dcfifo_v2 is

    signal reset_n : std_logic;

    signal fifo_rdata : std_logic_vector(o_rdata'range);
    signal fifo_re : std_logic;
    signal fifo_rempty : std_logic;

begin

    assert ( g_ADDR_WIDTH >= 2 ) report "" severity failure;

    -- <ug_fifo.pdf>
    dcfifo_component : dcfifo
    generic map (
        -- Identifies the library of parameterized modules (LPM) entity name.
        lpm_type => "dcfifo",
        -- Specifies ... the width of the rdusedw and wrusedw ports for the DCFIFO function.
        lpm_widthu => g_ADDR_WIDTH,
        -- Specifies the depths of the FIFO you require. The value must be at least 4.
        -- The value assigned must comply to the following equation: 2^LPM_WIDTHU.
        lpm_numwords => 2**g_ADDR_WIDTH,
        -- Specifies the width of the data and q ports for the SCFIFO function and DCFIFO function. 
        lpm_width => g_DATA_WIDTH,
        -- Specifies whether the FIFO is in normal mode (OFF) or show-ahead mode (ON).
        lpm_showahead => "ON",
        -- Specifies whether to register the q output.
--        add_ram_output_register => "OFF",
        -- Specifies whether or not the FIFO Intel FPGA IP core is constructed using the RAM blocks.
        use_eab => "ON",
        -- Specifies whether or not to enable the protection circuitry
        -- for overflow/underflow checking that disables the wrreq/rdreq port
        -- when the FIFO Intel FPGA IP core is full
        overflow_checking => "ON",
        underflow_checking => "ON",
        -- Specifies whether or not to add a circuit that causes
        -- the aclr port to be internally synchronized by the wrclk/rdclk clocks.
        write_aclr_synch => "ON",
        read_aclr_synch => "ON",
        -- Specify the number of synchronization stages in the cross clock domain.
        -- The values of these parameters are internally reduced by two.
        wrsync_delaypipe => 4,
        rdsync_delaypipe => 4,
        -- Specifies the intended device that matches the device set in your Intel Quartus Prime project.
        -- Use only this parameter for functional simulation.
        intended_device_family => DEVICE_FAMILY--,
    )
    port map (
        data => i_wdata,
        wrreq => i_we,
        wrfull => o_wfull,
        wrusedw => o_wusedw,
        wrclk => i_wclk,

        q => fifo_rdata,
        rdreq => fifo_re,
        rdempty => fifo_rempty,
        rdusedw => o_rusedw,
        rdclk => i_rclk,

        -- Assert this signal to clear all the output status ports.
        -- There are no minimum number of clock cycles for aclr signals that must remain active.
        aclr => not i_reset_n--,
    );

    e_reset_n : entity work.reset_sync
    port map ( o_reset_n => reset_n, i_reset_n => i_reset_n, i_clk => i_rclk );

    e_fifo_rreg : entity work.fifo_rreg
    generic map (
        g_DATA_WIDTH => o_rdata'length--,
    )
    port map (
        o_rdata => o_rdata,
        i_re => i_re,
        o_rempty => o_rempty,

        i_rdata => fifo_rdata,
        o_re => fifo_re,
        i_rempty => fifo_rempty,

        i_reset_n => reset_n,
        i_clk => i_rclk--,
    );

end architecture;
