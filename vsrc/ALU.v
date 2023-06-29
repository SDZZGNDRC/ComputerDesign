module ALU #(parameter WIDTH = 32) (
    input [WIDTH - 1 : 0] a_i,
    input [WIDTH - 1 : 0] b_i,
    input [2 : 0] alucont_i,
    output reg [WIDTH - 1 : 0] result_o
);
    wire [WIDTH - 1 : 0] b2, sum, slt;

    assign b2 = alucont_i[2] ? ~b_i : b_i;
    assign sum = a_i + b2 + alucont_i[2];
    assign slt = sum[WIDTH-1];

    always @(*) begin
        case (alucont_i[1:0])
            2'b00: result_o <= a_i & b2;
            2'b01: result_o <= a_i | b2;
            2'b10: result_o <= sum;
            2'b11: result_o <= alucont_i[2] ? slt : a_i;  // for slt and jr
        endcase
    end
endmodule