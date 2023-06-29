// ALU控制器
module ALUCTRL(
    input wire [1:0] aluop_i,
    input wire [5:0] funct_i,
    output reg [2:0] alucont_o
);
    always @(*) begin
        case (aluop_i)
            2'b00: alucont_o <= 3'b010; // add for lb/sb/addi
            2'b01: alucont_o <= 3'b110; // sub for sub/beq
            default:
                case (funct_i)
                    6'b100000: alucont_o <= 3'b010; // add
                    6'b100010: alucont_o <= 3'b110; // sub
                    6'b100100: alucont_o <= 3'b000; // and
                    6'b100101: alucont_o <= 3'b001; // or
                    6'b101010: alucont_o <= 3'b111; // slt
                    6'b001000: alucont_o <= 3'b011; // jr
                    default: alucont_o <= 3'b101;
                endcase
        endcase
    end
endmodule