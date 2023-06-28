module FLOPENR #(parameter WIDTH=32)(
    input clk,
    input en,
    input rst,

    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (rst) q <= 0;
        else if (en) q <= d;
    end
endmodule