###################################################################
# picosoc SDC constraints
# Generated for dc_synthesis_advanced
###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA

###################################################################
# Clock Definition
###################################################################
create_clock [get_ports clk] -name sys_clk -period 20.0 -waveform {0 10}

# Clock uncertainty (jitter + margin)
set_clock_uncertainty 0.5 [get_clocks sys_clk]

# Clock transition
set_clock_transition 0.15 [get_clocks sys_clk]

# Don't touch the clock network
set_dont_touch_network [get_clocks sys_clk]

###################################################################
# Clock Domain Crossing - Async IRQs
# irq_5/6/7 are async inputs from external sources
# These paths are not timing-critical, set false path
###################################################################
set_false_path -from [get_ports irq_5]
set_false_path -from [get_ports irq_6]
set_false_path -from [get_ports irq_7]

###################################################################
# Reset Path
# resetn is async low-reset, not synchronous to clk
###################################################################
set_false_path -from [get_ports resetn]

###################################################################
# Input Constraints
###################################################################
# All inputs except clk/resetn/irq_* relative to sys_clk
set_input_delay 5.0 -clock [get_clocks sys_clk] \
    [remove_from_collection [all_inputs] \
        [get_ports "clk resetn irq_5 irq_6 irq_7"]]

###################################################################
# Output Constraints
###################################################################
set_output_delay 5.0 -clock [get_clocks sys_clk] [all_outputs]

###################################################################
# Flash/IO related false paths
# These are slow external signals relative to CPU clock
###################################################################
set_false_path -from [get_ports ser_rx]
set_false_path -to [get_ports flash_csb]
set_false_path -to [get_ports flash_clk]
