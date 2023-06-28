// 4路复选器
module MUX4 # (parameter WIDTH=32) (
    input [WIDTH - 1 : 0] d0,
    input [WIDTH - 1 : 0] d1,
    input [WIDTH - 1 : 0] d2,
    input [WIDTH - 1 : 0] d3,
    input [1 : 0] sel,
    output reg [WIDTH - 1 : 0] y
);
    always @(*) begin
        case (sel)
            2'b00: y <= d0;
            2'b01: y <= d1;
            2'b10: y <= d2;
            2'b11: y <= d3;
        endcase
    end
endmodule