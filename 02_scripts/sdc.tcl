###############################################################################
# sdc.tcl - 统一 SDC（按 FREQ 切换）
# Period/Uncert/Trans/In_dly/Out_dly 来自 dc_synth_common.tcl
###############################################################################

# --- Clock ---
create_clock [get_ports clk] -name sys_clk     -period $PERIOD -waveform {0 [expr $PERIOD / 2]}
set_clock_uncertainty $UNCERT [get_clocks sys_clk]
set_clock_transition $TRANS   [get_clocks sys_clk]
set_dont_touch_network [get_clocks sys_clk]

# --- IO Delay ---
set_input_delay  $IN_DLY  -clock sys_clk     [remove_from_collection [all_inputs]         [get_ports "clk resetn irq_5 irq_6 irq_7"]]
set_output_delay $OUT_DLY -clock sys_clk [all_outputs]

# --- Async ---
set_false_path -from [get_ports resetn]
set_false_path -from [get_ports irq_5]
set_false_path -from [get_ports irq_6]
set_false_path -from [get_ports irq_7]
set_false_path -from [get_ports ser_rx]

# --- Timing Groups（inline collection）---
group_path -name input2reg     -from [all_inputs]     -to   [filter_collection [all_registers] "is_input_pin_used == true"]

group_path -name reg2reg     -from [filter_collection [all_registers] "is_output_pin_used == true"]     -to   [filter_collection [all_registers] "is_input_pin_used == true"]

group_path -name reg2out     -from [filter_collection [all_registers] "is_output_pin_used == true"]     -to   [all_outputs]

group_path -name clk     -from [get_clocks sys_clk]
