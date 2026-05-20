/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06-SP5
// Date      : Wed May 20 22:23:24 2026
/////////////////////////////////////////////////////////////


module picosoc ( clk, resetn, iomem_valid, iomem_ready, iomem_wstrb, 
        iomem_addr, iomem_wdata, iomem_rdata, irq_5, irq_6, irq_7, ser_tx, 
        ser_rx, flash_csb, flash_clk, flash_io0_oe, flash_io1_oe, flash_io2_oe, 
        flash_io3_oe, flash_io0_do, flash_io1_do, flash_io2_do, flash_io3_do, 
        flash_io0_di, flash_io1_di, flash_io2_di, flash_io3_di );
  output [3:0] iomem_wstrb;
  output [31:0] iomem_addr;
  output [31:0] iomem_wdata;
  input [31:0] iomem_rdata;
  input clk, resetn, iomem_ready, irq_5, irq_6, irq_7, ser_rx, flash_io0_di,
         flash_io1_di, flash_io2_di, flash_io3_di;
  output iomem_valid, ser_tx, flash_csb, flash_clk, flash_io0_oe, flash_io1_oe,
         flash_io2_oe, flash_io3_oe, flash_io0_do, flash_io1_do, flash_io2_do,
         flash_io3_do;
  wire   N8, spimem_ready, ram_ready, simpleuart_reg_dat_wait, _0_net_,
         \_1_net_[3] , \_1_net_[2] , \_1_net_[1] , \_1_net_[0] , \_2_net_[3] ,
         \_2_net_[2] , \_2_net_[1] , \_2_net_[0] , \_3_net_[0] , _4_net_, N33,
         \_5_net_[3] , \_5_net_[2] , \_5_net_[1] , \_5_net_[0] , N139, N141,
         n40, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54,
         n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68,
         n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82,
         n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96,
         n97, n98, n99, n100, n101, n102, n103, n104, n105, n106, n107, n108,
         n109, n110, n111, n112, n113, n114, n115, n116, n117, n118, n119,
         n120, n121, n122, n123, n124, n125, n126, n127, n128, n129, n130,
         n131, n132, n133, n134, n135, n136, n137, n138, n139, n140, n141,
         n142, n143, n144, n145, n146, n147, n148, n149, n150, n151, n152,
         n153, n154, n155, n156, n157, n158, n159, n160, n161, n162, n163,
         n164, n165, n166, n167, n168, n169, n170, n171, n172, n173, n174,
         n175, n176, n177, n179, n180, n181, n182, n183, n184, n185, n186,
         n187, n188, n189, n190, n191, n192, n193, n194, n195, n196, n197,
         n199, n200, n201, n202, n203, n204, n205, n206, n207, n208, n209,
         n210, n211, n212, n213, n214, n215, n216, n217, n218, n219, n220,
         n221, n222, n223, n224, n225, n226, n227, n228, n229, n230, n231,
         n232, n233, n234, n235;
  wire   [31:0] spimem_rdata;
  wire   [31:0] ram_rdata;
  wire   [31:0] spimemio_cfgreg_do;
  wire   [31:0] simpleuart_reg_div_do;
  wire   [31:0] simpleuart_reg_dat_do;
  tri   clk;
  tri   resetn;
  tri   [3:0] iomem_wstrb;
  tri   [31:0] iomem_addr;
  tri   [31:0] iomem_wdata;
  tri   irq_5;
  tri   irq_6;
  tri   irq_7;
  tri   mem_valid;
  tri   mem_ready;
  tri   [31:0] mem_rdata;
  tri   n198;
  wire   SYNOPSYS_UNCONNECTED__0, SYNOPSYS_UNCONNECTED__1, 
        SYNOPSYS_UNCONNECTED__2, SYNOPSYS_UNCONNECTED__3, 
        SYNOPSYS_UNCONNECTED__4, SYNOPSYS_UNCONNECTED__5, 
        SYNOPSYS_UNCONNECTED__6, SYNOPSYS_UNCONNECTED__7, 
        SYNOPSYS_UNCONNECTED__8, SYNOPSYS_UNCONNECTED__9, 
        SYNOPSYS_UNCONNECTED__10, SYNOPSYS_UNCONNECTED__11, 
        SYNOPSYS_UNCONNECTED__12, SYNOPSYS_UNCONNECTED__13;

  DFF_X1 ram_ready_reg ( .D(N33), .CK(clk), .Q(ram_ready), .QN(n40) );
  NAND3_X1 U225 ( .A1(n85), .A2(n84), .A3(n86), .ZN(n88) );
  NAND3_X1 U226 ( .A1(n100), .A2(n101), .A3(iomem_addr[3]), .ZN(n83) );
  NAND3_X1 U227 ( .A1(n101), .A2(n102), .A3(n100), .ZN(n80) );
  NAND3_X1 U228 ( .A1(n100), .A2(n102), .A3(iomem_addr[2]), .ZN(n81) );
  picorv32 cpu ( .clk(clk), .resetn(resetn), .mem_valid(mem_valid), 
        .mem_ready(mem_ready), .mem_addr(iomem_addr), .mem_wdata(iomem_wdata), 
        .mem_wstrb(iomem_wstrb), .mem_rdata(mem_rdata), .irq({1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, irq_7, irq_6, 
        irq_5, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}) );
  spimemio spimemio ( .clk(clk), .resetn(resetn), .valid(_0_net_), .ready(
        spimem_ready), .addr(iomem_addr[23:0]), .rdata(spimem_rdata), 
        .flash_csb(flash_csb), .flash_clk(flash_clk), .flash_io0_oe(
        flash_io0_oe), .flash_io1_oe(flash_io1_oe), .flash_io2_oe(flash_io2_oe), .flash_io3_oe(flash_io3_oe), .flash_io0_do(flash_io0_do), .flash_io1_do(
        flash_io1_do), .flash_io2_do(flash_io2_do), .flash_io3_do(flash_io3_do), .flash_io0_di(flash_io0_di), .flash_io1_di(flash_io1_di), .flash_io2_di(
        flash_io2_di), .flash_io3_di(flash_io3_di), .cfgreg_we({\_1_net_[3] , 
        \_1_net_[2] , \_1_net_[1] , \_1_net_[0] }), .cfgreg_di(iomem_wdata), 
        .cfgreg_do({spimemio_cfgreg_do[31], SYNOPSYS_UNCONNECTED__0, 
        SYNOPSYS_UNCONNECTED__1, SYNOPSYS_UNCONNECTED__2, 
        SYNOPSYS_UNCONNECTED__3, SYNOPSYS_UNCONNECTED__4, 
        SYNOPSYS_UNCONNECTED__5, SYNOPSYS_UNCONNECTED__6, 
        SYNOPSYS_UNCONNECTED__7, spimemio_cfgreg_do[22:16], 
        SYNOPSYS_UNCONNECTED__8, SYNOPSYS_UNCONNECTED__9, 
        SYNOPSYS_UNCONNECTED__10, SYNOPSYS_UNCONNECTED__11, 
        spimemio_cfgreg_do[11:8], SYNOPSYS_UNCONNECTED__12, 
        SYNOPSYS_UNCONNECTED__13, spimemio_cfgreg_do[5:0]}) );
  simpleuart simpleuart ( .clk(clk), .resetn(resetn), .ser_tx(ser_tx), 
        .ser_rx(ser_rx), .reg_div_we({\_2_net_[3] , \_2_net_[2] , \_2_net_[1] , 
        \_2_net_[0] }), .reg_div_di(iomem_wdata), .reg_div_do(
        simpleuart_reg_div_do), .reg_dat_we(\_3_net_[0] ), .reg_dat_re(_4_net_), .reg_dat_di(iomem_wdata), .reg_dat_do(simpleuart_reg_dat_do), .reg_dat_wait(
        simpleuart_reg_dat_wait) );
  picosoc_mem memory ( .clk(clk), .wen({\_5_net_[3] , \_5_net_[2] , 
        \_5_net_[1] , \_5_net_[0] }), .addr(iomem_addr[23:2]), .wdata(
        iomem_wdata), .rdata(ram_rdata) );
  OAI211_X1 U156 ( .C1(n184), .C2(1'b1), .A(n116), .B(n115), .ZN(mem_rdata[30]) );
  OAI211_X1 U158 ( .C1(n184), .C2(1'b1), .A(n120), .B(n119), .ZN(mem_rdata[28]) );
  OAI211_X1 U160 ( .C1(n184), .C2(1'b1), .A(n124), .B(n123), .ZN(mem_rdata[26]) );
  OAI211_X1 U162 ( .C1(n184), .C2(1'b1), .A(n128), .B(n127), .ZN(mem_rdata[24]) );
  OAI211_X1 U172 ( .C1(n183), .C2(1'b1), .A(n148), .B(n147), .ZN(mem_rdata[14]) );
  OAI211_X1 U174 ( .C1(n183), .C2(1'b1), .A(n152), .B(n151), .ZN(mem_rdata[12]) );
  OAI211_X1 U180 ( .C1(n182), .C2(1'b1), .A(n164), .B(n163), .ZN(mem_rdata[6])
         );
  OAI211_X1 U157 ( .C1(n184), .C2(1'b1), .A(n118), .B(n117), .ZN(mem_rdata[29]) );
  OAI211_X1 U159 ( .C1(n184), .C2(1'b1), .A(n122), .B(n121), .ZN(mem_rdata[27]) );
  OAI211_X1 U161 ( .C1(n184), .C2(1'b1), .A(n126), .B(n125), .ZN(mem_rdata[25]) );
  OAI211_X1 U163 ( .C1(n183), .C2(1'b1), .A(n130), .B(n129), .ZN(mem_rdata[23]) );
  OAI211_X1 U171 ( .C1(n183), .C2(1'b1), .A(n146), .B(n145), .ZN(mem_rdata[15]) );
  OAI211_X1 U173 ( .C1(n183), .C2(1'b1), .A(n150), .B(n149), .ZN(mem_rdata[13]) );
  OAI211_X1 U179 ( .C1(n182), .C2(1'b1), .A(n162), .B(n161), .ZN(mem_rdata[7])
         );
  OAI211_X1 U155 ( .C1(n184), .C2(1'b1), .A(n114), .B(n113), .ZN(mem_rdata[31]) );
  OAI211_X1 U164 ( .C1(n183), .C2(1'b1), .A(n132), .B(n131), .ZN(mem_rdata[22]) );
  OAI211_X1 U165 ( .C1(n183), .C2(1'b1), .A(n134), .B(n133), .ZN(mem_rdata[21]) );
  OAI211_X1 U166 ( .C1(n183), .C2(1'b1), .A(n136), .B(n135), .ZN(mem_rdata[20]) );
  OAI211_X1 U167 ( .C1(n183), .C2(1'b1), .A(n138), .B(n137), .ZN(mem_rdata[19]) );
  OAI211_X1 U168 ( .C1(n183), .C2(1'b1), .A(n140), .B(n139), .ZN(mem_rdata[18]) );
  OAI211_X1 U169 ( .C1(n183), .C2(1'b1), .A(n142), .B(n141), .ZN(mem_rdata[17]) );
  OAI211_X1 U170 ( .C1(n183), .C2(1'b1), .A(n144), .B(n143), .ZN(mem_rdata[16]) );
  OAI211_X1 U175 ( .C1(n182), .C2(1'b1), .A(n154), .B(n153), .ZN(mem_rdata[11]) );
  OAI211_X1 U176 ( .C1(n182), .C2(1'b1), .A(n156), .B(n155), .ZN(mem_rdata[10]) );
  OAI211_X1 U177 ( .C1(n182), .C2(1'b1), .A(n158), .B(n157), .ZN(mem_rdata[9])
         );
  OAI211_X1 U178 ( .C1(n182), .C2(1'b1), .A(n160), .B(n159), .ZN(mem_rdata[8])
         );
  OAI211_X1 U181 ( .C1(n182), .C2(1'b1), .A(n166), .B(n165), .ZN(mem_rdata[5])
         );
  OAI211_X1 U182 ( .C1(n182), .C2(1'b1), .A(n168), .B(n167), .ZN(mem_rdata[4])
         );
  OAI211_X1 U183 ( .C1(n182), .C2(1'b1), .A(n170), .B(n169), .ZN(mem_rdata[3])
         );
  OAI211_X1 U184 ( .C1(n182), .C2(1'b1), .A(n172), .B(n171), .ZN(mem_rdata[2])
         );
  OAI211_X1 U185 ( .C1(n182), .C2(1'b1), .A(n174), .B(n173), .ZN(mem_rdata[1])
         );
  OAI211_X1 U186 ( .C1(n182), .C2(1'b1), .A(n176), .B(n175), .ZN(mem_rdata[0])
         );
  OR2_X1 C228 ( .A1(N139), .A2(N141), .ZN(mem_ready) );
  BUF_X1 U229 ( .A(n235), .Z(n181) );
  BUF_X1 U230 ( .A(n46), .Z(n188) );
  BUF_X1 U231 ( .A(n46), .Z(n189) );
  BUF_X1 U232 ( .A(n45), .Z(n191) );
  BUF_X1 U233 ( .A(n45), .Z(n192) );
  BUF_X1 U234 ( .A(n235), .Z(n180) );
  BUF_X1 U235 ( .A(n235), .Z(n179) );
  BUF_X1 U236 ( .A(n46), .Z(n190) );
  BUF_X1 U237 ( .A(n45), .Z(n193) );
  BUF_X1 U238 ( .A(n177), .Z(n182) );
  BUF_X1 U239 ( .A(n177), .Z(n183) );
  BUF_X1 U240 ( .A(n177), .Z(n184) );
  INV_X1 U241 ( .A(n82), .ZN(n199) );
  NOR2_X1 U242 ( .A1(n234), .A2(n86), .ZN(\_5_net_[1] ) );
  NOR2_X1 U243 ( .A1(n234), .A2(n87), .ZN(\_5_net_[0] ) );
  NOR2_X1 U244 ( .A1(n234), .A2(n85), .ZN(\_5_net_[2] ) );
  NOR2_X1 U245 ( .A1(n234), .A2(n84), .ZN(\_5_net_[3] ) );
  NOR2_X1 U246 ( .A1(n181), .A2(spimem_ready), .ZN(n82) );
  INV_X1 U247 ( .A(N33), .ZN(n234) );
  INV_X1 U248 ( .A(n79), .ZN(n235) );
  NOR2_X1 U249 ( .A1(n80), .A2(n84), .ZN(\_1_net_[3] ) );
  NOR2_X1 U250 ( .A1(n83), .A2(N139), .ZN(n46) );
  BUF_X1 U251 ( .A(n43), .Z(n194) );
  BUF_X1 U252 ( .A(n43), .Z(n195) );
  BUF_X1 U253 ( .A(n47), .Z(n185) );
  BUF_X1 U254 ( .A(n47), .Z(n186) );
  NOR2_X1 U255 ( .A1(n80), .A2(n86), .ZN(\_1_net_[1] ) );
  NOR2_X1 U256 ( .A1(n80), .A2(n87), .ZN(\_1_net_[0] ) );
  NOR2_X1 U257 ( .A1(n83), .A2(n87), .ZN(\_3_net_[0] ) );
  BUF_X1 U258 ( .A(n43), .Z(n196) );
  BUF_X1 U259 ( .A(n47), .Z(n187) );
  NAND2_X1 U260 ( .A1(n83), .A2(n200), .ZN(n177) );
  INV_X1 U261 ( .A(N139), .ZN(n200) );
  NOR2_X1 U262 ( .A1(n80), .A2(n85), .ZN(\_1_net_[2] ) );
  AND2_X1 U263 ( .A1(spimem_ready), .A2(n79), .ZN(n45) );
  NOR2_X1 U264 ( .A1(n81), .A2(n86), .ZN(\_2_net_[1] ) );
  NOR2_X1 U265 ( .A1(n81), .A2(n84), .ZN(\_2_net_[3] ) );
  NOR2_X1 U266 ( .A1(n81), .A2(n85), .ZN(\_2_net_[2] ) );
  NOR2_X1 U267 ( .A1(n81), .A2(n87), .ZN(\_2_net_[0] ) );
  NOR3_X1 U268 ( .A1(mem_ready), .A2(n91), .A3(n90), .ZN(N33) );
  NAND4_X1 U269 ( .A1(n82), .A2(n81), .A3(n80), .A4(n40), .ZN(N139) );
  NAND2_X1 U270 ( .A1(iomem_ready), .A2(iomem_valid), .ZN(n79) );
  NOR2_X1 U271 ( .A1(simpleuart_reg_dat_wait), .A2(n83), .ZN(N141) );
  NOR3_X1 U272 ( .A1(n88), .A2(iomem_wstrb[0]), .A3(n83), .ZN(_4_net_) );
  NOR3_X1 U273 ( .A1(n199), .A2(ram_ready), .A3(n81), .ZN(n47) );
  NOR4_X1 U274 ( .A1(n96), .A2(iomem_addr[26]), .A3(iomem_addr[28]), .A4(
        iomem_addr[27]), .ZN(n95) );
  OR3_X1 U275 ( .A1(iomem_addr[30]), .A2(iomem_addr[31]), .A3(iomem_addr[29]), 
        .ZN(n96) );
  NOR4_X1 U276 ( .A1(n107), .A2(iomem_addr[24]), .A3(iomem_addr[5]), .A4(
        iomem_addr[4]), .ZN(n106) );
  OR4_X1 U277 ( .A1(iomem_addr[7]), .A2(iomem_addr[6]), .A3(iomem_addr[9]), 
        .A4(iomem_addr[8]), .ZN(n107) );
  NOR3_X1 U278 ( .A1(n89), .A2(iomem_addr[25]), .A3(n233), .ZN(_0_net_) );
  INV_X1 U279 ( .A(n90), .ZN(n233) );
  NOR2_X1 U280 ( .A1(n40), .A2(n199), .ZN(n43) );
  AOI22_X1 U281 ( .A1(spimem_rdata[24]), .A2(n193), .B1(iomem_rdata[24]), .B2(
        n179), .ZN(n54) );
  AOI22_X1 U282 ( .A1(spimem_rdata[25]), .A2(n193), .B1(iomem_rdata[25]), .B2(
        n179), .ZN(n53) );
  AOI22_X1 U283 ( .A1(spimem_rdata[26]), .A2(n193), .B1(iomem_rdata[26]), .B2(
        n179), .ZN(n52) );
  AOI22_X1 U284 ( .A1(spimem_rdata[27]), .A2(n193), .B1(iomem_rdata[27]), .B2(
        n179), .ZN(n51) );
  AOI22_X1 U285 ( .A1(spimem_rdata[28]), .A2(n193), .B1(iomem_rdata[28]), .B2(
        n179), .ZN(n50) );
  AOI22_X1 U286 ( .A1(spimem_rdata[29]), .A2(n193), .B1(iomem_rdata[29]), .B2(
        n179), .ZN(n49) );
  AOI22_X1 U287 ( .A1(spimem_rdata[30]), .A2(n193), .B1(iomem_rdata[30]), .B2(
        n179), .ZN(n48) );
  AOI22_X1 U288 ( .A1(spimem_rdata[31]), .A2(n193), .B1(iomem_rdata[31]), .B2(
        n179), .ZN(n44) );
  AOI22_X1 U289 ( .A1(spimem_rdata[6]), .A2(n191), .B1(iomem_rdata[6]), .B2(
        n181), .ZN(n72) );
  AOI22_X1 U290 ( .A1(spimem_rdata[7]), .A2(n191), .B1(iomem_rdata[7]), .B2(
        n181), .ZN(n71) );
  AOI22_X1 U291 ( .A1(spimem_rdata[8]), .A2(n191), .B1(iomem_rdata[8]), .B2(
        n180), .ZN(n70) );
  AOI22_X1 U292 ( .A1(spimem_rdata[9]), .A2(n191), .B1(iomem_rdata[9]), .B2(
        n180), .ZN(n69) );
  AOI22_X1 U293 ( .A1(spimem_rdata[10]), .A2(n191), .B1(iomem_rdata[10]), .B2(
        n180), .ZN(n68) );
  AOI22_X1 U294 ( .A1(spimem_rdata[11]), .A2(n191), .B1(iomem_rdata[11]), .B2(
        n180), .ZN(n67) );
  AOI22_X1 U295 ( .A1(spimem_rdata[12]), .A2(n192), .B1(iomem_rdata[12]), .B2(
        n180), .ZN(n66) );
  AOI22_X1 U296 ( .A1(spimem_rdata[13]), .A2(n192), .B1(iomem_rdata[13]), .B2(
        n180), .ZN(n65) );
  AOI22_X1 U297 ( .A1(spimem_rdata[14]), .A2(n192), .B1(iomem_rdata[14]), .B2(
        n180), .ZN(n64) );
  AOI22_X1 U298 ( .A1(spimem_rdata[15]), .A2(n192), .B1(iomem_rdata[15]), .B2(
        n180), .ZN(n63) );
  AOI22_X1 U299 ( .A1(spimem_rdata[16]), .A2(n192), .B1(iomem_rdata[16]), .B2(
        n180), .ZN(n62) );
  AOI22_X1 U300 ( .A1(spimem_rdata[17]), .A2(n192), .B1(iomem_rdata[17]), .B2(
        n180), .ZN(n61) );
  AOI22_X1 U301 ( .A1(spimem_rdata[18]), .A2(n192), .B1(iomem_rdata[18]), .B2(
        n180), .ZN(n60) );
  AOI22_X1 U302 ( .A1(spimem_rdata[19]), .A2(n192), .B1(iomem_rdata[19]), .B2(
        n180), .ZN(n59) );
  AOI22_X1 U303 ( .A1(spimem_rdata[20]), .A2(n192), .B1(iomem_rdata[20]), .B2(
        n179), .ZN(n58) );
  AOI22_X1 U304 ( .A1(spimem_rdata[21]), .A2(n192), .B1(iomem_rdata[21]), .B2(
        n179), .ZN(n57) );
  AOI22_X1 U305 ( .A1(spimem_rdata[22]), .A2(n192), .B1(iomem_rdata[22]), .B2(
        n179), .ZN(n56) );
  AOI22_X1 U306 ( .A1(spimem_rdata[23]), .A2(n192), .B1(iomem_rdata[23]), .B2(
        n179), .ZN(n55) );
  NAND4_X1 U307 ( .A1(n92), .A2(n93), .A3(n94), .A4(n95), .ZN(n90) );
  NOR3_X1 U308 ( .A1(n99), .A2(iomem_addr[11]), .A3(iomem_addr[10]), .ZN(n92)
         );
  NOR3_X1 U309 ( .A1(n97), .A2(iomem_addr[22]), .A3(iomem_addr[21]), .ZN(n94)
         );
  NOR4_X1 U310 ( .A1(n98), .A2(iomem_addr[15]), .A3(iomem_addr[17]), .A4(
        iomem_addr[16]), .ZN(n93) );
  INV_X1 U311 ( .A(iomem_wstrb[0]), .ZN(n87) );
  OR4_X1 U312 ( .A1(iomem_addr[26]), .A2(iomem_addr[27]), .A3(n91), .A4(n112), 
        .ZN(n89) );
  OR4_X1 U313 ( .A1(iomem_addr[31]), .A2(iomem_addr[30]), .A3(iomem_addr[29]), 
        .A4(iomem_addr[28]), .ZN(n112) );
  INV_X1 U314 ( .A(iomem_wstrb[1]), .ZN(n86) );
  INV_X1 U315 ( .A(iomem_wstrb[3]), .ZN(n84) );
  INV_X1 U316 ( .A(iomem_wstrb[2]), .ZN(n85) );
  AOI22_X1 U317 ( .A1(simpleuart_reg_dat_do[0]), .A2(n188), .B1(
        simpleuart_reg_div_do[0]), .B2(n185), .ZN(n176) );
  AOI221_X1 U318 ( .B1(spimemio_cfgreg_do[0]), .B2(n42), .C1(ram_rdata[0]), 
        .C2(n195), .A(n201), .ZN(n175) );
  AOI22_X1 U319 ( .A1(simpleuart_reg_dat_do[1]), .A2(n188), .B1(
        simpleuart_reg_div_do[1]), .B2(n185), .ZN(n174) );
  AOI221_X1 U320 ( .B1(spimemio_cfgreg_do[1]), .B2(n42), .C1(ram_rdata[1]), 
        .C2(n195), .A(n202), .ZN(n173) );
  AOI22_X1 U321 ( .A1(simpleuart_reg_dat_do[2]), .A2(n188), .B1(
        simpleuart_reg_div_do[2]), .B2(n185), .ZN(n172) );
  AOI221_X1 U322 ( .B1(spimemio_cfgreg_do[2]), .B2(n42), .C1(ram_rdata[2]), 
        .C2(n195), .A(n203), .ZN(n171) );
  AOI22_X1 U323 ( .A1(simpleuart_reg_dat_do[3]), .A2(n188), .B1(
        simpleuart_reg_div_do[3]), .B2(n185), .ZN(n170) );
  AOI221_X1 U324 ( .B1(spimemio_cfgreg_do[3]), .B2(n42), .C1(ram_rdata[3]), 
        .C2(n195), .A(n204), .ZN(n169) );
  AOI22_X1 U325 ( .A1(simpleuart_reg_dat_do[4]), .A2(n188), .B1(
        simpleuart_reg_div_do[4]), .B2(n185), .ZN(n168) );
  AOI221_X1 U326 ( .B1(spimemio_cfgreg_do[4]), .B2(n42), .C1(ram_rdata[4]), 
        .C2(n195), .A(n205), .ZN(n167) );
  AOI22_X1 U327 ( .A1(simpleuart_reg_dat_do[5]), .A2(n188), .B1(
        simpleuart_reg_div_do[5]), .B2(n185), .ZN(n166) );
  AOI221_X1 U328 ( .B1(spimemio_cfgreg_do[5]), .B2(n42), .C1(ram_rdata[5]), 
        .C2(n195), .A(n206), .ZN(n165) );
  AOI22_X1 U329 ( .A1(simpleuart_reg_dat_do[8]), .A2(n188), .B1(
        simpleuart_reg_div_do[8]), .B2(n185), .ZN(n160) );
  AOI221_X1 U330 ( .B1(spimemio_cfgreg_do[8]), .B2(n42), .C1(ram_rdata[8]), 
        .C2(n194), .A(n209), .ZN(n159) );
  INV_X1 U331 ( .A(n70), .ZN(n209) );
  AOI22_X1 U332 ( .A1(simpleuart_reg_dat_do[9]), .A2(n188), .B1(
        simpleuart_reg_div_do[9]), .B2(n185), .ZN(n158) );
  AOI221_X1 U333 ( .B1(spimemio_cfgreg_do[9]), .B2(n42), .C1(ram_rdata[9]), 
        .C2(n194), .A(n210), .ZN(n157) );
  INV_X1 U334 ( .A(n69), .ZN(n210) );
  AOI22_X1 U335 ( .A1(simpleuart_reg_dat_do[10]), .A2(n188), .B1(
        simpleuart_reg_div_do[10]), .B2(n185), .ZN(n156) );
  AOI221_X1 U336 ( .B1(spimemio_cfgreg_do[10]), .B2(n42), .C1(ram_rdata[10]), 
        .C2(n194), .A(n211), .ZN(n155) );
  INV_X1 U337 ( .A(n68), .ZN(n211) );
  AOI22_X1 U338 ( .A1(simpleuart_reg_dat_do[11]), .A2(n188), .B1(
        simpleuart_reg_div_do[11]), .B2(n185), .ZN(n154) );
  AOI221_X1 U339 ( .B1(spimemio_cfgreg_do[11]), .B2(n42), .C1(ram_rdata[11]), 
        .C2(n194), .A(n212), .ZN(n153) );
  INV_X1 U340 ( .A(n67), .ZN(n212) );
  AOI22_X1 U341 ( .A1(simpleuart_reg_dat_do[16]), .A2(n189), .B1(
        simpleuart_reg_div_do[16]), .B2(n186), .ZN(n144) );
  AOI221_X1 U342 ( .B1(spimemio_cfgreg_do[16]), .B2(n42), .C1(ram_rdata[16]), 
        .C2(n194), .A(n217), .ZN(n143) );
  INV_X1 U343 ( .A(n62), .ZN(n217) );
  AOI22_X1 U344 ( .A1(simpleuart_reg_dat_do[17]), .A2(n189), .B1(
        simpleuart_reg_div_do[17]), .B2(n186), .ZN(n142) );
  AOI221_X1 U345 ( .B1(spimemio_cfgreg_do[17]), .B2(n42), .C1(ram_rdata[17]), 
        .C2(n194), .A(n218), .ZN(n141) );
  INV_X1 U346 ( .A(n61), .ZN(n218) );
  AOI22_X1 U347 ( .A1(simpleuart_reg_dat_do[18]), .A2(n189), .B1(
        simpleuart_reg_div_do[18]), .B2(n186), .ZN(n140) );
  AOI221_X1 U348 ( .B1(spimemio_cfgreg_do[18]), .B2(n42), .C1(ram_rdata[18]), 
        .C2(n194), .A(n219), .ZN(n139) );
  INV_X1 U349 ( .A(n60), .ZN(n219) );
  AOI22_X1 U350 ( .A1(simpleuart_reg_dat_do[19]), .A2(n189), .B1(
        simpleuart_reg_div_do[19]), .B2(n186), .ZN(n138) );
  AOI221_X1 U351 ( .B1(spimemio_cfgreg_do[19]), .B2(n42), .C1(ram_rdata[19]), 
        .C2(n194), .A(n220), .ZN(n137) );
  INV_X1 U352 ( .A(n59), .ZN(n220) );
  AOI22_X1 U353 ( .A1(simpleuart_reg_dat_do[20]), .A2(n189), .B1(
        simpleuart_reg_div_do[20]), .B2(n186), .ZN(n136) );
  AOI221_X1 U354 ( .B1(spimemio_cfgreg_do[20]), .B2(n42), .C1(ram_rdata[20]), 
        .C2(n194), .A(n221), .ZN(n135) );
  INV_X1 U355 ( .A(n58), .ZN(n221) );
  AOI22_X1 U356 ( .A1(simpleuart_reg_dat_do[21]), .A2(n189), .B1(
        simpleuart_reg_div_do[21]), .B2(n186), .ZN(n134) );
  AOI221_X1 U357 ( .B1(spimemio_cfgreg_do[21]), .B2(n42), .C1(ram_rdata[21]), 
        .C2(n194), .A(n222), .ZN(n133) );
  INV_X1 U358 ( .A(n57), .ZN(n222) );
  AOI22_X1 U359 ( .A1(simpleuart_reg_dat_do[22]), .A2(n189), .B1(
        simpleuart_reg_div_do[22]), .B2(n186), .ZN(n132) );
  AOI221_X1 U360 ( .B1(spimemio_cfgreg_do[22]), .B2(n42), .C1(ram_rdata[22]), 
        .C2(n194), .A(n223), .ZN(n131) );
  INV_X1 U361 ( .A(n56), .ZN(n223) );
  AOI22_X1 U362 ( .A1(simpleuart_reg_dat_do[31]), .A2(n190), .B1(
        simpleuart_reg_div_do[31]), .B2(n187), .ZN(n114) );
  AOI221_X1 U363 ( .B1(spimemio_cfgreg_do[31]), .B2(n42), .C1(ram_rdata[31]), 
        .C2(n194), .A(n232), .ZN(n113) );
  INV_X1 U364 ( .A(n44), .ZN(n232) );
  AOI21_X1 U365 ( .B1(ram_rdata[7]), .B2(n195), .A(n208), .ZN(n161) );
  AOI22_X1 U366 ( .A1(simpleuart_reg_dat_do[7]), .A2(n188), .B1(
        simpleuart_reg_div_do[7]), .B2(n185), .ZN(n162) );
  INV_X1 U367 ( .A(n71), .ZN(n208) );
  AOI21_X1 U368 ( .B1(ram_rdata[13]), .B2(n195), .A(n214), .ZN(n149) );
  AOI22_X1 U369 ( .A1(simpleuart_reg_dat_do[13]), .A2(n189), .B1(
        simpleuart_reg_div_do[13]), .B2(n186), .ZN(n150) );
  INV_X1 U370 ( .A(n65), .ZN(n214) );
  AOI21_X1 U371 ( .B1(ram_rdata[15]), .B2(n195), .A(n216), .ZN(n145) );
  AOI22_X1 U372 ( .A1(simpleuart_reg_dat_do[15]), .A2(n189), .B1(
        simpleuart_reg_div_do[15]), .B2(n186), .ZN(n146) );
  INV_X1 U373 ( .A(n63), .ZN(n216) );
  AOI21_X1 U374 ( .B1(ram_rdata[23]), .B2(n196), .A(n224), .ZN(n129) );
  AOI22_X1 U375 ( .A1(simpleuart_reg_dat_do[23]), .A2(n189), .B1(
        simpleuart_reg_div_do[23]), .B2(n186), .ZN(n130) );
  INV_X1 U376 ( .A(n55), .ZN(n224) );
  AOI21_X1 U377 ( .B1(ram_rdata[25]), .B2(n196), .A(n226), .ZN(n125) );
  AOI22_X1 U378 ( .A1(simpleuart_reg_dat_do[25]), .A2(n190), .B1(
        simpleuart_reg_div_do[25]), .B2(n187), .ZN(n126) );
  INV_X1 U379 ( .A(n53), .ZN(n226) );
  AOI21_X1 U380 ( .B1(ram_rdata[27]), .B2(n196), .A(n228), .ZN(n121) );
  AOI22_X1 U381 ( .A1(simpleuart_reg_dat_do[27]), .A2(n190), .B1(
        simpleuart_reg_div_do[27]), .B2(n187), .ZN(n122) );
  INV_X1 U382 ( .A(n51), .ZN(n228) );
  AOI21_X1 U383 ( .B1(ram_rdata[29]), .B2(n196), .A(n230), .ZN(n117) );
  AOI22_X1 U384 ( .A1(simpleuart_reg_dat_do[29]), .A2(n190), .B1(
        simpleuart_reg_div_do[29]), .B2(n187), .ZN(n118) );
  INV_X1 U385 ( .A(n49), .ZN(n230) );
  AOI21_X1 U386 ( .B1(ram_rdata[6]), .B2(n195), .A(n207), .ZN(n163) );
  AOI22_X1 U387 ( .A1(simpleuart_reg_dat_do[6]), .A2(n188), .B1(
        simpleuart_reg_div_do[6]), .B2(n185), .ZN(n164) );
  INV_X1 U388 ( .A(n72), .ZN(n207) );
  AOI21_X1 U389 ( .B1(ram_rdata[12]), .B2(n195), .A(n213), .ZN(n151) );
  AOI22_X1 U390 ( .A1(simpleuart_reg_dat_do[12]), .A2(n189), .B1(
        simpleuart_reg_div_do[12]), .B2(n186), .ZN(n152) );
  INV_X1 U391 ( .A(n66), .ZN(n213) );
  AOI21_X1 U392 ( .B1(ram_rdata[14]), .B2(n195), .A(n215), .ZN(n147) );
  AOI22_X1 U393 ( .A1(simpleuart_reg_dat_do[14]), .A2(n189), .B1(
        simpleuart_reg_div_do[14]), .B2(n186), .ZN(n148) );
  INV_X1 U394 ( .A(n64), .ZN(n215) );
  AOI21_X1 U395 ( .B1(ram_rdata[24]), .B2(n196), .A(n225), .ZN(n127) );
  AOI22_X1 U396 ( .A1(simpleuart_reg_dat_do[24]), .A2(n190), .B1(
        simpleuart_reg_div_do[24]), .B2(n187), .ZN(n128) );
  INV_X1 U397 ( .A(n54), .ZN(n225) );
  AOI21_X1 U398 ( .B1(ram_rdata[26]), .B2(n196), .A(n227), .ZN(n123) );
  AOI22_X1 U399 ( .A1(simpleuart_reg_dat_do[26]), .A2(n190), .B1(
        simpleuart_reg_div_do[26]), .B2(n187), .ZN(n124) );
  INV_X1 U400 ( .A(n52), .ZN(n227) );
  AOI21_X1 U401 ( .B1(ram_rdata[28]), .B2(n196), .A(n229), .ZN(n119) );
  AOI22_X1 U402 ( .A1(simpleuart_reg_dat_do[28]), .A2(n190), .B1(
        simpleuart_reg_div_do[28]), .B2(n187), .ZN(n120) );
  INV_X1 U403 ( .A(n50), .ZN(n229) );
  AOI21_X1 U404 ( .B1(ram_rdata[30]), .B2(n196), .A(n231), .ZN(n115) );
  AOI22_X1 U405 ( .A1(simpleuart_reg_dat_do[30]), .A2(n190), .B1(
        simpleuart_reg_div_do[30]), .B2(n187), .ZN(n116) );
  INV_X1 U406 ( .A(n48), .ZN(n231) );
  AND4_X1 U407 ( .A1(n103), .A2(n104), .A3(n105), .A4(n106), .ZN(n100) );
  NOR4_X1 U408 ( .A1(n110), .A2(n111), .A3(iomem_addr[0]), .A4(n89), .ZN(n103)
         );
  NOR4_X1 U409 ( .A1(n109), .A2(iomem_addr[13]), .A3(iomem_addr[15]), .A4(
        iomem_addr[14]), .ZN(n104) );
  NOR4_X1 U410 ( .A1(n108), .A2(iomem_addr[19]), .A3(iomem_addr[20]), .A4(
        iomem_addr[1]), .ZN(n105) );
  OR3_X1 U411 ( .A1(iomem_addr[24]), .A2(iomem_addr[25]), .A3(iomem_addr[23]), 
        .ZN(n97) );
  OR3_X1 U412 ( .A1(iomem_addr[13]), .A2(iomem_addr[14]), .A3(iomem_addr[12]), 
        .ZN(n99) );
  OR3_X1 U413 ( .A1(iomem_addr[19]), .A2(iomem_addr[20]), .A3(iomem_addr[18]), 
        .ZN(n98) );
  OR3_X1 U414 ( .A1(iomem_addr[22]), .A2(iomem_addr[23]), .A3(iomem_addr[21]), 
        .ZN(n108) );
  OR3_X1 U415 ( .A1(iomem_addr[17]), .A2(iomem_addr[18]), .A3(iomem_addr[16]), 
        .ZN(n109) );
  OR3_X1 U416 ( .A1(iomem_addr[11]), .A2(iomem_addr[12]), .A3(iomem_addr[10]), 
        .ZN(n110) );
  AND2_X1 U417 ( .A1(mem_valid), .A2(N8), .ZN(iomem_valid) );
  INV_X1 U418 ( .A(mem_valid), .ZN(n91) );
  INV_X1 U419 ( .A(n78), .ZN(n201) );
  AOI22_X1 U420 ( .A1(spimem_rdata[0]), .A2(n191), .B1(iomem_rdata[0]), .B2(
        n181), .ZN(n78) );
  INV_X1 U421 ( .A(n77), .ZN(n202) );
  AOI22_X1 U422 ( .A1(spimem_rdata[1]), .A2(n191), .B1(iomem_rdata[1]), .B2(
        n181), .ZN(n77) );
  INV_X1 U423 ( .A(n76), .ZN(n203) );
  AOI22_X1 U424 ( .A1(spimem_rdata[2]), .A2(n191), .B1(iomem_rdata[2]), .B2(
        n181), .ZN(n76) );
  INV_X1 U425 ( .A(n75), .ZN(n204) );
  AOI22_X1 U426 ( .A1(spimem_rdata[3]), .A2(n191), .B1(iomem_rdata[3]), .B2(
        n181), .ZN(n75) );
  INV_X1 U427 ( .A(n74), .ZN(n205) );
  AOI22_X1 U428 ( .A1(spimem_rdata[4]), .A2(n191), .B1(iomem_rdata[4]), .B2(
        n181), .ZN(n74) );
  INV_X1 U429 ( .A(n73), .ZN(n206) );
  AOI22_X1 U430 ( .A1(spimem_rdata[5]), .A2(n191), .B1(iomem_rdata[5]), .B2(
        n181), .ZN(n73) );
  INV_X1 U431 ( .A(iomem_addr[3]), .ZN(n102) );
  INV_X1 U432 ( .A(iomem_addr[2]), .ZN(n101) );
  INV_X1 U433 ( .A(iomem_addr[25]), .ZN(n111) );
  NOR3_X4 U434 ( .A1(n199), .A2(ram_ready), .A3(n80), .ZN(n42) );
  OR4_X1 U435 ( .A1(iomem_addr[29]), .A2(iomem_addr[28]), .A3(iomem_addr[31]), 
        .A4(iomem_addr[30]), .ZN(n197) );
  OR4_X1 U436 ( .A1(iomem_addr[27]), .A2(iomem_addr[26]), .A3(iomem_addr[25]), 
        .A4(n197), .ZN(N8) );
endmodule

