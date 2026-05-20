###############################################################################
# dc_common.tcl - 共享变量和环境定义
# dc_synthesis_advanced - picosoc
# Synopsys Design Compiler O-2018.06-SP5
###############################################################################

# === 项目路径 ===
set PROJ_DIR  "/home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_advanced"
set RTL_DIR   "$PROJ_DIR/00_rtl"
set LIB_DIR   "$PROJ_DIR/01_lib"
set SCR_DIR   "$PROJ_DIR/02_scripts"
set OUTPUT    "$PROJ_DIR/03_output"
set REPORTS   "$OUTPUT/reports"
set NETLIST   "$OUTPUT/netlist"
set LOGS      "$PROJ_DIR/04_logs"

# === 库文件 ===
set NANGATE_LIB "$LIB_DIR/NangateOpenCellLibrary_typical.lib"
set NANGATE_DB  "$LIB_DIR/NangateOpenCellLibrary_typical.db"
set DW_DB         "/eda/syn/O-2018.06-SP5/libraries/syn/dw_foundation.sldb"
set GTECH_DB      "/eda/syn/O-2018.06-SP5/libraries/syn/gtech.db"

# === 设计信息 ===
set TOP_MODULE  "picosoc"
set CLK_PORT    "clk"
set RST_PORT    "resetn"

# === 时序约束（ns）===
set CLK_PERIOD       20.0
set CLK_UNCERTAINTY   0.5
set CLK_TRANSITION    0.2
set INPUT_DELAY       5.0
set OUTPUT_DELAY      5.0

# === 创建输出目录 ===
file mkdir $REPORTS
file mkdir $NETLIST
file mkdir $LOGS

# === 打印环境信息 ===
puts ""
puts "=========================================="
puts "  DC Synthesis Environment"
puts "=========================================="
puts "  PROJ_DIR       : $PROJ_DIR"
puts "  RTL_DIR        : $RTL_DIR"
puts "  TOP_MODULE     : $TOP_MODULE"
puts "  CLK_PORT       : $CLK_PORT"
puts "  CLK_PERIOD     : $CLK_PERIOD ns"
puts "  CLK_UNCERTAINTY: $CLK_UNCERTAINTY ns"
puts "  INPUT_DELAY    : $INPUT_DELAY ns"
puts "  OUTPUT_DELAY   : $OUTPUT_DELAY ns"
puts "=========================================="

# === 额外时钟（若有） ===
# set ADDITIONAL_CLOCKS [list]

# === Async CDC 信号（需 set_false_path）===
set ASYNC_IRQ_SIGNALS [list irq_5 irq_6 irq_7]
