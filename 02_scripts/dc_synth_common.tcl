###############################################################################
# dc_synth_common.tcl - 共享变量 + 三组频率参数
# 启动: FREQ=100mhz dc_shell -f dc_synth.tcl
###############################################################################

set PROJ_DIR   /home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_advanced
set RTL_DIR    $PROJ_DIR/00_rtl
set LIB_DIR    $PROJ_DIR/01_lib
set SCR_DIR    $PROJ_DIR/02_scripts
set LOGS       $PROJ_DIR/04_logs

set NANGATE_DB $PROJ_DIR/01_lib/NangateOpenCellLibrary_typical.db
set TOP_MODULE picosoc
set CLK_PORT   clk
set RST_PORT   resetn

# === 频率参数 ===
if { ![info exists env(FREQ)] } {
    set FREQ 100mhz
} else {
    set FREQ $env(FREQ)
}

switch $FREQ {
    100mhz {
        set PERIOD   10.0;  set UNCERT  0.5;  set TRANS  0.2
        set IN_DLY   2.0;   set OUT_DLY 2.0
    }
    300mhz {
        set PERIOD   3.333; set UNCERT  0.2;  set TRANS  0.1
        set IN_DLY   0.8;   set OUT_DLY 0.8
    }
    500mhz {
        set PERIOD   2.0;   set UNCERT  0.15; set TRANS  0.08
        set IN_DLY   0.5;   set OUT_DLY 0.5
    }
    default {
        puts "ERROR: Unknown FREQ=$FREQ"
        exit 1
    }
}

# === 输出目录 ===
set OUTPUT_DIR $PROJ_DIR/03_output_
set REPORTS    ${OUTPUT_DIR}${FREQ}/reports
set NETLIST    ${OUTPUT_DIR}${FREQ}/netlist

file mkdir $REPORTS
file mkdir $NETLIST

puts ""
puts "=========================================="
puts "  Common Env Loaded"
puts "=========================================="
puts "  PERIOD   : $PERIOD ns"
puts "  UNCERT   : $UNCERT ns"
puts "  TRANS    : $TRANS ns"
puts "  IN_DLY   : $IN_DLY ns"
puts "  OUT_DLY  : $OUT_DLY ns"
puts "  REPORTS  : $REPORTS"
puts "  NANGATE  : $NANGATE_DB"
puts "=========================================="
