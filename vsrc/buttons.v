module Buttons(
    input clk,
    input rst,
    input [3:0] btn_i,
    output [3:0] btn_o
);

reg [3:0] btn;
assign btn_o = btn;

always @(posedge clk) begin
    if (rst) begin
        btn <= btn_i;
    end
end

endmodule