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
    g_SHOWAHEAD : string := "ON";
    g_RREG_N : positive := 2;
    g_WREG_N : positive := 2;
    g_DEVICE_FAMILY : string := "Arria 10"--;
);
port (
    o_rdata     : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_rack      : in    std_logic; -- read enable (request, acknowledge)
    o_rempty    : out   std_logic;
    o_rusedw    : out   std_logic_vector(g_ADDR_WIDTH-1 downto 0);
    i_rclk      : in    std_logic;

    i_wdata     : in    std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_we        : in    std_logic; -- write enable (request)
    o_wfull     : out   std_logic;
    o_wusedw    : out   std_logic_vector(g_ADDR_WIDTH-1 downto 0);
    i_wclk      : in    std_logic;

    -- async clear
    i_reset_n   : in    std_logic--;
);
end entity;

library altera_mf;
use altera_mf.altera_mf_components.all;

architecture arch of ip_dcfifo_v2 is

    signal fifo_rdata, fifo_wdata : std_logic_vector(g_DATA_WIDTH-1 DOWNTO 0);
    signal fifo_rack, fifo_rempty, rreset_n, fifo_we, fifo_wfull, wreset_n : std_logic;

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
        lpm_showahead => g_SHOWAHEAD,
        -- Specifies whether to register the q output.
--        add_ram_output_register => "OFF",
        -- Specifies whether or not the FIFO Intel FPGA IP core is constructed using the RAM Embedded Array Blocks.
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
        intended_device_family => g_DEVICE_FAMILY--,
    )
    port map (
        q => fifo_rdata,
        rdreq => fifo_rack,
        rdempty => fifo_rempty,
        rdusedw => o_rusedw,
        rdclk => i_rclk,

        data => fifo_wdata,
        wrreq => fifo_we,
        wrfull => fifo_wfull,
        wrusedw => o_wusedw,
        wrclk => i_wclk,

        -- Assert this signal to clear all the output status ports.
        -- There are no minimum number of clock cycles for aclr signals that must remain active.
        aclr => not i_reset_n--,
    );

    generate_showahead_off : if ( g_SHOWAHEAD /= "ON" ) generate
        o_rdata <= fifo_rdata;
        fifo_rack <= i_rack;
        o_rempty <= fifo_rempty;
    end generate;

    generate_showahead_on : if ( g_SHOWAHEAD = "ON" ) generate
        -- sync read clock reset
        e_rreset_n : entity work.reset_sync
        port map ( o_reset_n => rreset_n, i_reset_n => i_reset_n, i_clk => i_rclk );

        -- read through reg fifo
        e_fifo_rreg : entity work.fifo_reg
        generic map (
            g_DATA_WIDTH => g_DATA_WIDTH,
            g_N => g_RREG_N--,
        )
        port map (
            o_rdata => o_rdata,
            i_rack => i_rack,
            o_rempty => o_rempty,

            i_wdata => fifo_rdata,
            i_we => not fifo_rempty,
            o_wfull_n => fifo_rack,

            i_reset_n => rreset_n,
            i_clk => i_rclk--,
        );
    end generate;

    -- sync write clock reset
    e_wreset_n : entity work.reset_sync
    port map ( o_reset_n => wreset_n, i_reset_n => i_reset_n, i_clk => i_wclk );

    -- write through reg fifo
    e_fifo_wreg : entity work.fifo_reg
    generic map (
        g_DATA_WIDTH => g_DATA_WIDTH,
        g_N => g_WREG_N--,
    )
    port map (
        o_rdata => fifo_wdata,
        i_rack => not fifo_wfull,
        o_rempty_n => fifo_we,

        i_wdata => i_wdata,
        i_we => i_we,
        o_wfull => o_wfull,

        i_reset_n => wreset_n,
        i_clk => i_wclk--,
    );

end architecture;
