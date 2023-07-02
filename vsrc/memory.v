// 内存模块, 将IRAM, DRAM以及外部设备抽象为一个内存模块
module MEMORY(
    input clk,
    input rst,

    input memread_i,
    input memwrite_i,
    input [`ADDR_WIDTH-1:0] memaddr_i,
    input [`WIDTH-1:0] memwdata_i,
    input [3:0] buttons_i,

    output [`WIDTH-1:0] memrdata_o,
    output [6:0] seg7_seg_o,
    output [3:0] seg7_an_o,
    output wire hsync_o,
    output wire vsync_o,
    output wire [3:0] vga_r_o,
    output wire [3:0] vga_g_o,
    output wire [3:0] vga_b_o
);

    wire [`WIDTH-1:0] memrdata_irom;
    wire [`WIDTH-1:0] memrdata_dram;
    wire memwrite_t;
    wire memwrite_device_t;

    reg [15:0] seg7_num_r;
    reg [3:0] seg7_an_r;
    wire [3:0] btn;
    wire memrdevice_t;
    reg memrdevice_t_r;
    wire [`WIDTH-1:0] device_r_data_t;

    assign device_r_data_t = {28'd0, btn};


    always @(posedge clk) begin
        if (rst) begin
            seg7_num_r <= 16'd0;
        end else if (memaddr_i == 16'hfff0 && memwrite_i) begin
            seg7_num_r <= memwdata_i[15:0];
        end
    end

    always @(posedge clk) begin
        memrdevice_t_r <= memrdevice_t;
    end

    always @(posedge clk) begin
        if (rst) begin
            seg7_an_r <= 4'd0;
        end else if (memaddr_i == 32'hfff4 && memwrite_i) begin
            seg7_an_r <= memwdata_i[3:0];
        end
    end

    reg [`ADDR_WIDTH-1:0] memaddr_t;
    reg memwrite_t_r;
    reg memwrite_device_t_r;

    always @(posedge clk) begin
        memwrite_t_r <= memwrite_t;
        memwrite_device_t_r <= memwrite_device_t;
    end

    always @(posedge clk) begin
        if (rst) begin
            memaddr_t <= `ADDR_WIDTH'd0;
        end else begin
            memaddr_t <= memaddr_i;
        end
    end

    wire [`ADDR_WIDTH-1:0] iram_addr_t;
    assign iram_addr_t = (memwrite_t | memwrite_device_t) ? memaddr_t : memaddr_i;

    // 地址空间的0 ~ 4K-1用于存储指令, 4k ~ 8k-1用于存储数据

    // 当地址位于DRAM的地址空间时, 写请求才有效 (FIXME: 加入外设时需要修改)
    assign memwrite_t = (memaddr_i >= `ADDR_WIDTH'd4096) && (memaddr_i < `ADDR_WIDTH'd8192) ? memwrite_i : 1'b0;

    // 当地址位于device的地址空间时, 写请求才有效
    assign memwrite_device_t = (memaddr_i >= `ADDR_WIDTH'd8192) ? memwrite_i : 1'b0;
    assign memrdevice_t = (memaddr_i >= `ADDR_WIDTH'd8192) ? memread_i : 1'b0;

    // 当地址位于IRAM的地址空间时, 输出IRAM的数据; 否则输出DRAM的数据 (FIXME: 加入外设时需要修改)
    assign memrdata_o = (memaddr_t < `ADDR_WIDTH'd4096 || memwrite_t_r || memwrite_device_t_r) ? memrdata_irom : (memrdevice_t_r) ? device_r_data_t : memrdata_dram;

    IROM irom(
        .clk(clk),

        .addr_i(iram_addr_t),

        .data_o(memrdata_irom)
    );

    DRAM dram(
        .clk(clk),

        .wea_i(memwrite_t),
        .addra_i(memaddr_i),
        .dina_i(memwdata_i),

        .douta_o(memrdata_dram)
    );

    Seg7 seg7 (
        .num(seg7_num_r),
        .clk(clk),
        .rst(rst),
        .sel(seg7_an_r),
        .seg(seg7_seg_o),
        .an(seg7_an_o)
    );

    Buttons buttons(
        .clk(clk),
        .rst(rst),

        .btn_i(buttons_i),
        .btn_o(btn)
    );

    DVGA dvga(
        .clk(clk),
        .rst(rst),

        .we_i(),
        .addr_i(),
        .wdata_i(),

        .hsync_o(hsync_o),
        .vsync_o(vsync_o),
        .r_o(vga_r_o),
        .g_o(vga_g_o),
        .b_o(vga_b_o)
    );
endmodule