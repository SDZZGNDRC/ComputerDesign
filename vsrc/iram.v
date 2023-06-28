// 指令存储器
module IROM(
    input clk,

    input wire [`ADDR_WIDTH-1:0] addr_i,

    output wire [`WIDTH-1:0] data_o
);

    blk_mem_gen_0 irom (
        .clka(clk),    // input wire clka
        .ena(1'b1),      // input wire ena
        .addra(addr_i[13:2]),  // input wire [11 : 0] addra
        .douta(data_o)  // output wire [31 : 0] douta
    );

endmodule