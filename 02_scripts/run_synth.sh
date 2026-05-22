#!/bin/bash
# run_synth.sh - 综合启动脚本
# Usage: ./run_synth.sh 100mhz

FREQ=${1:-100mhz}
LOG="dc_${FREQ}.log"

source /home/xiaoai/synopsys_env_setup.sh
cd /home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_advanced

echo "===== DC Synthesis: $FREQ ====="
FREQ=$FREQ dc_shell -f 02_scripts/dc_synth.tcl 2>&1 | tee 04_logs/$LOG

echo "===== Done: $FREQ ====="
