###############################################################################
# dc_compile_C.tcl - compile_ultra: -no_gate_clock -no_autoungroup -timing
###############################################################################
set PROJ_DIR   "/home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_advanced"
set RTL_DIR    "$PROJ_DIR/00_rtl"
set LIB_DIR    "$PROJ_DIR/01_lib"
set NANGATE_DB "$LIB_DIR/NangateOpenCellLibrary_typical.db"
set TOP_MODULE "picosoc"
set OUTPUT_DIR "$PROJ_DIR/03_output_compile_C"
set REPORTS    "$OUTPUT_DIR/reports"
set NETLIST    "$OUTPUT_DIR/netlist"

# Clean cache to force recompile
file delete -force "$PROJ_DIR/work_lib" 2>/dev/null
file delete -force "$PROJ_DIR/alib-52" 2>/dev/null

file mkdir $REPORTS
file mkdir $NETLIST

set PERIOD   2.0
set UNCERT   0.15
set TRANS    0.1
set IN_DLY   0.5
set OUT_DLY  0.5
set MAX_FANOUT 16

puts "\n========================================"
puts "  DC Synthesis 500MHz - Group C"
puts "  compile_ultra -no_gate_clock -no_autoungroup -timing"
puts "========================================"

# --- [1] Library ---
puts "\n\[1/8\] Loading library..."
set target_library $NANGATE_DB
set link_library   [concat $target_library "*"]
set synthetic_library [list "dw_foundation.sldb"]

# --- [2] Analyze ---
puts "\n\[2/8\] Analyzing RTL..."
define_design_lib WORK -path ./work_lib
analyze -format verilog -library WORK "$RTL_DIR/picorv32.v"
analyze -format verilog -library WORK "$RTL_DIR/simpleuart.v"
analyze -format verilog -library WORK "$RTL_DIR/spiflash.v"
analyze -format verilog -library WORK "$RTL_DIR/spimemio.v"
analyze -format verilog -library WORK "$RTL_DIR/picosoc.v"

# --- [3] Elaborate ---
puts "\n\[3/8\] Elaborating $TOP_MODULE..."
elaborate $TOP_MODULE -library WORK
current_design $TOP_MODULE
link

# --- [4] Clock ---
puts "\n\[4/8\] Creating clock..."
create_clock [get_ports clk] -name sys_clk \
    -period $PERIOD -waveform [list 0.0 [expr {$PERIOD / 2.0}]]
set_clock_uncertainty $UNCERT [get_clocks sys_clk]
set_clock_transition  $TRANS  [get_clocks sys_clk]
set_dont_touch_network [get_clocks sys_clk]

# --- [5] IO Delay ---
puts "\n\[5/8\] Setting IO delays..."
set all_in_ex_clk [remove_from_collection [all_inputs] [get_clocks sys_clk]]
set all_out_ex_clk [remove_from_collection [all_outputs] [get_clocks sys_clk]]
if {[sizeof $all_out_ex_clk] > 0} {
    set_false_path -setup -from $all_out_ex_clk
}
set_input_delay  $IN_DLY -clock sys_clk $all_in_ex_clk
set_output_delay $OUT_DLY -clock sys_clk $all_out_ex_clk

# --- [6] Constraints ---
puts "\n\[6/8\] Setting constraints..."
set_max_fanout $MAX_FANOUT [current_design]

# --- [7] Compile ---
puts "\n\[7/8\] Compile (no_gate_clock)..."
compile_ultra -no_gate_clock -no_autoungroup -timing

# --- [8] Reports ---
puts "\n\[8/8\] Generating reports..."
redirect $REPORTS/qor.rpt {report_qor}
redirect -append $REPORTS/qor.rpt {report_timing -max_paths 10}
redirect $REPORTS/power.rpt {report_power}
redirect $REPORTS/area.rpt {report_area}
write -format verilog -hierarchy -output $NETLIST/${TOP_MODULE}_synth.v
write -format ddc -hierarchy -output $NETLIST/${TOP_MODULE}_synth.ddc
write_sdc $NETLIST/${TOP_MODULE}_synth.sdc

set icg_count [sizeof [get_cells -hier -filter "is_icg_cell == true"]]
puts "\nICG Count: $icg_count"

puts "\n========================================"
puts "  Done! Output: $OUTPUT_DIR"
puts "========================================"
exit
