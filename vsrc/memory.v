// 内存模块, 将IRAM, DRAM以及外部设备抽象为一个内存模块
module MEMORY(
    input clk,
    input rst,

    input memread_i,
    input memwrite_i,
    input [`ADDR_WIDTH-1:0] memaddr_i,
    input [`WIDTH-1:0] memwdata_i,

    output [`WIDTH-1:0] memrdata_o
);

    wire [`WIDTH-1:0] memrdata_irom;
    wire [`WIDTH-1:0] memrdata_dram;
    wire memwrite_t;

    reg [`ADDR_WIDTH-1:0] memaddr_t;

    always @(posedge clk) begin
        if (rst) begin
            memaddr_t <= `ADDR_WIDTH'd0;
        end else begin
            memaddr_t <= memaddr_i;
        end
    end

    // 地址空间的0 ~ 4K-1用于存储指令, 4k ~ 8k-1用于存储数据

    // 当地址位于DRAM的地址空间时, 写请求才有效 (FIXME: 加入外设时需要修改)
    assign memwrite_t = (memaddr_i >= `ADDR_WIDTH'd4096) && (memaddr_i < `ADDR_WIDTH'd8192) ? memwrite_i : 1'b0;

    // 当地址位于IRAM的地址空间时, 输出IRAM的数据; 否则输出DRAM的数据 (FIXME: 加入外设时需要修改)
    assign memrdata_o = (memaddr_t < `ADDR_WIDTH'd4096) ? memrdata_irom : memrdata_dram;

    IROM irom(
        .clk(clk),

        .addr_i(memaddr_i),

        .data_o(memrdata_irom)
    );

    DRAM dram(
        .clk(clk),

        .wea_i(memwrite_t),
        .addra_i(memaddr_i),
        .dina_i(memwdata_i),

        .douta_o(memrdata_dram)
    );
endmodule