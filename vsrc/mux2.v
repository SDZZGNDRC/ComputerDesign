// 2路复选器
module MUX2 # (parameter WIDTH = 32)(
    input [WIDTH - 1 : 0] d0,
    input [WIDTH - 1 : 0] d1,
    input sel,
    output [WIDTH - 1 : 0] y
);
    assign y = sel ? d1 : d0;
endmodule