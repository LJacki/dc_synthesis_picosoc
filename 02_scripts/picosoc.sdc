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

# Clock uncertainty (jitter + margin) - reduced for internal clock
set_clock_uncertainty 0.2 [get_clocks sys_clk]

# Clock transition
set_clock_transition 0.1 [get_clocks sys_clk]

# Don't touch the clock network
set_dont_touch_network [get_clocks sys_clk]

###################################################################
# Clock Domain Crossing - Async IRQs
###################################################################
set_false_path -from [get_ports irq_5]
set_false_path -from [get_ports irq_6]
set_false_path -from [get_ports irq_7]

###################################################################
# Reset Path
###################################################################
set_false_path -from [get_ports resetn]

###################################################################
# Input Constraints
###################################################################
set_input_delay 1.0 -clock [get_clocks sys_clk]     [remove_from_collection [all_inputs]         [get_ports "clk resetn irq_5 irq_6 irq_7"] ]

###################################################################
# Output Constraints
# Reduced from 5.0ns to 1.0ns:
#   - Tclk_to_Q: ~0.3ns (Nangate 45nm FF)
#   - Tboard_routing: ~0.3ns (short on-chip or PCB)
#   - Tsetup(external): ~0.4ns (SPI flash spec)
#   Total: ~1.0ns (conservative but realistic)
###################################################################
set_output_delay 1.0 -clock [get_clocks sys_clk] [all_outputs]

###################################################################
# Flash/IO - keep under timing constraint (remove false_path)
# flash_csb, flash_clk, flash_io* are real timing paths
###################################################################
# (no false_path for flash signals - they are now timing-critical)

###################################################################
# UART - slow interface, set loose constraint
###################################################################
set_false_path -from [get_ports ser_rx]
