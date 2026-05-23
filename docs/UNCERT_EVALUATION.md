# set_clock_uncertainty Impact Evaluation

## Objective
Evaluate how `set_clock_uncertainty` values affect synthesis results for picosoc @ 500MHz.
Discover the actual timing margin of the design by finding the critical uncertainty value.

## Mechanism
`set_clock_uncertainty` represents clock jitter + PVT variation + margin.
It reduces the effective clock period for timing analysis:
```
effective_period = clock_period - uncertainty
```

## Test Plan

### Fixed Parameters

| Parameter | Value |
|-----------|-------|
| PERIOD | 2.0 ns (500MHz) |
| TRANSITION | 0.1 ns |
| INPUT_DELAY | 0.5 ns |
| OUTPUT_DELAY | 0.5 ns |
| MAX_FANOUT | 16 |
| compile | compile_ultra -gate_clock -no_autoungroup -timing |

### Test Cases (6 groups)

| Group | Uncertainty | Output Dir |
|-------|-------------|------------|
| A | 0.05 ns | 03_output_uncert_005 |
| B | 0.10 ns | 03_output_uncert_010 |
| C | 0.15 ns | 03_output_uncert_015 |
| D | 0.20 ns | 03_output_uncert_020 |
| E | 0.25 ns | 03_output_uncert_025 |
| F | 0.30 ns | 03_output_uncert_030 |

### Metrics

| Metric | Description |
|--------|-------------|
| WNS (Setup) | Most critical - when does it turn negative? |
| TNS | Total negative slack |
| Total Cell Area | Area cost |
| Levels of Logic | Critical path depth |
| Critical Path Delay | Actual path delay |
| Hold WNS | Hold timing margin |

## Expected Conclusion
- WNS should stay >= 0 until a certain uncertainty threshold
- The threshold reveals the actual timing margin of the design
- When uncertainty exceeds design margin, WNS becomes negative
- Area should be relatively stable across groups
- This tells us how much clock margin the design actually has

## Execution Order
A(0.05) -> B(0.10) -> C(0.15) -> D(0.20) -> E(0.25) -> F(0.30)
