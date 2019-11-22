#
# author : Alexandr Kozlinskiy
#

# clock
add_instance clk clock_source
set_instance_parameter_value clk {clockFrequency} $nios_freq
set_instance_parameter_value clk {resetSynchronousEdges} {DEASSERT}

# cpu
add_instance cpu altera_nios2_gen2
set_instance_parameter_value cpu {impl} {Tiny}
set_instance_parameter_value cpu {resetSlave} {ram.s1}
set_instance_parameter_value cpu {resetOffset} {0x00000000}
set_instance_parameter_value cpu {exceptionSlave} {ram.s1}

# ram
add_instance ram altera_avalon_onchip_memory2
set_instance_parameter_value ram {memorySize} {0x00010000}
set_instance_parameter_value ram {initMemContent} {0}

# jtag master
add_instance jtag_master altera_jtag_avalon_master



add_connection clk.clk cpu.clk
add_connection clk.clk ram.clk1
add_connection clk.clk jtag_master.clk

add_connection clk.clk_reset cpu.reset
add_connection clk.clk_reset ram.reset1
add_connection clk.clk_reset jtag_master.clk_reset

add_connection                 cpu.data_master ram.s1
set_connection_parameter_value cpu.data_master/ram.s1                      baseAddress {0x10000000}
add_connection                 cpu.instruction_master ram.s1
set_connection_parameter_value cpu.instruction_master/ram.s1               baseAddress {0x10000000}
add_connection                 cpu.data_master cpu.debug_mem_slave
set_connection_parameter_value cpu.data_master/cpu.debug_mem_slave         baseAddress {0x70000000}
add_connection                 cpu.instruction_master cpu.debug_mem_slave
set_connection_parameter_value cpu.instruction_master/cpu.debug_mem_slave  baseAddress {0x70000000}



add_connection jtag_master.master ram.s1
add_connection jtag_master.master cpu.debug_mem_slave
add_connection cpu.debug_reset_request cpu.reset
add_connection cpu.debug_reset_request ram.reset1



# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF clk.clk_in
add_interface rst reset sink
set_interface_property rst EXPORT_OF clk.clk_in_reset



# uart, timers, i2c, spi
if 1 {
    add_instance sysid altera_avalon_sysid_qsys

    add_instance jtag_uart altera_avalon_jtag_uart

    add_instance timer altera_avalon_timer
    apply_preset timer "Simple periodic interrupt"
    set_instance_parameter_value timer {period} {1}
    set_instance_parameter_value timer {periodUnits} {MSEC}

    add_instance timer_ts altera_avalon_timer
    apply_preset timer_ts "Full-featured"

    add_instance i2c altera_avalon_i2c
    add_instance spi altera_avalon_spi

    add_instance pio altera_avalon_pio
    set_instance_parameter_value pio {direction} {Output}
    set_instance_parameter_value pio {width} {32}
    set_instance_parameter_value pio {bitModifyingOutReg} {32}

    foreach { name clk reset avalon addr } {
        sysid     clk   reset      control_slave     0x0000
        jtag_uart clk   reset      avalon_jtag_slave 0x0010
        timer     clk   reset      s1                0x0100
        timer_ts  clk   reset      s1                0x0140
        i2c       clock reset_sink csr               0x0200
        spi       clk   reset      spi_control_port  0x0240
        pio       clk   reset      s1                0x0280
    } {
        add_connection clk.clk       $name.$clk
        add_connection clk.clk_reset $name.$reset
        add_connection                 cpu.data_master $name.$avalon
        set_connection_parameter_value cpu.data_master/$name.$avalon baseAddress [ expr 0x700F0000 + $addr ]
        add_connection cpu.debug_reset_request $name.$reset
    }

    # IRQ assignments
    foreach { name irq } {
        jtag_uart.irq 3
        timer.irq 0
        i2c.interrupt_sender 10
        spi.irq 11
    } {
        add_connection cpu.irq $name
        set_connection_parameter_value cpu.irq/$name irqNumber $irq
    }

    add_interface i2c conduit end
    set_interface_property i2c EXPORTOF i2c.i2c_serial

    add_interface spi conduit end
    set_interface_property spi EXPORTOF spi.external

    add_interface pio conduit end
    set_interface_property pio EXPORT_OF pio.external_connection
}
