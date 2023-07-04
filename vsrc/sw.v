module Switches(
    input clk,
    input rst,
    input [13:0] sw_i,
    output [13:0] sw_o
);

reg [13:0] sw;
assign sw_o = sw;

always @(posedge clk) begin
    if (rst) begin
        sw <= 14'b0;
    end else begin
        sw <= sw_i;
    end
end

endmodule