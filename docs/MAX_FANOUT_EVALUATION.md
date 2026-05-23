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

---

# set_max_fanout 影响评估（6组实验）

> 评估时间: 2026-05-23  
> 设计: picosoc | 目标频率: 500 MHz  
> 工具: DC O-2018.06-SP5 | 工艺库: NangateOpenCellLibrary_typical.db

## 综合参数

| 参数 | 值 |
|------|-----|
| 时钟周期 | 2.0 ns |
| 时钟不确定度 | 0.15 ns |
| 时钟转换时间 | 0.1 ns |
| 输入延迟 | 0.5 ns |
| 输出延迟 | 0.5 ns |
| compile 命令 | `compile_ultra -gate_clock -no_autoungroup -timing` |

## 6组结果对比

| Metric | fanout=4 (A) | fanout=8 (B) | fanout=16 (C) | fanout=32 (D) | fanout=64 (E) | unset (F) |
|--------|---------------|---------------|----------------|----------------|----------------|------------|
| **WNS (Setup)** | 0.00 ns | 0.00 ns | 0.00 ns | 0.00 ns | 0.00 ns | 0.00 ns |
| **Total Cell Area (μm²)** | 77196.92 | 73394.45 | 71882.51 | 71377.91 | 71263.53 | 71262.73 |
| **Leaf Cell Count** | 37230 | 32237 | 30191 | 29453 | 29211 | 29235 |
| **Buffer Cell Count** | 7415 | 3025 | 1484 | 723 | 581 | 572 |
| **Inv Cell Count** | 2268 | 1629 | 1219 | 1171 | 1138 | 1155 |
| **Total Power (mW)** | 8.98 | 8.86 | 8.84 | 8.83 | 8.83 | 8.81 |
| **Dynamic Power (mW)** | 7.58 | 7.53 | 7.53 | 7.52 | 7.52 | 7.50 |
| **Leakage Power (mW)** | 1.40 | 1.34 | 1.31 | 1.31 | 1.30 | 1.31 |
| **Levels of Logic** | 19.00 | 17.00 | 16.00 | 16.00 | 24.00 | 17.00 |
| **Critical Path Delay (ns)** | 0.76 | 0.78 | 0.81 | 0.78 | 1.29 | 0.79 |

## 分析结论

### 1. 面积与 fanout 约束强度负相关
- `fanout=4` 时面积最大（77197 μm²），buffer 7415个
- `fanout=32/64/unset` 时面积趋于稳定（~71263 μm²），buffer 572-581个
- **原因**: 严格的 fanout 限制迫使工具插入更多 buffer 来分割高扇出网络

### 2. 功耗随 fanout 放松而下降
- `fanout=4` 总功耗 8.98 mW（动态 7.58 + 泄漏 1.40）
- `unset` 总功耗 8.81 mW（动态 7.50 + 泄漏 1.31）
- 缓冲器数量减少是功耗下降的主因

### 3. fanout=64 时路径最深（时序风险）
- `fanout=64` Levels of Logic=24，Critical Path 1.29 ns
- 其他组 Levels of Logic 在 16-19 之间
- **原因**: 大 fanout 限制允许长缓冲器链，工具通过增加逻辑深度满足时序

### 4. 所有组均满足 500 MHz 时序约束
- WNS 全部为 0.00 ns（恰好满足）
- 宽松 fanout（64/unset）工具通过更多逻辑级数补偿缓冲器不足

### 推荐
| 场景 | 推荐 fanout | 理由 |
|------|------------|------|
| 面积最优 | unset 或 32+ | 最少缓冲器，最小面积 |
| 功耗最优 | unset 或 32+ | 缓冲器少，总功耗最低 |
| 时序稳健 | 16 或 32 | Levels of Logic 最低（16），路径最短 |
| **综合推荐** | **16** | 面积/功耗接近最优，时序路径最浅 |
