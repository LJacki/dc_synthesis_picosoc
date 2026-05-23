# compile_ultra 选项影响评估报告

> 实验时间：2026-05-23
> 设计：picosoc（含 picorv32 core）
> 频率：500MHz（PERIOD=2.0ns）
> 工艺库：NangateOpenCellLibrary_typical.db
> 工具：Design Compiler O-2018.06-SP5

---

## 1. 实验目的

评估 `compile_ultra` 不同选项组合对综合结果的影响，重点关注：
- `-gate_clock` 门控时钟效果
- `-autoungroup` / `-no_autoungroup` 模块解组策略

---

## 2. 实验分组

| 组别 | 选项 | 说明 |
|------|------|------|
| **A** | `-gate_clock -no_autoungroup -timing` | 当前基线 |
| **B** | `-gate_clock` (默认 autoungroup) | 测试默认解组效果 |
| **C** | `-no_autoungroup -timing` (无 gate_clock) | 测试关闭门控的影响 |

---

## 3. 约束条件（统一）

| 参数 | 值 |
|------|-----|
| PERIOD | 2.0 ns |
| CLOCK UNCERTAINTY | 0.15 ns |
| CLOCK TRANSITION | 0.1 ns |
| INPUT DELAY | 0.5 ns |
| OUTPUT DELAY | 0.5 ns |
| MAX FANOUT | 16 |

---

## 4. 核心数据

### 4.1 时序 & 面积

| 指标 | A 基线 | B autoungroup | C 无门控 | 对比说明 |
|------|--------|--------------|---------|---------|
| **WNS** | 0.00 ns ✅ | 0.00 ns ✅ | 0.00 ns ✅ | 三组均满足时序 |
| **TNS** | 0.00 | 0.00 | 0.00 | 无违规路径 |
| **Levels of Logic** | 39 | 38 | 37 | 差异微小 |
| **Cell Area** | 71,985 µm² | 72,029 µm² (+0.06%) | 86,263 µm² (+19.8%) | C 面积显著更大 |
| **Leaf Cell Count** | 28,886 | 28,595 | 47,261 (+63.6%) | C 寄存器数量暴涨 |
| **Hierarchical Cell Count** | 1,112 | 7 | 1,112 | B 被完全解组 |

### 4.2 功耗

| 指标 | A 基线 | B autoungroup | C 无门控 |
|------|--------|--------------|---------|
| **动态功耗** | 7.91 mW | 7.69 mW | **44.84 mW** (+467%) |
| **漏功耗** | 1.30 mW | 1.30 mW | 1.53 mW (+17%) |
| **开关功耗** | 0.616 mW | 0.517 mW | 0.186 mW |

### 4.3 Hold 时序

| 指标 | A 基线 | B autoungroup | C 无门控 |
|------|--------|--------------|---------|
| **Hold WNS** | 0.06 ns | 0.06 ns | 0.05 ns |
| **Hold TNS** | 14.32 | 18.48 | 25.45 |
| **Hold Violations** | 755 | 808 | **1,493** (+98%) |

### 4.4 编译性能

| 指标 | A 基线 | B autoungroup | C 无门控 |
|------|--------|--------------|---------|
| **编译时间** | 130 s | 176 s (+35%) | 193 s (+48%) |

---

## 5. 关键发现

### 5.1 gate_clock 是功耗优化关键

关闭门控时钟导致动态功耗暴涨 **5.7 倍**（7.91 → 44.84 mW）。

**原因分析**：
- 无 `-gate_clock` 时，所有寄存器在每个时钟周期翻转
- 即使寄存器值未变化，也会产生不必要的时钟树开关功耗
- picorv32 包含大量寄存器（12,843 个 sequential cells）
- clock tree 功耗占动态功耗的绝大部分

### 5.2 autoungroup 无实质收益

| 对比项 | B vs A | 结论 |
|--------|--------|------|
| 面积 | +0.06% | 几乎无差异 |
| LoL | 38 vs 39 | 差异 1 级 |
| 编译时间 | +35% | 反而更慢 |
| 模块层次 | 7 vs 1112 | **完全被解组** |

**结论**：`autoungroup` 在这个设计规模下无收益，但会破坏模块层次，影响后续 DFT/APR/STA 的 debug。

### 5.3 无门控的连锁副作用

C 组除了功耗问题外，还伴随：
- Leaf cells 增加 63%（28,886 → 47,261）
- Hold violations 增加 98%（755 → 1,493）
- 漏功耗增加 17%（1.30 → 1.53 mW）
- 整体健壮性显著下降

---

## 6. 结论与建议

### 推荐配置：`compile_ultra -gate_clock -no_autoungroup -timing`

| 维度 | 评估 |
|------|------|
| 时序 | ✅ WNS=0，无违规 |
| 功耗 | ✅ 动态功耗最低（7.91 mW） |
| 面积 | ✅ 与最优解组方案相当 |
| 模块层次 | ✅ 保留完整层次（1112 模块） |
| 编译时间 | ✅ 最快（130 s） |

### 不推荐配置

| 配置 | 问题 |
|------|------|
| `compile_ultra` (默认) | 等同于 B，含隐式 autoungroup |
| `compile_ultra -no_gate_clock` | 功耗爆炸，面积增大，Hold 变差 |

---

## 7. 实验环境

```
工具:       dc_shell (Design Compiler O-2018.06-SP5)
RTL:        picosoc.v, picorv32.v, simpleuart.v, spiflash.v, spimemio.v
工艺库:     NangateOpenCellLibrary_typical.db
实验日期:   2026-05-23
脚本目录:   /tmp/dc_compile_{A,B,C}.tcl
输出目录:   03_output_compile_{A,B,C}
结果文件:   docs/compile_charts.html
```

---

## 8. Commits

| Commit | 内容 |
|--------|------|
| `7df64b8` | docs: add compile_ultra options evaluation plan (3 groups) |
| `a9d217f` | feat: add compile_ultra options evaluation HTML results |
