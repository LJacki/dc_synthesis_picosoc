// SPDX-License-Identifier: CC0-1.0
// Synthesizable SPI Flash stub for DC synthesis
module spiflash (
    output flash_csb,
    output flash_clk,
    output flash_io0_oe,
    output flash_io1_oe,
    output flash_io2_oe,
    output flash_io3_oe,
    output flash_io0_do,
    output flash_io1_do,
    output flash_io2_do,
    output flash_io3_do,
    input  flash_io0_di,
    input  flash_io1_di,
    input  flash_io2_di,
    input  flash_io3_di
);
    assign flash_io0_do = 1'b0;
    assign flash_io1_do = 1'b0;
    assign flash_io2_do = 1'b0;
    assign flash_io3_do = 1'b0;
    assign flash_io0_oe = 1'b0;
    assign flash_io1_oe = 1'b0;
    assign flash_io2_oe = 1'b0;
    assign flash_io3_oe = 1'b0;
    assign flash_csb    = 1'b1;
    assign flash_clk    = 1'b0;
endmodule
