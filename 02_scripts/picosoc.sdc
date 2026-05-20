set sdc_version 2.1
set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
create_clock [get_ports clk] -name sys_clk -period 20.0 -waveform {0 10}
set_clock_uncertainty 0.2 [get_clocks sys_clk]
set_clock_transition 0.1 [get_clocks sys_clk]
set_dont_touch_network [get_clocks sys_clk]
set_false_path -from [get_ports irq_5]
set_false_path -from [get_ports irq_6]
set_false_path -from [get_ports irq_7]
set_false_path -from [get_ports resetn]
set_input_delay 0.5 -clock [get_clocks sys_clk]     [remove_from_collection [all_inputs]         [get_ports "clk resetn irq_5 irq_6 irq_7"] ]
set_output_delay 1.0 -clock [get_clocks sys_clk] [all_outputs]
set_false_path -from [get_ports ser_rx]
