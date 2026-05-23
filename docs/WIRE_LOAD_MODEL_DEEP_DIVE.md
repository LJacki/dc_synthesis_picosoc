# 线负载模型（WLM）深度解析

> 日期：2026-05-23
> 工具：DC O-2018.06-SP5
> 工艺：Nangate45nm（用于实验），28nm/22nm/10nm+（用于理论分析）

---

## 1. 什么是线负载模型（Wire Load Model）

综合阶段 DC 不知道芯片的实际物理布局（连线长度、Metal 层、RC 寄生参数），无法计算真实连线延迟。WLM 是用**统计模型**根据**扇出（fanout）**来估算连线延迟：

```
wire_delay = f(fanout_count, wire_load_model)
```

### 库文件中的 WLM 示例（Nangate45nm）

```tcl
wire_load("5K_hvratio_1_1") {
  resistance  : 0.008;    # ohm per square
  capacitance : 0.2;      # pf per square
  area        : 0.07;     # scaling factor
  slope       : 0.5;      # fanout-to-length 曲线斜率

  # fanout → 估算线长（µm）
  fanout_length(1, 2.6);
  fanout_length(2, 2.9);
  fanout_length(3, 3.2);
  fanout_length(4, 3.6);
  fanout_length(5, 4.1);
  ...
}
```

**核心思想**：设计越大（以 fanout 计），需要的连线越长，电阻和电容越大，延迟越高。

---

## 2. 三种 wire_load_mode 详解

### 2.1 `top` — 顶层统一估算

**规则**：整条连线无论穿越多少模块，都用**顶层**的 wire_load 估算。

```
[Module A]  ────  [Module B]  ────  [Module C]
     └── 整条线用 top module 的 WLM ──┘
```

| 特性 | 说明 |
|------|------|
| 悲观程度 | **最悲观** |
| 适用场景 | 扁平化设计；子模块会被 floorplan 打散的场景 |
| 优点 | 简单保守 |
| 缺点 | 层次化设计下严重高估短线延迟，误导 DC 优化方向 |

### 2.2 `enclosed` — 最小包含模块估算 ✅ 推荐

**规则**：对于一条连线，找出**完全包含它的最小模块**，使用该模块的 wire_load 估算整条线的延迟。

> "enclosed uses the lowest-level WLM that completely encloses the net"

**核心逻辑**：
```
     [Top Module]  ← top WLM (e.g., 5K_hvratio)
         │
    ┌────┴────┐
    │ Module A │  ← enclosed WLM (e.g., 3K_hvratio)
    │  ┌────┐ │
    │  │net │ │  ← 用 Module A 的 WLM，而不是 top
    │  └────┘ │
    └──────────┘
```

| 特性 | 说明 |
|------|------|
| 悲观程度 | 中等（比 top 乐观，比 segmented 悲观） |
| 适用场景 | **层次化设计**，子模块有明确物理分区 |
| 优点 | 符合层次化 floorplan 实际情况；E3 实验验证编译最快 |
| 限制 | 需要库文件正确定义各模块 WLM 属性 |

### 2.3 `segmented` — 分段估算

**规则**：将跨模块连线**按模块边界分段**，每段分别用对应模块的 WLM 估算，然后求和。

```
A内部段  ──  B内部段  ──  C内部段
用A的WLM   用B的WLM   用C的WLM
     ↓ 相加 = 整条线延迟
```

| 特性 | 说明 |
|------|------|
| 悲观程度 | **最乐观**（分段后每段变短，延迟相加 < 整条线用 top 估算） |
| 适用场景 | 理论精度研究；层次非常规范的设计 |
| 缺点 | 过度乐观，综合 clean → PR 违例风险高 |
| 注意 | 计算复杂度高，业界基本不用 |

---

## 3. 28nm / 22nm 工艺选型

### 28nm（成熟工艺）

```
关键变化：连线延迟开始占关键路径的 30-40%，不再是组合逻辑的天下
```

| 因素 | 建议 |
|------|------|
| 推荐模式 | `enclosed`（层次化）或 `top`（扁平） |
| WLM 精度 | Foundry 提供多档位 fanout 模型，精度尚可 |
| PR 反馈 | 综合→PR 后 timing 变化约 15-25%，需 PR 后校准 WLM |
| 关键动作 | 对比综合 vs PR 阶段的 timing delta，差异大则调整 WLM |

### 22nm（先进节点）

```
关键变化：互连效应显著增强，工艺波动加剧
```

| 因素 | 建议 |
|------|------|
| 推荐模式 | `enclosed`，为关键模块单独设定 wire_load |
| WLM 限制 | 统计模型精度下降，误差达 20-30% |
| 多 corner | 需在 typical / fast / slow corner 下分别评估 |
| 工程习惯 | 开始普遍使用 **DCT** 模式，WLM 仅作初始估算 |

---

## 4. 10nm 以下（FinFET / 先进节点）

### 传统 WLM 基本失效

```
原因：
1. 互连延迟 >> 单元延迟，连线成为主要瓶颈
2. 3D 效应、邻近效应、边缘粗糙度导致 RC 提取不遵循统计模型
3. 多层金属、local interconnect、self-heating 等新效应无法建模
4. 工艺波动（Vth variation）在 FinFET 上更显著
```

### 实际工程做法

#### 方案 A：DCT（DC Topographical）✅ 业界主流

不再依赖 WLM 估算，用**虚拟布局（virtual placement）**算法直接估算连线延迟：

```tcl
compile_ultra -spg    # Smart Physical Guidance
```

DC 内部调用早期布局算法（类似 Pluto/Timber），估算精度提升到与 PR 阶段相当（误差 < 5%）。**16nm/14nm/10nm/7nm 节点的标准做法。**

#### 方案 B：层次化综合 + PR 校准

```
1. 对每个子模块单独做综合
2. PR 完成后，提取实际 RC 数据反馈给 DC
3. 校准各模块的 wire_load 参数
4. Top-level 组装时使用校准后的模型
```

#### 方案 C：PR 阶段 RC 反标

```
DC 综合（WLM 估算）
  → 初期 PR（不完美布局）
  → 提取实际 RC
  → 反标给 PrimeTime 做 sign-off STA
  → 根据 PR 结果微调 DC 约束
```

### 选型总结表

| 工艺节点 | WLM 角色 | 推荐做法 |
|----------|----------|---------|
| 28nm | 主要估算手段 | `enclosed` + 多 corner 验证 |
| 22nm | 估算 + 校准 | `enclosed` + PR 反馈校准 |
| 16/14nm | 辅助估算 | DCT `-spg` 为主，WLM 仅用于快速迭代 |
| 10nm 及以下 | 基本不用 | 全流程 DCT，PR 后精确 RC 提取 |

---

## 5. `-spg` 选项详解（Smart Physical Guidance）

### 什么是 `-spg`

`-spg` 是 DCT（DC Topographical）模式下的**Smart Physical Guidance**选项。它将物理布局信息引入综合阶段，让 DC 摆脱 WLM 的统计估算。

### 为什么普通 DC 不能用 `-spg`

```
普通 DC（DC-shell）：
  └─ 只有逻辑信息（RTL + 库单元）
      └─ 不知道芯片物理布局
          └─ 只能用 WLM 统计估算连线延迟
              └─ 误差大（尤其先进工艺）

DCT（DC Topographical）：
  └─ 虚拟布局引擎（virtual placement）
      └─ 读取工艺文件（.tf / .layermap）
      └─ 读取 floorplan 约束（如果提供了）
      └─ 估算实际连线长度和 RC 寄生参数
          └─ 精度接近 PR 阶段
```

**普通 DC 物理信息缺失**：
- 不知道金属层 RC 分布
- 不知道模块实际位置和形状
- 不知道布线资源密度
- 没有 floorplan 约束文件

DCT 有虚拟布局引擎，可以模拟物理布局，因此能提供精确的连线延迟估算。

### `-spg` 的核心能力

```tcl
# 普通 DC
compile_ultra              # WLM 统计估算，误差 20-30%

# DCT + spg
compile_ultra -spg         # 虚拟布局估算，误差 < 5%
```

| 能力 | 说明 |
|------|------|
| **连线延迟精确估算** | 根据虚拟布局的连线长度计算 RC，不用 WLM |
| **拥塞感知优化** | DCT 能估算局部拥塞程度，指导布局优化 |
| **时序-功耗协同优化** | 知道实际连线延迟后，更精准地做门控时钟优化 |
| **与 ICC/ICC2 衔接** | DCT 综合结果可直接导入 ICC/ICC2，timing correlation 高 |
| **多角落 MCMM** | 支持 Multi-Corner Multi-Mode 的综合-布局联合优化 |

### `-spg` 限制

| 限制 | 说明 |
|------|------|
| 需要工艺文件 | 需要 `.tf` 或 `.apr` 文件定义金属层 RC |
| 运行时长增加 | 虚拟布局计算耗时，编译时间比普通 DC 长 20-40% |
| 不是真实布局 | 虚拟布局≠真实布局，误差仍存在，但比 WLM 小得多 |
| 需要 license | DCT 需要额外 license（DC_Topographical） |

### 普通 DC 如何近似 `-spg` 的效果

如果无法使用 DCT，可以通过以下方式逼近 `-spg` 精度：

```tcl
# 1. 提供 wire_load 估计文件
set_wire_load_model -library NangateOpenCellLibrary -name 5K_hvratio_1_1

# 2. 手动设置连线长度估计（更精确地指导 DC）
set_max_length 50   # 限制最大连线长度（单位：microstrip）
set_max_capacitance 0.2  # 限制最大负载电容

# 3. 明确层次化约束（让 DC 尊重模块边界）
set_current_design $TOP
set_wire_load_mode enclosed
set_wire_load_model -library $LIB -name 5K_hvratio_1_1

# 4. 使用 critical chain 约束指导 DC 重点优化
set_max_delay 1.5 -from [get_cells <critical_path_cells>]
```

---

## 6. 工程实践建议

### 选型决策树

```
设计是否有明确层次结构？
  ├── 是 → enclosed（首选）
  └── 否 → top（保守）
  
工艺节点？
  ├── 28nm 以老 → enclosed + PR 反馈校准
  ├── 22nm~16nm → enclosed 或 DCT（推荐）
  └── 10nm 及以下 → 必须用 DCT -spg

能否用 DCT？
  ├── 能 → compile_ultra -spg（首选）
  └── 不能 → enclosed + 手动 wire_load 校准
```

### 综合 vs PR Timing Correlation 检查

```tcl
# 综合后
report_timing -max_paths 20 > timing_dc.rpt

# PR 完成后（ICC/ICC2）
report_timing -max_paths 20 > timing_pr.rpt

# 对比 top 10 critical paths 的 slack delta
# 如果 delta > 0.5ns 或 > 15%，说明 WLM 估算偏差大
# 需要：
#   1. 调整 set_wire_load_mode
#   2. 为关键模块单独设置 wire_load_model
#   3. 或切换到 DCT 流程
```
