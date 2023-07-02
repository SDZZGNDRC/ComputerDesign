`timescale 1ns/1ps

module tb_TestBench;

    reg clk;
    reg rst;
    reg [3:0] btn;
    reg [11:0] sw;

    always  begin
        clk = 0; #(5);
        clk = 1; #(5);
    end

    initial begin
        rst = 1;
        btn = 4'b1111;
        sw = 12'hff0;
        #50 rst = 0;
        // #50 btn = 4'b1110;
        // #50 btn = 4'b1101;
        // #50 btn = 4'b1011;
        #1000 btn = 4'b0001;
    end

    top top0(
        .clk(clk),
        .rst(rst),
        .buttons_i(btn), // test for buttons
        .sw_i(sw) // test for switches
    );

endmodule