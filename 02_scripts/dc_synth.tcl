###############################################################################
# dc_synth.tcl - DC Synthesis Main Script
# picosoc / Nangate 45nm / compile_ultra
#
# Usage:
#   source /home/xiaoai/synopsys_env_setup.sh
#   cd /home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_advanced
#   dc_shell -f 02_scripts/dc_synth.tcl
#
# Prerequisite:
#   01_lib/NangateOpenCellLibrary_typical.db must exist
###############################################################################

set DC_COMMON "/home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_advanced/02_scripts/dc_common.tcl"
source $DC_COMMON

puts ""
puts "========== Loading target library =========="

if { [file exists $NANGATE_DB] } {
    puts "  Using Nangate 45nm: $NANGATE_DB"
    set target_library $NANGATE_DB
} else {
    puts "  WARNING: Nangate .db not found, using dw_foundation"
    set target_library $DW_DB
}
set link_library [concat $target_library "*"]

puts "  target_library = $target_library"
puts "  link_library   = $link_library"

puts ""
puts "========== Reading RTL =========="

set RTL_FILES [glob -directory $RTL_DIR *.v]

foreach f $RTL_FILES {
    puts "  read_verilog $f"
    read_verilog $f
}

puts ""
puts "========== Linking design =========="
link
current_design $TOP_MODULE

puts ""
puts "========== Clock constraints =========="

create_clock $CLK_PORT -period $CLK_PERIOD
set_clock_uncertainty $CLK_UNCERTAINTY [get_clocks $CLK_PORT]
set_clock_transition  $CLK_TRANSITION  [get_clocks $CLK_PORT]
set_dont_touch_network [get_clocks $CLK_PORT]

puts "  Clock $CLK_PORT: period=$CLK_PERIOD ns, uncertainty=$CLK_UNCERTAINTY ns"

puts ""
puts "========== IO constraints =========="

set_input_delay  $INPUT_DELAY -clock $CLK_PORT \
    [remove_from_collection [all_inputs] [get_ports "$CLK_PORT $RST_PORT"]]
set_output_delay $OUTPUT_DELAY -clock $CLK_PORT [all_outputs]

set_false_path -from [get_ports $RST_PORT]

puts "  input_delay  = $INPUT_DELAY ns"
puts "  output_delay = $OUTPUT_DELAY ns"

puts ""
puts "========== Fix hold violations =========="
set_fix_hold [get_clocks $CLK_PORT]
puts "  Done"

puts ""
puts "========== Compile =========="
compile_ultra -gate_clock
puts "  Done"

puts ""
puts "========== Reports =========="
report_timing  -max_paths 5 > "$REPORTS/timing_mapped.rpt"
report_area                     > "$REPORTS/area_mapped.rpt"
report_cell                     > "$REPORTS/cell_usage_mapped.rpt"
report_qor                      > "$REPORTS/qor_mapped.rpt"
report_clock                    > "$REPORTS/clock_mapped.rpt"
puts "  Reports written to $REPORTS/"

puts ""
puts "========== Write netlist =========="
write -format verilog -output "$NETLIST/${TOP_MODULE}_mapped.v"
write_sdc                        "$NETLIST/${TOP_MODULE}_mapped.sdc"
write -format ddc                "$NETLIST/${TOP_MODULE}_mapped.ddc"
puts "  Netlist: $NETLIST/${TOP_MODULE}_mapped.v"

puts ""
puts "=========================================="
puts "  DC Synthesis Complete"
puts "=========================================="
puts "  target_library : $target_library"
puts "  netlist        : $NETLIST/${TOP_MODULE}_mapped.v"
puts "=========================================="

exit
