module DVGA(
    input clk,
    input rst,

    input wire we_i,
    input wire [16:0] addr_i,
    input wire [11:0] wdata_i,

    output wire hsync_o,
    output wire vsync_o,
    output wire [3:0] r_o,
    output wire [3:0] g_o,
    output wire [3:0] b_o
);
    wire video_on;
    wire[9:0] next_x, next_y;
    wire[9:0] x_t, y_t;
    reg clk_div2_r;
    reg [1:0] clk_div4_r;
    // reg [3:0] r_r, g_r, b_r;
    wire [3:0] r_t, g_t, b_t;

    //2 分频
    wire clk_div2;
    //4 分频
    wire clk_div4;


    always @(posedge clk) begin
        if (rst) begin
            clk_div2_r     <= 1'b0 ;
            clk_div4_r     <= 2'b0 ;
        end
        else begin
            clk_div2_r     <= ~clk_div2_r ;
            if (clk_div4_r == 2'b11) begin
                clk_div4_r <= 2'b0 ;
            end else begin
                clk_div4_r <= clk_div4_r + 1'b1 ;
            end
        end
    end
    assign clk_div2 = clk_div2_r ;
    assign clk_div4 = clk_div4_r[1] ^ clk_div4_r[0];


    VGA vga (
        .clk(clk_div2),
        // .clk_25MHZ(clk_div4),
        .reset(rst),
        .hsync(hsync_o),
        .vsync(vsync_o),
        .x_o(x_t),
        .y_o(y_t),
        .video_on(video_on)
    );

    // 在640*480模式下, 根据x_t, y_t计算当前像素的下一个像素的地址
    assign next_x = (x_t == 639) ? 0 : x_t + 1;
    assign next_y = (x_t == 639) ? (y_t == 479) ? 0 : y_t + 1 : y_t;

    // 根据next_x, next_y计算该像素在显存中的地址
    wire [16:0] addr;
    // assign addr = (next_y >>> 1) * 320 + next_x >>> 1;
    assign addr = next_y[9:1] * 320 + next_x[9:1];

    blk_mem_gen_2 vga_mem (
        .clka(clk),    // input wire clkb
        .ena(1'b1),      // input wire enb
        .wea(we_i),      // input wire [0 : 0] web
        .addra(addr_i),  // input wire [16 : 0] addrb
        .dina(wdata_i),    // input wire [11 : 0] dinb
        .douta(),  // output wire [11 : 0] doutb

        .clkb(clk),    // input wire clka
        .enb(1'b1),      // input wire ena
        .web(1'b0),      // input wire [0 : 0] wea
        .addrb(addr),  // input wire [16 : 0] addra
        .dinb(12'd0),    // input wire [11 : 0] dina
        .doutb({r_t, g_t, b_t})  // output wire [11 : 0] douta
    );


    assign r_o = (video_on) ? r_t : 4'b0;
    assign g_o = (video_on) ? g_t : 4'b0;
    assign b_o = (video_on) ? b_t : 4'b0;

endmodule