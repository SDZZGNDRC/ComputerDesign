`include "defines.v"

// 控制单元
module CONTROLLER(
    input clk,
    input rst,

    input wire [5:0] op_i,
    input wire [5:0] funct_i,
    input zero_i,
    
    output reg memread_o,
    output reg memwrite_o,
    output reg alusrca_o,
    output reg memtoreg_o,
    output reg iord_o,
    output     pcen_o,
    output reg bne_o,
    output reg j_o,
    output reg jr_o,
    output reg regwrite_o,
    output reg regdst_o,
    output reg [1:0] pcsource_o,
    output reg [2:0] alusrcb_o,
    output reg [1:0] aluop_o,
    output reg irwrite_o
);
    reg [`CU_STATE_WIDTH-1:0] state, next_state;
    reg pcwrite, pcwritecond_BEQ, pcwritecond_BNQ;

    // 状态切换
    always @(posedge clk) begin
        if (rst) begin
            state <= `CU_STATE_FETCH;
        end else begin
            state <= next_state;
        end
    end

    // 下一状态的生成逻辑
    always @(*) begin
        case (state)
            `CU_STATE_FETCH: begin
                next_state = `CU_STATE_DECODE;
            end
            `CU_STATE_DECODE: begin
                case (op_i)
                    `OP_ADDI: next_state <= `CU_STATE_ADDIEX;
                    `OP_LB: next_state <= `CU_STATE_MEMADR;
                    `OP_SB: next_state <= `CU_STATE_MEMADR;
                    `OP_R_TYPE: next_state <= (funct_i == `FUN_JR) ? `CU_STATE_JREX : `CU_STATE_R_TYPE_EX;
                    `OP_BEQ: next_state <= `CU_STATE_BEQEX;
                    `OP_J: next_state <= `CU_STATE_JEX;
                    `OP_BNE: next_state <= `CU_STATE_BNEEX;
                    default: next_state <= `CU_STATE_FETCH;
                endcase
            end
            `CU_STATE_MEMADR: begin
                case (op_i)
                    `OP_LB: next_state <= `CU_STATE_LBRD;
                    `OP_SB: next_state <= `CU_STATE_SBWR;
                    default: next_state <= `CU_STATE_FETCH;
                endcase
            end
            `CU_STATE_LBRD: next_state <= `CU_STATE_LBWR;
            `CU_STATE_LBWR: next_state <= `CU_STATE_FETCH;
            `CU_STATE_SBWR: next_state <= `CU_STATE_FETCH;
            `CU_STATE_R_TYPE_EX: next_state <= `CU_STATE_R_TYPE_WR;
            `CU_STATE_R_TYPE_WR: next_state <= `CU_STATE_FETCH;
            `CU_STATE_BEQEX: next_state <= `CU_STATE_FETCH;
            `CU_STATE_JEX: next_state <= `CU_STATE_FETCH;
            `CU_STATE_ADDIEX: next_state <= `CU_STATE_ADDIWR;
            `CU_STATE_ADDIWR: next_state <= `CU_STATE_FETCH;
            `CU_STATE_BNEEX: next_state <= `CU_STATE_FETCH;
            `CU_STATE_JREX: next_state <= `CU_STATE_FETCH;
            default: next_state <= `CU_STATE_FETCH;
        endcase
    end

    // 控制信号的生成逻辑
    always @(*) begin
        irwrite_o <= 1'b0;
        pcwrite <= 1'b0;
        pcwritecond_BEQ <= 1'b0;
        pcwritecond_BNQ <= 1'b0;
        regwrite_o <= 1'b0;
        regdst_o <= 1'b0;
        memread_o <= 1'b0;
        memwrite_o <= 1'b0;
        alusrca_o <= 1'b0;
        alusrcb_o <= 3'b000;
        aluop_o <= 2'b00;
        pcsource_o <= 2'b00;
        iord_o <= 1'b0;
        memtoreg_o <= 1'b0;
        bne_o <= 1'b0;
        j_o <= 1'b0;
        jr_o <= 1'b0;
        case (state)
            `CU_STATE_FETCH: begin
                memread_o <= 1'b1;
                irwrite_o <= 1'b1;
                pcwrite <= 1'b1;
                alusrcb_o <= 3'b001;
            end
            `CU_STATE_DECODE: alusrcb_o <= 3'b011;
            `CU_STATE_MEMADR: begin
                alusrca_o <= 1'b1;
                alusrcb_o <= 3'b010;
            end
            `CU_STATE_LBRD: begin
                memread_o <= 1'b1;
                iord_o <= 1'b1;
            end
            `CU_STATE_LBWR: begin
                regwrite_o <= 1'b1;
                memtoreg_o <= 1'b1;
            end
            `CU_STATE_SBWR: begin
                memwrite_o <= 1'b1;
                iord_o <= 1'b1;
            end
            `CU_STATE_R_TYPE_EX: begin
                alusrca_o <= 1'b1;
                aluop_o <= 2'b10;
            end
            `CU_STATE_R_TYPE_WR: begin
                regwrite_o <= 1'b1;
                regdst_o <= 1'b1;
            end
            `CU_STATE_BEQEX: begin
                alusrca_o <= 1'b1;
                aluop_o <= 2'b01;
                pcsource_o <= 2'b01;
                pcwritecond_BEQ <= 1'b1;
            end
            `CU_STATE_JEX: begin
                pcsource_o <= 2'b10;
                pcwrite <= 1'b1;
                j_o <= 1'b1;
            end
            `CU_STATE_ADDIEX: begin
                alusrca_o <= 1'b1;
                alusrcb_o <= 3'b100;  // FIXME: Change
                aluop_o <= 2'b00;
            end
            `CU_STATE_ADDIWR: begin
                regwrite_o <= 1'b1;
                regdst_o <= 1'b0;
            end
            `CU_STATE_BNEEX: begin
                alusrca_o <= 1'b1;
                aluop_o <= 2'b01;
                pcsource_o <= 2'b01;
                pcwritecond_BNQ <= 1'b1;
                bne_o <= 1'b1;
            end
            `CU_STATE_JREX: begin
                alusrca_o <= 1'b1;
                aluop_o <= 2'b10;
                // pcsource_o <= 2'b00;
                pcwrite <= 1'b1;
                jr_o <= 1'b1;
            end
        endcase
    end

    assign pcen_o = pcwrite | (pcwritecond_BEQ & zero_i) | (pcwritecond_BNQ & ~zero_i); // PC写使能信号
endmodule