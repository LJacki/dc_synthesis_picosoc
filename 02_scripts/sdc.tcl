###############################################################################
# sdc.tcl - 统一 SDC（按 FREQ 切换）
# Period/Uncert/Trans/In_dly/Out_dly 来自 dc_synth_common.tcl
###############################################################################

# --- Clock ---
create_clock [get_ports clk] -name sys_clk \
    -period $PERIOD -waveform {0 [expr $PERIOD / 2]}
set_clock_uncertainty $UNCERT [get_clocks sys_clk]
set_clock_transition $TRANS   [get_clocks sys_clk]
set_dont_touch_network [get_clocks sys_clk]

# --- IO Delay（修复：remove_from_collection 对空集加安全检查）---
set all_ins [all_inputs]
set excl_ports [get_ports "clk resetn irq_5 irq_6 irq_7"]
set excl_size [sizeof_collection $excl_ports]
if { $excl_size > 0 } {
    set data_ins [remove_from_collection $all_ins $excl_ports]
} else {
    set data_ins $all_ins
}
set_input_delay  $IN_DLY  -clock sys_clk $data_ins
set_output_delay $OUT_DLY -clock sys_clk [all_outputs]

# --- Async ---
set_false_path -from [get_ports resetn]
set_false_path -from [get_ports irq_5]
set_false_path -from [get_ports irq_6]
set_false_path -from [get_ports irq_7]
set_false_path -from [get_ports ser_rx]

# --- Timing Groups（inline filter_collection）---
# input -> register
group_path -name input2reg \
    -from [all_inputs] \
    -to   [filter_collection [all_registers] "is_input_pin_used == true"]

# register -> register (核心路径)
group_path -name reg2reg \
    -from [filter_collection [all_registers] "is_output_pin_used == true"] \
    -to   [filter_collection [all_registers] "is_input_pin_used == true"]

# register -> output
group_path -name reg2out \
    -from [filter_collection [all_registers] "is_output_pin_used == true"] \
    -to   [all_outputs]

# clock path group
group_path -name clk \
    -from [get_clocks sys_clk]
