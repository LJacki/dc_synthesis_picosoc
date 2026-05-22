###############################################################################
# dc_synth.tcl - 共享综合脚本
# 启动: FREQ=100mhz dc_shell -f dc_synth.tcl
###############################################################################

source $SCR_DIR/dc_synth_common.tcl

puts ""
puts "=========================================="
puts "  DC Synthesis  ($FREQ)"
puts "=========================================="

# --- [1] 库 ---
puts "\n[1] Libraries..."
set target_library $NANGATE_DB
set link_library   [concat $target_library "*"]

# --- [2] RTL（明确顺序，picosoc.v 必须最后读入）---
puts "\n[2] RTL..."
read_verilog $RTL_DIR/picorv32.v
read_verilog $RTL_DIR/simpleuart.v
read_verilog $RTL_DIR/spiflash.v
read_verilog $RTL_DIR/spimemio.v
read_verilog $RTL_DIR/picosoc.v

# --- [3] Link ---
puts "\n[3] Link..."
link
current_design $TOP_MODULE

# --- [4] SDC ---
puts "\n[4] SDC..."
source $SCR_DIR/sdc.tcl

# --- [5] 设计规则 ---
puts "\n[5] Design rules..."
set_max_fanout      16 [current_design]
set_max_fanout      32 [get_clocks sys_clk]
set_max_transition   0.5 [current_design]
set_max_capacitance 0.5 [current_design]
puts "  max_fanout      = 16 (data) / 32 (clock)"
puts "  max_transition  = 0.5 ns"
puts "  max_capacitance = 0.5 pf"

# --- [6] Clock Gating 风格 ---
puts "\n[6] Clock gating style..."
set_clock_gating_style \
    -setup     0.5 \
    -hold      0.2 \
    -max_gated 256
puts "  CG: setup=0.5ns, hold=0.2ns, max_gated=256"

# --- [7] Power 优化 ---
puts "\n[7] Power optimization..."
set_power_optimization_options \
    -leakage_power_effort high \
    -dynamic_power_effort high
puts "  power_effort = high"

# --- [8] Compile ---
puts "\n[8] Compile..."
compile_ultra \
    -gate_clock \
    -no_autoungroup \
    -timing \
    -effort high

# --- [9] Reports ---
puts "\n[9] Reports..."

# Clock gating
report_clock_gating -hier -verbose > "$REPORTS/clock_gating.rpt"

# Timing by group (max_paths 从 20 改为 50，更全面)
report_timing -max_paths 50 -group input2reg > "$REPORTS/timing_input2reg.rpt"
report_timing -max_paths 50 -group reg2reg   > "$REPORTS/timing_reg2reg.rpt"
report_timing -max_paths 50 -group reg2out   > "$REPORTS/timing_reg2out.rpt"
report_timing -max_paths 10 -group clk        > "$REPORTS/timing_clk.rpt"

# Summary (增强：含 nworst 和 delay_type)
report_timing -max_paths 20 -nworst 5 -delay_type max > "$REPORTS/timing_summary.rpt"
report_timing -max_paths 20 -delay_type min             > "$REPORTS/timing_hold_summary.rpt"

# Power & QOR
report_power  -analysis_effort high > "$REPORTS/power_hq.rpt"
report_qor                          > "$REPORTS/qor_mapped.rpt"
report_area                         > "$REPORTS/area_mapped.rpt"
report_cell                        > "$REPORTS/cell_usage_mapped.rpt"
report_clock                        > "$REPORTS/clock_mapped.rpt"

# 500MHz 专用分析（只在 500MHz 频率下生成）
if { $FREQ == "500mhz" } {
    puts "  [NOTE] 500MHz mode: reporting extra analysis"
    report_timing -max_paths 5 -nworst 10 -path_type full > "$REPORTS/timing_500m_critical.rpt"
}
puts "  done"

# --- [10] Netlist ---
puts "\n[10] Netlist..."
set NETLIST_FILE "${TOP_MODULE}_${FREQ}_mapped"
write -format verilog -output "$NETLIST/${NETLIST_FILE}.v"
write_sdc                        "$NETLIST/${NETLIST_FILE}.sdc"
write -format ddc                "$NETLIST/${NETLIST_FILE}.ddc"
puts "  ${NETLIST_FILE}.v"

puts ""
puts "=========================================="
puts "  Complete: $FREQ"
puts "=========================================="
exit
