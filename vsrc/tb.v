`timescale 1ns/1ps

module tb_TestBench;

    reg clk;
    reg rst;

    always  begin
        clk = 0; #(5);
        clk = 1; #(5);
    end

    initial begin
        rst = 1;
        #50 rst = 0;
    end

    top top0(
        .clk(clk),
        .rst(rst)
    );

endmodule