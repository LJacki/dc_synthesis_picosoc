###############################################################################
# dc_synth_300mhz.tcl - 300MHz DC Synthesis Script
# Strategy: source SDC first (gets all constraints), then override clock period
###############################################################################

set PROJ_DIR  /home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_advanced
set SCR_DIR   $PROJ_DIR/02_scripts
set RTL_DIR   $PROJ_DIR/00_rtl
set LIB_DIR   $PROJ_DIR/01_lib
set NANGATE_DB $LIB_DIR/NangateOpenCellLibrary_typical.db
set REPORTS   $PROJ_DIR/03_output/reports
set NETLIST   $PROJ_DIR/03_output/netlist
set OUTPUT    $PROJ_DIR/03_output
set LOGS      $PROJ_DIR/04_logs

# 300MHz parameters
set CLK_PERIOD      3.333
set CLK_UNCERTAINTY 0.2
set INPUT_DELAY     0.5
set OUTPUT_DELAY    0.5
set TOP_MODULE      picosoc
set CLK_PORT        clk
set RST_PORT        resetn

file mkdir $REPORTS
file mkdir $NETLIST

puts ""
puts "========== 300MHz Synthesis =========="
puts "  CLK_PERIOD      : $CLK_PERIOD ns"
puts "  CLK_UNCERTAINTY : $CLK_UNCERTAINTY ns"

puts ""
puts "========== Loading target library =========="
set target_library $NANGATE_DB
set link_library   [concat $target_library "*"]
puts "  target_library = $target_library"

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
puts "========== Source SDC (gets all constraints) =========="
source $SCR_DIR/picosoc.sdc

puts ""
puts "========== Override clock period to 300MHz =========="
create_clock $CLK_PORT -period $CLK_PERIOD
set_clock_uncertainty $CLK_UNCERTAINTY [get_clocks sys_clk]

puts ""
puts "========== IO constraints (override SDC values) =========="
set_input_delay  $INPUT_DELAY -clock [get_clocks sys_clk]     [remove_from_collection [all_inputs] [get_ports "$CLK_PORT $RST_PORT irq_5 irq_6 irq_7"]]
set_output_delay $OUTPUT_DELAY -clock [get_clocks sys_clk] [all_outputs]

puts ""
puts "========== Compile Ultra =========="
compile_ultra -gate_clock
puts "  Done"

puts ""
puts "========== Fix hold violations (AFTER compile) =========="
set_fix_hold [get_clocks sys_clk]
puts "  Done"

puts ""
puts "========== Reports =========="
report_timing  -max_paths 10 > "$REPORTS/timing_mapped.rpt"
report_timing  -max_paths 50 -delay min > "$REPORTS/hold_timing_mapped.rpt"
report_area                     > "$REPORTS/area_mapped.rpt"
report_cell                     > "$REPORTS/cell_usage_mapped.rpt"
report_qor                      > "$REPORTS/qor_mapped.rpt"
report_clock                    > "$REPORTS/clock_mapped.rpt"
puts "  Reports written"

puts ""
puts "========== Write netlist =========="
write -format verilog -output "$NETLIST/${TOP_MODULE}_mapped.v"
write_sdc                        "$NETLIST/${TOP_MODULE}_mapped.sdc"
write -format ddc                "$NETLIST/${TOP_MODULE}_mapped.ddc"
puts "  Netlist: $NETLIST/${TOP_MODULE}_mapped.v"

puts ""
puts "=========================================="
puts "  DC 300MHz Synthesis Complete"
puts "  CLK_PERIOD : $CLK_PERIOD ns"
puts "=========================================="

exit
