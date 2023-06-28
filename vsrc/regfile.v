// 寄存器文件
module REGFILE # (parameter WIDTH = 32, REGBITS = 3) (
    input clk,

    input regwrite_i,
    input [REGBITS - 1 : 0] ra1_i, ra2_i, wa_i,
    input [WIDTH - 1 : 0] wd_i,
    output [WIDTH - 1 : 0] rd1_o, rd2_o
);
    reg [WIDTH-1:0] regs [(1<<REGBITS)-1:0];

    always @(posedge clk) begin
        if (regwrite_i) regs[wa_i] <= wd_i;
    end
    
    assign rd1_o = ra1_i ? regs[ra1_i] : `CONST_ZERO;
    assign rd2_o = ra2_i ? regs[ra2_i] : `CONST_ZERO;
endmodule