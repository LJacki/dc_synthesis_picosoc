# D & E 综合指令评估方案

> 日期：2026-05-23
> 设计：picosoc（含 picorv32）
> 频率：500MHz（PERIOD=2.0ns）
> 工具：DC O-2018.06-SP5

---

## 实验 D：set_max_area 梯度约束

**目的**：探索面积约束与时序的折衷关系，找到 Pareto 前沿。

| 组 | 约束 | 说明 |
|----|------|------|
| **D1** | 无 | 自然面积（基线，对应 A 组 71,985 µm²） |
| **D2** | `set_max_area 60000` | 宽松约束，比自然面积小 17% |
| **D3** | `set_max_area 50000` | 中等约束，比自然面积小 31% |
| **D4** | `set_max_area 40000` | 激进约束，比自然面积小 44% |

**假设**：
- D1 → DC 自由优化，时序最优，面积自然
- D2 → 轻微约束，DC 稍压缩，仍可满足时序
- D3 → 中等约束，DC 开始牺牲某些优化，面积/时序开始 trade-off
- D4 → 激进约束，时序可能开始违例（WNS > 0）或功耗上升

**观察指标**：WNS、TNS、Area、Leakage、Dynamic Power、编译时间

---

## 实验 E：set_wire_load_mode 连线负载模型

**目的**：评估连线负载模型对时序估计和综合结果的影响。

库文件默认 wire_load：`5K_hvratio_1_1`（库中最小）

| 组 | 模式 | 说明 |
|----|------|------|
| **E1** | 默认（库设定） | 库 default_wire_load = `5K_hvratio_1_1`，DC 自动选择 |
| **E2** | `top` | 设计顶层采用全局 wire_load，忽略模块级 |
| **E3** | `enclosed` | 连线归属由最小包含模块的 wire_load 决定 |
| **E4** | `segmented` | 强制按分段估算，禁止跨模块传播 |

**假设**：
- E1/E2 结果相同（Nangate 库 default 较小，top 模式用 default）
- E3 `enclosed` 可能对子模块用更大 wire_load（3K, 1K），导致时序更悲观
- E4 `segmented` 最悲观，连线分段估计，面积估计更准确但时序偏悲观

**背景**：在 45nm 及以下工艺，连线延迟占路径延迟比例显著（>30%），wire_load_mode 选择影响 DC 对连线延时的估算精度。

---

## 统一约束（所有组）

| 参数 | 值 |
|------|-----|
| PERIOD | 2.0 ns |
| CLOCK UNCERTAINTY | 0.15 ns |
| CLOCK TRANSITION | 0.1 ns |
| INPUT DELAY | 0.5 ns |
| OUTPUT DELAY | 0.5 ns |
| MAX FANOUT | 16 |
| compile_ultra | `-gate_clock -no_autoungroup -timing` |

---

## 脚本命名

| 实验 | 脚本 | 输出目录 |
|------|------|---------|
| D2 | `dc_compile_D2.tcl` | `03_output_D2` |
| D3 | `dc_compile_D3.tcl` | `03_output_D3` |
| D4 | `dc_compile_D4.tcl` | `03_output_D4` |
| E1 | `dc_compile_E1.tcl` | `03_output_E1` |
| E2 | `dc_compile_E2.tcl` | `03_output_E2` |
| E3 | `dc_compile_E3.tcl` | `03_output_E3` |
| E4 | `dc_compile_E4.tcl` | `03_output_E4` |

D1 数据直接复用 A 组（无面积约束基线）。

---

## 预期结论

- D4（激进面积约束）可能触发 WNS > 0，说明当前设计在 500MHz 下面积下限约 40K-50K µm²
- E3/E4 的时序应比 E1 更悲观（更大 wire_load → 更严时序约束）
- 找到面积-时序 Pareto 曲线，指导实际项目的面积预算制定
