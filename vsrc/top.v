// SoC顶层模块, 连接core, memory, io等模块
module top (
    input wire clk,
    input wire rst
);
    wire memread, memwrite;
    wire [`ADDR_WIDTH-1:0] memaddr;
    wire [`WIDTH-1:0] memwdata;
    wire [`WIDTH-1:0] memrdata;

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
        
        .memrdata_o(memrdata)
    );

endmodule