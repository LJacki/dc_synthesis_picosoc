set DC_COMMON "/home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_advanced/02_scripts/dc_common.tcl"
source $DC_COMMON
set target_library $NANGATE_DB
set link_library [concat $target_library "*"]
set RTL_FILES [glob -directory $RTL_DIR *.v]
foreach f $RTL_FILES { read_verilog $f }
link
current_design $TOP_MODULE
create_clock $CLK_PORT -period $CLK_PERIOD
set_clock_uncertainty $CLK_UNCERTAINTY [get_clocks $CLK_PORT]
set_clock_transition $CLK_TRANSITION [get_clocks $CLK_PORT]
set_dont_touch_network [get_clocks $CLK_PORT]
set_input_delay $INPUT_DELAY -clock $CLK_PORT [remove_from_collection [all_inputs] [get_ports "$CLK_PORT $RST_PORT"]]
set_output_delay $OUTPUT_DELAY -clock $CLK_PORT [all_outputs]
set_false_path -from [get_ports $RST_PORT]
set_fix_hold [get_clocks $CLK_PORT]
compile -no_design_rule
report_qor > $REPORTS/qor_mapped.rpt
write -format verilog -output $NETLIST/${TOP_MODULE}_mapped.v
exit
