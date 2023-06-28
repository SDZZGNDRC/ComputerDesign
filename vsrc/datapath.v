`include "defines.v"

// 数据通路
module DATAPATH(
    input wire clk,
    input wire rst,

    input [`WIDTH-1:0] memrdata_i,
    input alusrca_i,
    input memtoreg_i,
    input iord_i,
    input pcen_i,
    input regwrite_i,
    input regdst_i,
    input [1:0] pcsource_i,
    input [2:0] alusrcb_i,
    input irwrite_i,
    input [2:0] alucont_i,
    
    output zero_o,
    output [`WIDTH-1:0] inst_o,
    output [`WIDTH-1:0] memaddr_o,
    output [`WIDTH-1:0] memwdata_o
);

    wire [`REG_WIDTH-1:0] ra1, ra2, wa;
    wire [`WIDTH-1:0] pc, nextpc, md, rd1, rd2, wd, a, src1; 
    wire [`WIDTH-1:0] src2, aluresult, aluout, constx4;

    wire [`WIDTH-1:0] signed_ext_imm;

    // 立即数有符号扩展
    assign signed_ext_imm = {inst_o[15], inst_o[15:0]};

    // 左移两位
    assign constx4 = {inst_o[`WIDTH-3:0], 2'b00};

    // 寄存器文件的地址域
    assign ra1 = inst_o[`REG_WIDTH+20:21];
    assign ra2 = inst_o[`REG_WIDTH+15:16];
    MUX2 #(`REG_WIDTH) regmux(
        .d0(inst_o[`REG_WIDTH+15:16]),
        .d1(inst_o[`REG_WIDTH+10:11]),
        .sel(regdst_i),
        .y(wa)
    );
    FLOPEN #(`WIDTH) ir(
        .clk(clk),
        .en(irwrite_i),
        .d(memrdata_i),
        .q(inst_o)
    );

    FLOPENR #(`WIDTH) pc_reg(clk, pcen_i, rst, nextpc, pc);
    // FLOP # (`WIDTH) mdr(clk, memrdata_i, md);
    FLOP # (`WIDTH) areg(clk, rd1, a);
    FLOP # (`WIDTH) wrd(clk, rd2, memwdata_o);
    FLOP # (`WIDTH) res(clk, aluresult, aluout);
    MUX2 # (`WIDTH) adrmux(pc, aluout, iord_i, memaddr_o);
    MUX2 # (`WIDTH) src1mux(pc, a, alusrca_i, src1);

    MuxKeyWithDefault #(5, 3, `WIDTH) src2mux(
        .out(src2),
        .key(alusrcb_i),
        .default_out(`WIDTH'h0),
        .lut({
            3'b000, memwdata_o,
            3'b001, `CONST_FOUR,
            3'b010, inst_o[`WIDTH-1:0],
            3'b011, constx4,
            3'b100, signed_ext_imm
        })
    );

    MUX4 # (`WIDTH) pcmux(aluresult, aluout, constx4, `CONST_ZERO,
        pcsource_i, nextpc);
    MUX2 # (`WIDTH) wdmux(aluout, memrdata_i, memtoreg_i, wd);
    REGFILE #(`WIDTH, `REG_WIDTH) rf(clk, rst, regwrite_i, ra1, ra2, wa, wd, rd1, rd2);
    ALU #(`WIDTH) alu(src1, src2, alucont_i, aluresult);
    ZERODETECT #(`WIDTH) zd(aluresult, zero_o);
endmodule