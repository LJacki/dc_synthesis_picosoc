# set_max_fanout Impact Evaluation

## Objective
Evaluate how `set_max_fanout` values affect synthesis results for picosoc @ 500MHz.

## Mechanism
`set_max_fanout` limits the maximum fanout of a single net. When exceeded, DC inserts buffer trees to split the load.

## Trade-off Summary

| Value | Pros | Cons |
|-------|------|------|
| 4-8 | Better timing, easier routing | More buffers - Area up Power up |
| 16 | Balanced | Default reference |
| 32-48 | Less buffers - Area down Power down | Longer paths - Timing harder to meet |
| 64+ | Minimal buffers | Routing congestion, timing violations |
| None | DC auto-decides | Unpredictable results |

## Test Plan

### Fixed Parameters

| Parameter | Value |
|-----------|-------|
| PERIOD | 2.0 ns (500MHz) |
| UNCERTAINTY | 0.15 ns |
| TRANSITION | 0.1 ns |
| INPUT_DELAY | 0.5 ns |
| OUTPUT_DELAY | 0.5 ns |
| compile | compile_ultra -gate_clock -no_autoungroup -timing |

### Test Cases (6 groups)

| Group | Fanout Value | Output Dir |
|-------|---------------|------------|
| A | 4 | 03_output_fanout_4 |
| B | 8 | 03_output_fanout_8 |
| C | 16 | 03_output_fanout_16 |
| D | 32 | 03_output_fanout_32 |
| E | 64 | 03_output_fanout_64 |
| F | unset | 03_output_fanout_none |

### Metrics

| Metric | Description |
|--------|-------------|
| WNS / TNS | Timing margin |
| Total Cell Area (um2) | Area cost |
| Buffer/Inv Cell Count | Buffer insertion count |
| Total Power (mW) | Dynamic + leakage power |
| Levels of Logic | Critical path depth |
| Critical Path Delay (ns) | Actual path delay |
| Leaf Cell Count | Gate-level cell count |
| Gated Registers / ICG Count | Clock gating efficiency |

## Execution Order
A(4) -> B(8) -> C(16) -> D(32) -> E(64) -> F(none)

## Expected Conclusion
Small fanout -> more buffers -> area up power up -> shorter paths -> better timing
Large fanout -> fewer buffers -> area down power down -> longer paths -> worse timing
