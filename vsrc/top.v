// SoC顶层模块, 连接core, memory, io等模块
module top (
    input wire clk,
    input wire rst,
    input wire [3:0] buttons_i,

    output [3:0] led_o,
    output [6:0] seg7_seg_o,
    output [3:0] seg7_an_o
);
    wire memread, memwrite;
    wire [`ADDR_WIDTH-1:0] memaddr;
    wire [`WIDTH-1:0] memwdata;
    wire [`WIDTH-1:0] memrdata;
    assign led_o = buttons_i;
    CORE core(
        .clk(clk),
        .rst(rst),

        .memrdata_i(memrdata),

        .memread_o(memread),
        .memwrite_o(memwrite),
        .memaddr_o(memaddr),
        .memwdata_o(memwdata)
    );

    MEMORY memory(
        .clk(clk),
        .rst(rst),

        .memread_i(memread),
        .memwrite_i(memwrite),
        .memaddr_i(memaddr),
        .memwdata_i(memwdata),
        .buttons_i(buttons_i),
        
        .memrdata_o(memrdata),
        .seg7_seg_o(seg7_seg_o),
        .seg7_an_o(seg7_an_o)
    );

endmodule