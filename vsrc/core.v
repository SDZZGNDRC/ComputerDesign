`include "defines.v"

// CPU内核
module CORE(
    input clk,
    input rst,
    input wire [`WIDTH-1:0] memrdata_i,

    output memread_o,
    output memwrite_o,
    output [`ADDR_WIDTH-1:0] memaddr_o,
    output [`WIDTH-1:0] memwdata_o
);
    wire [`WIDTH-1:0] inst; // 指令
    wire zero, alusrca, memtoreg, iord, pcen, regwrite, regdst;
    wire [1:0] aluop, pcsource;
    wire [2:0] alusrcb;
    wire irwrite;
    wire [2:0] alucont;

    CONTROLLER controller(
        .clk(clk),
        .rst(rst),

        .op_i(inst[31:26]), // FIXME: 对照指导书源码, 难道不应该时inst[31:26]吗?
        .zero_i(zero),

        .memread_o(memread_o),
        .memwrite_o(memwrite_o),
        .alusrca_o(alusrca),
        .memtoreg_o(memtoreg),
        .iord_o(iord),
        .pcen_o(pcen),
        .regwrite_o(regwrite),
        .regdst_o(regdst),
        .pcsource_o(pcsource),
        .alusrcb_o(alusrcb),
        .aluop_o(aluop),
        .irwrite_o(irwrite)
    );
    ALUCTRL ac(
        .aluop_i(aluop),
        .funct_i(inst[5:0]),
        .alucont_o(alucont)
    );
    DATAPATH dp(
        .clk(clk),
        .rst(rst),

        .memrdata_i(memrdata_i),
        .alusrca_i(alusrca),
        .memtoreg_i(memtoreg),
        .iord_i(iord),
        .pcen_i(pcen),
        .regwrite_i(regwrite),
        .regdst_i(regdst),
        .pcsource_i(pcsource),
        .alusrcb_i(alusrcb),
        .irwrite_i(irwrite),
        .alucont_i(alucont),

        .zero_o(zero),
        .inst_o(inst),
        .memaddr_o(memaddr_o),
        .memwdata_o(memwdata_o)
    );
endmodule