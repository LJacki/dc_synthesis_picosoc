###############################################################################
# dc_analyze_fix.tcl - 修复 link 问题
# 核心：用 analyze + elaborate 替代 read_verilog
# 确保所有模块正确写入 WORK 库，消除 unresolved reference
###############################################################################

set PROJ_DIR   "/home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_advanced"
set RTL_DIR    "$PROJ_DIR/00_rtl"
set LIB_DIR    "$PROJ_DIR/01_lib"
set NANGATE_DB "$LIB_DIR/NangateOpenCellLibrary_typical.db"
set TOP_MODULE "picosoc"
set OUTPUT_DIR "$PROJ_DIR/03_output_500mhz"
set REPORTS    "$OUTPUT_DIR/reports"
set NETLIST    "$OUTPUT_DIR/netlist"

file mkdir $REPORTS
file mkdir $NETLIST

# === 参数 ===
set PERIOD   2.0
set UNCERT   0.15
set TRANS    0.1
set IN_DLY   0.5
set OUT_DLY  0.5

puts "\n========================================"
puts "  DC Synthesis 500MHz (analyze fix)"
puts "========================================"

# --- [1] 库 ---
puts "\n\[1/10\] Loading library..."
set target_library $NANGATE_DB
set link_library   [concat $target_library "*"]
set synthetic_library [list "dw_foundation.sldb"]

# --- [2] Analyze RTL (顺序敏感！picosoc.v 第22行检查顺序) ---
puts "\n\[2/10\] Analyzing RTL..."
# 必须先分析 picorv32.v，因为 picosoc.v 第22行有检查
analyze -format verilog -library WORK "$RTL_DIR/picorv32.v"
analyze -format verilog -library WORK "$RTL_DIR/simpleuart.v"
analyze -format verilog -library WORK "$RTL_DIR/spiflash.v"
analyze -format verilog -library WORK "$RTL_DIR/spimemio.v"
analyze -format verilog -library WORK "$RTL_DIR/picosoc.v"

# --- [3] Elaborate ---
puts "\n\[3/10\] Elaborating $TOP_MODULE..."
elaborate $TOP_MODULE -library WORK
current_design $TOP_MODULE

# --- [4] Link ---
puts "\n\[4/10\] Linking..."
link

# --- [5] 时钟 ---
puts "\n\[5/10\] Creating clock..."
create_clock [get_ports clk] -name sys_clk \
    -period $PERIOD -waveform [list 0.0 [expr {$PERIOD / 2.0}]]
set_clock_uncertainty $UNCERT [get_clocks sys_clk]
set_clock_transition  $TRANS  [get_clocks sys_clk]
set_dont_touch_network [get_clocks sys_clk]

# --- [6] IO Delay ---
puts "\n\[6/10\] Setting IO delays..."
set all_clocks [get_clocks sys_clk]
set_input_delay  $IN_DLY  -clock $all_clocks \
    [remove_from_collection [all_inputs] [get_ports "clk resetn irq_5 irq_6 irq_7"]]
set_output_delay $OUT_DLY -clock $all_clocks [all_outputs]

# --- [7] Async path ---
puts "\n\[7/10\] Setting async paths..."
set_false_path -from [get_ports resetn]
set_false_path -from [get_ports "irq_5 irq_6 irq_7"]
set_false_path -from [get_ports ser_rx]

# --- [8] Design Rule ---
puts "\n\[8/10\] Setting design rules..."
set_max_fanout 16 [current_design]
set_max_transition 0.5 [current_design]

# --- [9] Clock Gating ---
puts "\n\[9/10\] Setting clock gating..."
set_clock_gating_style -setup 0.5 -hold 0.2

# --- [10] Compile ---
puts "\n\[10/10\] Compiling (this takes 2-5 min)..."
compile_ultra -gate_clock -no_autoungroup -timing

# --- [11] Reports & Netlist ---
puts "\n\[11/11\] Writing reports..."
file mkdir $REPORTS
file mkdir $NETLIST
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
