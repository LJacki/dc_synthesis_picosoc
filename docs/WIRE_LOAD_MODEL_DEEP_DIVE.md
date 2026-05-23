# 线负载模型（WLM）与 `-spg` 深度解析

> 日期：2026-05-23
> 工具：DC O-2018.06-SP5
> 工艺：Nangate45nm（实验），28nm/22nm/10nm+（理论）

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
| 优点 | 符合层次化 floorplan 实际情况；E3 实验验证编译最快（132.8s vs 167.6s） |
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

DC 内部调用早期布局算法，估算精度提升到与 PR 阶段相当（误差 < 5%）。**16nm/14nm/10nm/7nm 节点的标准做法。**

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

### 官方原文

```
-spg   This option is available only in Design Compiler topographical mode.
       Enables physical guidance, congestion optimization, and automatic layer
       optimization. Congestion optimization reduces routing-related congestion.
       Physical guidance enables Design Compiler Graphical to save coarse
       placement information and pass this coarse placement information to
       IC Compiler. With this coarse placement, IC Compiler can begin the
       implementation flow with the place_opt command.

       IC Compiler no longer needs to re-create the coarse placement by
       running commands such as create_placement, remove_buffer_tree, or
       psynopt. By using the Design Compiler coarse placement as a starting
       point for placement, runtime and area correlation with IC Compiler
       are improved.

       Design Compiler Graphical automatically performs layer-aware optimization
       when you use the -spg option, modeling parasitic variation across
       metal layers in a way that benefits optimization. This optimization
       helps remove excess pessimism, leading to better area and power.

       In addition to the default layer-aware optimization, you can also
       specify net constraints for layer optimization by setting specific
       constraints using the set_net_routing_layer_constraints command or by
       creating a net-search pattern.

       In the net-search pattern approach, you define a net-search pattern
       by using the create_net_search_pattern command and then define
       associated minimum and maximum routing layer constraints for the
       search pattern by using the set_net_search_pattern_delay_estimation_
       options command. Design Compiler invokes net-pattern identification
       after the high-fanout synthesis step in compile_ultra and assigns
       the minimum and maximum constraints to the matching nets. The
       subsequent optimizations consider the effects of the constraints
       (for example, the unit resistance and capacitance values of
       matching nets will change) during buffering and buffer removal.
       You can define as many net-search patterns and associated layer
       constraints as needed. In general, however, it is recommended to
       start with very long nets (for example, 500 um) with top routing
       layers (for example, M7 and M8). You should consider this approach
       when your design shows significant unit resistance variation
       (see RCEX-011 resistance values) across all available routing layers.

       Note that the user-constraints and net-pattern layer optimization
       methods might affect runtime.
```

### 官方原文翻译

```
-spg   此选项仅在 Design Compiler Topographical 模式下可用。
       启用物理引导（physical guidance）、拥塞优化（congestion optimization）
       和自动层级优化（automatic layer optimization）。

       拥塞优化可减少布线相关的拥塞问题。

       物理引导使 Design Compiler Graphical 能够保存粗粒度布局信息（coarse
       placement），并将这些布局信息传递给 IC Compiler。凭借这些粗粒度布局，
       IC Compiler 可以直接从 place_opt 命令开始实现流程。

       IC Compiler 不再需要通过执行 create_placement、remove_buffer_tree
       或 psynopt 等命令来重新创建粗粒度布局。通过使用 Design Compiler
       的粗粒度布局作为起点，IC Compiler 的运行时间和面积指标与 IC Compiler
       的相关性都会得到改善。

       当您使用 -spg 选项时，Design Compiler Graphical 会自动执行层级感知
       优化（layer-aware optimization），对金属层间的寄生参数变化进行建模，
       从而使优化受益。这种优化有助于消除过度的悲观估计，带来更好的面积
       和功耗结果。

       除了默认的层级感知优化之外，您还可以通过以下方式为层级优化指定
       网络约束：
         • 使用 set_net_routing_layer_constraints 命令设置特定约束
         • 创建网络搜索模式（net-search pattern）

       在网络搜索模式方法中：
         1. 使用 create_net_search_pattern 命令定义一个网络搜索模式
         2. 使用 set_net_search_pattern_delay_estimation_options 命令
            为该模式定义相应的最小和最大布线层级约束

       Design Compiler 在 compile_ultra 的高扇出综合步骤之后调用网络模式
       识别，并将这些约束分配给匹配的网络。后续的优化在缓冲插入和缓冲删除
       过程中会考虑这些约束的影响（例如，匹配网络的单位电阻和电容值会
       发生变化）。

       可以根据需要定义任意数量的网络搜索模式和相关的层级约束。但一般来说，
       建议从非常长的网络（例如 500 µm）和顶层布线层（例如 M7 和 M8）
       开始。当您的设计在所有可用布线层上表现出显著的单位电阻差异时
       （参见 RCEX-011 电阻值），应考虑此方法。

       注意：用户约束和网络模式层级优化方法可能会影响运行时间。
```

---

## 6. DCT 下 `-spg` vs 不加 `-spg` 的核心区别

### 为什么 `-spg` 只能在 DCT 用

```
普通 DC（dc_shell）：
  └─ 只有逻辑信息（RTL + 库单元）
      └─ 不知道芯片物理布局
          └─ 只能用 WLM 统计估算连线延迟
              └─ 误差 20-30%

DCT（dc_shell -topographical）：
  └─ 虚拟布局引擎（virtual placement）
      └─ 读取工艺文件（.tf / .layermap）
      └─ 读取 .cel/.FRAM 物理库
      └─ 估算实际连线长度和 RC 寄生参数
          └─ 精度接近 PR 阶段
```

DCT 不加 `-spg` 和加 `-spg` 的差异：

| 特性 | DCT 不加 `-spg` | DCT 加 `-spg` |
|------|-----------------|--------------|
| 物理库需求 | ✅ 需要 | ✅ 需要 |
| 虚拟布局估算 | ✅ 有 | ✅ 有 |
| 连线延迟精度 | 误差 5-15% | 误差 < 5% |
| 拥塞优化 | ❌ 无 | ✅ 有 |
| **层感知优化** | ❌ 无（所有层 RC 假设相同） | ✅ **有**（各金属层 RC 差异建模） |
| 传递粗粒度布局给 ICC | ❌ 无 | ✅ 有（DC→ICC 零成本衔接） |
| 与 ICC timing correlation | 85-90% | 95%+ |
| 编译时间 | 1.2× | 1.3~1.4× |

### 关键差异：layer-aware optimization

**不加 `-spg`**：虚拟布局会估算连线长度，但假设**所有金属层的单位电阻/电容相同**。这导致对高层金属（低阻）的连线**过度悲观**——DC 以为长连线电阻大，插入过多 buffer。

**加 `-spg`**：DC 知道每层金属的实际 RC 分布（短连线用低层 M1-M3，长连线用高层 M7-M8），在优化时对高层金属的连线更乐观，减少不必要的 buffer 插入。

```
例如：一条 800 µm 的 net
  无 -spg：假设所有层 RC 一样 → DC 悲观地插入多个 buffer
  有 -spg：DC 知道它会走 M7/M8（高层金属，电阻小）
           → 少插 buffer，面积更小，功耗更低
```

这在 **10nm 以下 FinFET 工艺**中尤为关键——层间电阻差异可达 10×。

---

## 7. compile_ultra 完整选项速查

| 选项 | 作用 | 可用模式 |
|------|------|---------|
| `-spg` | 物理引导 + 拥塞优化 + **层感知优化** | **仅 DCT** |
| `-self_gating` | XOR 自门控插入（动态功耗优化） | **仅 DCT** |
| `-check_only` | 检查设计/库是否满足 DCT 要求 | **仅 DCT** |
| `-congestion` | 拥塞优化（已废弃，用 `-spg` 代替） | **仅 DCT** |
| `-gate_clock` | 启用时钟门控优化（插入/删除 ICG） | 普通/DC |
| `-no_autoungroup` | 禁用自动解组，保留所有层级 | 普通/DC |
| `-no_boundary_optimization` | 禁止跨层级边界优化 | 普通/DC |
| `-no_seq_output_inversion` | 禁止顺序元件输出反相 | 普通/DC |
| `-retime` | 启用自适应 retiming 算法 | 普通/DC |
| `-scan` | 将顺序元件替换为扫描等价单元 | 普通/DC |
| `-exact_map` | 顺序元件严格按 HDL 描述映射 | 普通/DC |
| `-incremental` | 增量模式，不重新映射 | 普通/DC |
| `-top` | 只修顶层时序和 DRC | 普通/DC |
| `-only_design_rule` | 仅修复 DRC，不做优化 | 普通/DC |
| `-no_design_rule` | 不修复 DRC，仅优化映射 | 普通/DC |
| `-timing_high_effort_script` | 战略时序优化（已废弃，仅兼容旧脚本） | 普通/DC |
| `-area_high_effort_script` | 战略面积优化（已废弃，仅兼容旧脚本） | 普通/DC |

---

## 8. 工程实践建议

### 选型决策树

```
设计是否有明确层次结构？
  ├── 是 → enclosed（首选）
  └── 否 → top（保守）
  
工艺节点？
  ├── 28nm 以老 → enclosed + PR 反馈校准
  ├── 22nm~16nm → enclosed 或 DCT（推荐）
  └── 10nm 及以下 → 必须用 DCT -spg

能否用 DCT + -spg？
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
#   3. 或切换到 DCT -spg 流程
```

### 普通 DC 如何近似 `-spg` 的效果

如果无法使用 DCT，可以通过以下方式逼近 `-spg` 精度：

```tcl
# 1. 提供 wire_load 估计文件
set_wire_load_model -library NangateOpenCellLibrary -name 5K_hvratio_1_1

# 2. 手动设置连线长度约束
set_max_length 50   # 限制最大连线长度（单位：microstrip）
set_max_capacitance 0.2  # 限制最大负载电容

# 3. 明确层次化约束（让 DC 尊重模块边界）
set_current_design $TOP
set_wire_load_mode enclosed
set_wire_load_model -library $LIB -name 5K_hvratio_1_1

# 4. 使用 critical chain 约束指导 DC 重点优化
set_max_delay 1.5 -from [get_cells <critical_path_cells>]
```
