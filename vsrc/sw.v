module Switches(
    input clk,
    input rst,
    input [11:0] sw_i,
    output [11:0] sw_o
);

reg [11:0] sw;
assign sw_o = sw;

always @(posedge clk) begin
    if (rst) begin
        sw <= 12'b0;
    end else begin
        sw <= sw_i;
    end
end

endmodule