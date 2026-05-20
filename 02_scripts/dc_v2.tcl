set DC_COMMON "/home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_advanced/02_scripts/dc_common.tcl"
source $DC_COMMON
set target_library $NANGATE_DB
set link_library [concat $target_library "*"]
set RTL_FILES [glob -directory $RTL_DIR *.v]
puts "RTL files: $RTL_FILES"
foreach f $RTL_FILES { read_verilog $f }
puts "All RTL loaded, linking..."
link
puts "Link done, setting top..."
current_design $TOP_MODULE
puts "Clock..."
create_clock $CLK_PORT -period $CLK_PERIOD
set_clock_uncertainty $CLK_UNCERTAINTY [get_clocks $CLK_PORT]
set_clock_transition $CLK_TRANSITION [get_clocks $CLK_PORT]
set_dont_touch_network [get_clocks $CLK_PORT]
puts "IO constraints..."
set_input_delay $INPUT_DELAY -clock $CLK_PORT [remove_from_collection [all_inputs] [get_ports "$CLK_PORT $RST_PORT"]]
set_output_delay $OUTPUT_DELAY -clock $CLK_PORT [all_outputs]
set_false_path -from [get_ports $RST_PORT]
puts "Fix hold..."
set_fix_hold [get_clocks $CLK_PORT]
puts "Compile..."
if { [catch {compile} result] } {
  puts "COMPILE FAILED: $result"
  exit 1
}
puts "Compile done, reports..."
report_qor > $REPORTS/qor_mapped.rpt
report_timing -max_paths 5 > $REPORTS/timing_mapped.rpt
report_area > $REPORTS/area_mapped.rpt
report_cell > $REPORTS/cell_usage_mapped.rpt
report_clock > $REPORTS/clock_mapped.rpt
puts "Reports done, writing netlist..."
write -format verilog -output $NETLIST/${TOP_MODULE}_mapped.v
write_sdc $NETLIST/${TOP_MODULE}_mapped.sdc
puts "Netlist done"
exit 0
