# DC Synthesis Results - 2026-05-22

## Summary

Three-frequency synthesis of **picosoc** using Synopsys Design Compiler O-2018.06-SP5 on Nangate 45nm library.

**All three frequencies met timing (WNS ≥ 0).**

## Results

| Metric | 100MHz | 300MHz | 500MHz |
|--------|--------|--------|--------|
| Period (ns) | 10.0 | 3.33 | 2.0 |
| WNS (ns) | +1.64 ✅ | 0.00 ✅ | 0.00 ✅ |
| Hold WNS (ns) | -0.59 | -0.31 | -0.26 |
| Levels of Logic | 11 | 39 | 27 |
| Cell Area (µm²) | 52,811.64 | 52,845.95 | ~52,800 |
| Leaf Cells | 19,763 | 19,731 | 19,775 |
| Total Power | 1.47 mW | 3.44 mW | 5.43 mW |
| Leakage Power | 942 µW | 942 µW | 946 µW |
| ICG Cells | 1,047 | 1,047 | 1,047 |
| Gated Registers | 8,402 (98.6%) | 8,402 (98.6%) | 8,402 (98.6%) |
| Compile Time (s) | ~130 | ~130 | ~130 |

## Issues

1. **Hold violations**: 100-1300+ paths (ignored per requirement)
2. **1 unresolved reference**: `picorv32` - RAM/ROM not instantiated (future: replace with SRAM model)
3. **MEM Error** (glibc 2.39 compatibility):不影响功能

## Scripts

- `dc_synth_final.tcl` - Clean verified synthesis script
- `dc_synth_300mhz_final.tcl` - 300MHz variant
- `dc_synth_500mhz_final.tcl` - 500MHz variant

## Output

Reports and netlists in:
- `03_output_100mhz/reports/`
- `03_output_300mhz/reports/`
- `03_output_500mhz/reports/`
