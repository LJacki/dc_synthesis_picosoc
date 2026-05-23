###############################################################################
# dc_synth_500mhz.tcl - 500MHz DC Synthesis Script
###############################################################################

set PROJ_DIR  /home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_advanced
set SCR_DIR   $PROJ_DIR/02_scripts
set RTL_DIR   $PROJ_DIR/00_rtl
set LIB_DIR   $PROJ_DIR/01_lib
set NANGATE_DB $LIB_DIR/NangateOpenCellLibrary_typical.db
set REPORTS   $PROJ_DIR/03_output_500mhz/reports
set NETLIST   $PROJ_DIR/03_output_500mhz/netlist

file mkdir $REPORTS
file mkdir $NETLIST

puts ""
puts "========== 500MHz Synthesis =========="

set target_library $NANGATE_DB
set link_library   [concat $target_library "*"]
puts "  target_library = $target_library"

set RTL_ORDERED {
    $RTL_DIR/picorv32.v
    $RTL_DIR/simpleuart.v
    $RTL_DIR/spiflash.v
    $RTL_DIR/spimemio.v
    $RTL_DIR/picosoc.v
}
foreach f $RTL_ORDERED {
    puts "  read_verilog $f"
    read_verilog $f
}

link
current_design picosoc

source $SCR_DIR/picosoc.sdc

create_clock clk -period 2.0
set_clock_uncertainty 0.15 [get_clocks sys_clk]

set_input_delay  0.5 -clock [get_clocks sys_clk] [remove_from_collection [all_inputs] [get_ports "clk resetn irq_5 irq_6 irq_7"]]
set_output_delay 0.5 -clock [get_clocks sys_clk] [all_outputs]

compile_ultra -gate_clock -no_autoungroup -timing
set_fix_hold [get_clocks sys_clk]

report_clock_gating -hier > "$REPORTS/clock_gating.rpt"
report_timing -max_paths 50 -group reg2reg > "$REPORTS/timing_reg2reg.rpt"
report_timing -max_paths 50 -group input2reg > "$REPORTS/timing_input2reg.rpt"
report_timing -max_paths 50 -group reg2out > "$REPORTS/timing_reg2out.rpt"
report_timing -max_paths 20 -nworst 5 > "$REPORTS/timing_summary.rpt"
report_power -analysis_effort high > "$REPORTS/power_hq.rpt"
report_qor > "$REPORTS/qor_mapped.rpt"
report_area > "$REPORTS/area_mapped.rpt"
report_cell > "$REPORTS/cell_usage_mapped.rpt"
report_clock > "$REPORTS/clock_mapped.rpt"

write -format verilog -output "$NETLIST/picosoc_500mhz_mapped.v"
write_sdc "$NETLIST/picosoc_500mhz_mapped.sdc"
write -format ddc "$NETLIST/picosoc_500mhz_mapped.ddc"

puts "  500MHz synthesis done"
exit
