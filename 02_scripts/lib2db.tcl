###############################################################################
# lib2db.tcl - 将 Liberty (.lib) 转换为 Synopsys .db 格式
# 使用独立 lc_shell（Nangate 45nm 工艺库）
#
# 用法:
#   source /home/xiaoai/synopsys_env_setup.sh
#   lc_shell -no_home -f 02_scripts/lib2db.tcl
###############################################################################

set PROJ_DIR  "/home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_advanced"
set LIB_DIR   "$PROJ_DIR/01_lib"
set LIB_FILE  "$LIB_DIR/NangateOpenCellLibrary_typical.lib"
set DB_FILE   "$LIB_DIR/NangateOpenCellLibrary_typical.db"

puts ""
puts "=========================================="
puts "  Library Compiler - .lib to .db"
puts "=========================================="
puts "  Input : $LIB_FILE"
puts "  Output: $DB_FILE"
puts "=========================================="

puts ""
puts "[STEP 1] Reading $LIB_FILE ..."
read_lib $LIB_FILE
puts "  Done"

puts ""
puts "[STEP 2] Writing $DB_FILE ..."
write_lib NangateOpenCellLibrary -format db -output $DB_FILE
puts "  Done"

puts ""
puts "[STEP 3] Verifying ..."
set size [file size $DB_FILE]
puts "  File size: [expr \$size / 1024] KB"
puts ""
puts "=========================================="
puts "  Conversion Complete"
puts "=========================================="

exit
