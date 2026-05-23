# compile_ultra Options Impact Evaluation

## Objective
Evaluate the impact of two `compile_ultra` options on picosoc @ 500MHz:
1. `-autoungroup` vs `-no_autoungroup` (module boundary preservation)
2. `-gate_clock` enabled vs disabled (clock gating effect)

## Background

### compile_ultra Available Options (DC O-2018.06-SP5, Classic Mode)

| Option | Current | Description |
|--------|---------|-------------|
| `-gate_clock` | ✅ Used | Optimize clock gating |
| `-no_autoungroup` | ✅ Used | Preserve module hierarchy |
| `-autoungroup` | ❌ Not used | Allow DC to auto-ungroup modules for deeper optimization |
| `-timing` | ✅ Used (default) | Timing-driven compilation |
| `-spg` | ❌ N/A | Requires `-topographical_mode` + Milkyway/LEF (not available) |

## Test Plan

### Fixed Parameters

| Parameter | Value |
|-----------|-------|
| PERIOD | 2.0 ns (500MHz) |
| TRANSITION | 0.1 ns |
| INPUT_DELAY | 0.5 ns |
| OUTPUT_DELAY | 0.5 ns |
| MAX_FANOUT | 16 |
| UNCERTAINTY | 0.15 ns |
| compile | compile_ultra |

### 3 Groups

| Group | Option Change | compile command |
|-------|---------------|----------------|
| **A** | Baseline | `compile_ultra -gate_clock -no_autoungroup -timing` |
| **B** | autoungroup | `compile_ultra -gate_clock -autoungroup -timing` |
| **C** | no gate_clock | `compile_ultra -no_gate_clock -no_autoungroup -timing` |

### Expected Outcomes

#### A vs B (autoungroup)
- **WNS**: autoungroup may improve (DC has more freedom to optimize across boundaries)
- **Area**: unpredictable — could go up or down
- **Hierarchy**: broken in B (harder to map cells back to RTL modules)
- **Levels of Logic**: likely decreases (deeper optimization)

#### A vs C (gate_clock)
- **ICG Count**: should drop significantly (C has ~0 ICGs)
- **Area**: may slightly increase (no clock gating overhead savings)
- **Power**: C has higher dynamic + leakage power (no glitch filtering)
- **WNS**: minimal impact (clock gating doesn't affect combinational logic delay)

## Metrics

| Metric | Description | Priority |
|--------|-------------|----------|
| WNS (Setup) | Primary timing metric | 🔴 High |
| TNS | Total negative slack | 🔴 High |
| Total Cell Area | Area cost | 🟡 Medium |
| Leaf Cell Count | Cell count | 🟡 Medium |
| ICG Instance Count | Clock gating cells | 🟡 Medium |
| Levels of Logic | Path depth | 🟡 Medium |
| Critical Path Delay | Path length | 🟡 Medium |
| Hold WNS | Hold margin | 🟡 Medium |
| Leakage Power | Standby power | 🟢 Low |
| Switching Power | Dynamic power | 🟢 Low |

## Execution Order
A (baseline) → B (autoungroup) → C (no_gate_clock)
