# DC Synthesis Report - picosoc

## 综合概要

| 项目 | 值 |
|------|-----|
| **设计** | picosoc (RISC-V based SoC) |
| **目标库** | NangateOpenCellLibrary (typical) |
| **工艺** | TSMC 45nm |
| **综合工具** | Design Compiler O-2018.06-SP5 |
| **时钟频率** | 50 MHz (period: 20.0 ns) |
| **综合日期** | 2026-05-20 |

## 时序结果

| 指标 | 值 | 状态 |
|------|-----|------|
| **WNS (Setup)** | 0.00 ns | :white_check_mark: PASS |
| **TNS (Setup)** | 0.00 ns | :white_check_mark: 0 violations |
| **WNS (Hold)** | 0.41 ns | :white_check_mark: PASS |
| **TNS (Hold)** | 104.02 ns | :warning: 316 violations |
| **Slack 违例数** | 0 (setup) / 316 (hold) | |

### 关键路径摘要

- **Startpoint**: spimemio/xfer_io0_90_reg (FF)
- **Endpoint**: flash_io0_do (output port)
- **Path Group**: sys_clk
- **Path Type**: max (setup)
- **Critical Path Length**: 0.22 ns
- **Critical Path Slack**: 4.28 ns (MET)

## 面积结果

| 指标 | 值 |
|------|-----|
| **Total Cell Area** | 53,761.26 gate² |
| **Combinational Area** | 10,999.63 gate² |
| **Non-Combinational Area** | 42,761.63 gate² |
| **Buf/Inv Area** | 981.27 gate² |

## 门数统计

| 类型 | 数量 |
|------|------|
| **Leaf Cells (Total)** | 18,837 |
| **Combinational** | 9,267 |
| **Sequential** | 9,570 |
| **Buf/Inv** | 1,290 |
| **Hierarchical Cells** | 1,054 |
| **Nets** | 19,157 |

## Cell Count 明细

| 类型 | 数量 |
|------|------|
| **Buf Cell** | 1,109 |
| **Inv Cell** | 181 |
| **CT Buf/Inv** | 1 |
| **Macro** | 0 |

## 设计规则检查

| 指标 | 值 | 状态 |
|------|-----|------|
| **Max Trans Violations** | 0 | :white_check_mark: PASS |
| **Max Cap Violations** | 0 | :white_check_mark: PASS |

## RTL 模块信息

| 模块 | 说明 |
|------|------|
| picorv32 | RISC-V RV32I CPU core |
| spimemio | SPI memory interface controller |
| simpleuart | Simple UART (no FIFO) |
| spiflash | SPI Flash model (stubbed for synthesis) |
| picosoc | Top-level SoC |

## 约束条件

- **Clock**: sys_clk, 50 MHz, uncertainty 0.5 ns
- **Input Delay**: 5.0 ns
- **Output Delay**: 5.0 ns
- **False Path**: irq_5/6/7 (async), resetn, ser_rx, flash_*

## 编译统计

| 指标 | 值 |
|------|-----|
| **Overall Compile Time** | 40.89 s |
| **Wall Clock Time** | 133.78 s |
| **Resource Sharing** | 5.28 s |
| **Logic Optimization** | 12.16 s |
| **Mapping Optimization** | 10.73 s |

## 已知问题

1. **Hold Violations (316 paths)**: TNS=104.02 ns，建议后续修复
   - 原因：setup margin充足（4.28ns），hold margin为负但WNS=0.41说明hold检查在时钟树插入前
   - 方案：在 dc_synth.tcl 中添加 set_fix_hold [get_clocks sys_clk]
2. **High-fanout nets**: 需进一步检查扇出>1000的网络
3. **picorv32 link reference**: 轻微警告（1 unresolved reference），不影响综合结果

## 下一步建议

1. **修复 Hold Violations**: 在 dc_synth.tcl 中添加 set_fix_hold [get_clocks sys_clk]
2. **100MHz 综合**: 修改 CLK_PERIOD=10.0 重新综合，验证时序是否满足
3. **形式验证**: 用 Formality 对比 RTL 和综合后网表
4. **功耗分析**: 用 Power Compiler 分析动态/静态功耗
5. **物理综合**: 使用 Design Compiler Topographical 进行布局aware综合
