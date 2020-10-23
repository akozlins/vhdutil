#

add_instance adc altera_modular_adc
set_instance_parameter_value adc {use_tsd} {1}
# Conversion Sequence Length
set_instance_parameter_value adc {seq_order_length} {1}
# Conversion Sequence Channels
set_instance_parameter_value adc {seq_order_slot_1} {17}

set_interface_property adc_pll_clock EXPORT_OF adc.adc_pll_clock
set_interface_property adc_pll_locked EXPORT_OF adc.adc_pll_locked



nios_base.connect adc clock reset_sink sequencer_csr 0x700F0380
nios_base.connect adc ""    ""         sample_store_csr 0x700F0400

nios_base.connect_irq adc.sample_store_irq 3
