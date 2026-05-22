###############################################################################
# dc_synth.tcl - 最终修复版
# 修复：移除 -max_gated, -effort; 简化时钟约束; 添加进度提示
###############################################################################

set PROJ_DIR   "/home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_advanced"
set RTL_DIR    "$PROJ_DIR/00_rtl"
set LIB_DIR    "$PROJ_DIR/01_lib"
set NANGATE_DB "$LIB_DIR/NangateOpenCellLibrary_typical.db"
set TOP_MODULE "picosoc"
set OUTPUT_DIR "$PROJ_DIR/03_output_300mhz"
set REPORTS    "$OUTPUT_DIR/reports"
set NETLIST    "$OUTPUT_DIR/netlist"

file mkdir $REPORTS
file mkdir $NETLIST

# === 参数 ===
set PERIOD   3.333
set UNCERT   0.2
set TRANS    0.1
set IN_DLY   0.8
set OUT_DLY  0.8

puts "\n========================================"
puts "  DC Synthesis 300MHz"
puts "========================================"

# --- [1] 库 ---
puts "\n\[1/10\] Loading library..."
set target_library $NANGATE_DB
set link_library  [concat $target_library "*"]

# --- [2] RTL ---
puts "\[2/10\] Reading RTL..."
read_verilog "$RTL_DIR/picorv32.v"
read_verilog "$RTL_DIR/simpleuart.v"
read_verilog "$RTL_DIR/spiflash.v"
read_verilog "$RTL_DIR/spimemio.v"
read_verilog "$RTL_DIR/picosoc.v"

# --- [3] Link ---
puts "\[3/10\] Linking..."
link
current_design $TOP_MODULE

# --- [4] 时钟 ---
puts "\[4/10\] Creating clock..."
create_clock [get_ports clk] -name sys_clk \
    -period $PERIOD -waveform [list 0.0 [expr {$PERIOD / 2.0}]]
set_clock_uncertainty $UNCERT [get_clocks sys_clk]
set_clock_transition  $TRANS  [get_clocks sys_clk]
set_dont_touch_network [get_clocks sys_clk]

# --- [5] IO Delay ---
puts "\[5/10\] Setting IO delays..."
set all_clocks [get_clocks sys_clk]
set_input_delay  $IN_DLY  -clock $all_clocks \
    [remove_from_collection [all_inputs] [get_ports "clk resetn irq_5 irq_6 irq_7"]]
set_output_delay $OUT_DLY -clock $all_clocks [all_outputs]

# --- [6] Async path ---
puts "\[6/10\] Setting async paths..."
set_false_path -from [get_ports resetn]
set_false_path -from [get_ports "irq_5 irq_6 irq_7"]
set_false_path -from [get_ports ser_rx]

# --- [7] Design Rule ---
puts "\[7/10\] Setting design rules..."
set_max_fanout 16 [current_design]
set_max_transition 0.5 [current_design]

# --- [8] Clock Gating ---
puts "\[8/10\] Setting clock gating..."
set_clock_gating_style -setup 0.5 -hold 0.2

# --- [9] Compile ---
puts "\[9/10\] Compiling (this takes 2-5 min)..."
compile_ultra -gate_clock -no_autoungroup -timing

# --- [10] Reports & Netlist ---
puts "\[10/10\] Writing reports..."
report_clock_gating > "$REPORTS/clock_gating.rpt"
report_timing       > "$REPORTS/timing.rpt"
report_power        > "$REPORTS/power.rpt"
report_qor          > "$REPORTS/qor.rpt"
report_area         > "$REPORTS/area.rpt"
report_cell         > "$REPORTS/cell.rpt"
report_clock        > "$REPORTS/clock.rpt"

write -format verilog -output "$NETLIST/${TOP_MODULE}_mapped.v"
write_sdc            "$NETLIST/${TOP_MODULE}_mapped.sdc"
write -format ddc    "$NETLIST/${TOP_MODULE}_mapped.ddc"

puts "\n========================================"
puts "  DONE - Reports in $REPORTS"
puts "========================================"
exit
