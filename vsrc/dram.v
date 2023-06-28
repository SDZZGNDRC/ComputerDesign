// 数据存储器
module DRAM(
    input clk,
    
    input wire wea_i,
    input wire [`ADDR_WIDTH-1:0] addra_i,
    input wire [`WIDTH-1:0] dina_i,

    output wire [`WIDTH-1:0] douta_o
);

    blk_mem_gen_1 dram (
        .clka(clk),    // input wire clka
        .ena(1'b1),      // input wire ena
        .wea(wea_i),      // input wire [0 : 0] wea
        .addra(addra_i),  // input wire [11 : 0] addra
        .dina(dina_i),    // input wire [31 : 0] dina
        .douta(douta_o)  // output wire [31 : 0] douta
    );

endmodule