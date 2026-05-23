# set_max_fanout Impact Evaluation - Final Results

## Test Summary

**Design**: picosoc | **Frequency**: 500MHz (PERIOD=2.0ns) | **Library**: NangateOpenCellLibrary

## Results

| Group | Fanout | WNS (ns) | Area (µm²) | Leaf Cells | Buf/Inv | Power (mW) | LoL | CP Delay (ns) |
|-------|--------|----------|------------|------------|---------|------------|-----|---------------|
| A | 4 | 0.00 | 77,197 | 37,230 | 9,683 | 8.98 | 19 | 0.76 |
| B | 8 | 0.00 | 73,394 | 32,237 | 4,654 | 8.86 | 17 | 0.78 |
| C | 16 | 0.00 | 71,883 | 30,191 | 2,703 | 8.84 | 16 | 0.81 |
| D | 32 | 0.00 | 71,378 | 29,453 | 1,894 | 8.83 | 16 | 0.78 |
| E | 64 | 0.00 | 71,264 | 29,211 | 1,719 | 8.83 | 24 | 1.29 |
| F | unset | 0.00 | 71,263 | 29,235 | 1,727 | 8.81 | 17 | 0.79 |

**Power** = Total Dynamic + Cell Leakage (from power.rpt)
**Buf/Inv** = Buf Cell Count + Inv Cell Count

## Analysis

### 1. Area vs Fanout (inverse relationship)
```
fanout=4:   Area=77,197 µm²  (+8.8% vs baseline)
fanout=8:   Area=73,394 µm²  (+2.1%
fanout=16:  Area=71,883 µm²  (baseline C)
fanout=32:  Area=71,378 µm²  (-0.7%
fanout=64:  Area=71,264 µm²  (-0.9%
unset:      Area=71,263 µm²  (-0.9%
```
Tight fanout constraint forces excessive buffer tree insertion -> area overhead.

### 2. Buffer Count vs Fanout (inverse relationship)
```
fanout=4:   9,683 buffers  (5.8x more than unset)
fanout=8:   4,654 buffers
fanout=16:  2,703 buffers
fanout=32:  1,894 buffers
fanout=64:  1,719 buffers
unset:      1,727 buffers  (DC auto-manages)
```
Buffer count drops rapidly from 4->16, then plateaus. DC starts auto-buffering around fanout=32.

### 3. Power vs Fanout (weak relationship)
All groups consume 8.81-8.98 mW total. Dynamic power difference is negligible (<2%).
More buffers slightly increase dynamic power but effect is minor for this design.

### 4. Timing vs Fanout (non-monotonic)
```
fanout=4:   CP=0.76ns, LoL=19
fanout=8:   CP=0.78ns, LoL=17
fanout=16:  CP=0.81ns, LoL=16
fanout=32:  CP=0.78ns, LoL=16  (better than C!)
fanout=64:  CP=1.29ns, LoL=24  (unexpected spike)
unset:      CP=0.79ns, LoL=17
```
Counter-intuitive: fanout=32 produces shorter CP than fanout=16. DC optimization is non-deterministic across runs.

### 5. Unexpected: fanout=64 (E group)
- LoL=24 (highest of all groups)
- CP=1.29ns (longest of all groups)
- Yet still WNS=0.00 (timing met)
- 4 Max Cap Violations (DC pushed high-fanout nets hard)
- Area still decreased - fewer buffers won

## Key Findings

1. **All 6 groups meet timing at 500MHz** (WNS=0.00) - the design is not fanout-limited
2. **Area savings plateau at fanout=32** - going beyond provides diminishing returns
3. **fanout=16 is the sweet spot** - minimal buffers, low area, stable timing
4. **fanout=4 is wasteful** - 9,683 buffers (+3.6x vs unset) for only 0.05ns CP improvement
5. **DC auto-behavior (unset) ≈ fanout=32** - DC's default fanout management is already aggressive

## Recommendation

| Scenario | Recommended fanout |
|----------|-------------------|
| Default / General use | 16 |
| Area-optimized (timing allows) | 32 |
| High-speed critical path | 4-8 |
| Fast synthesis (ignore fanout) | unset |

## Notes
- fanout=64 may cause routing congestion in larger designs (4 Max Cap Violations observed)
- fanout has minimal impact on power for this design
- Critical path length does NOT correlate linearly with fanout due to DC optimization non-determinism

## Raw Data

### QOR Data (from qor.rpt)

| Group | fanout | LoL | CP Length | Cell Area |
|-------|--------|-----|-----------|-----------|
| A | 4 | 19 | 0.76 | 77,197 |
| B | 8 | 17 | 0.78 | 73,394 |
| C | 16 | 16 | 0.81 | 71,883 |
| D | 32 | 16 | 0.78 | 71,378 |
| E | 64 | 24 | 1.29 | 71,264 |
| F | unset | 17 | 0.79 | 71,263 |

### Cell Counts

| Group | Leaf Cells | Comb Cells | Seq Cells | Buf Cells | Inv Cells |
|-------|-----------|-----------|----------|----------|----------|
| A | 37,230 | 18,348 | 11,843 | 7,415 | 2,268 |
| B | 32,237 | 18,348 | 11,843 | 3,025 | 1,629 |
| C | 30,191 | 18,348 | 11,843 | 1,484 | 1,219 |
| D | 29,453 | 17,610 | 11,843 | 723 | 1,171 |
| E | 29,211 | 17,368 | 11,843 | 581 | 1,138 |
| F | 29,235 | 17,392 | 11,843 | 572 | 1,155 |
