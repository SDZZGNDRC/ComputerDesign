//宏定义, 提高可读性

`define 	WIDTH        32 // 机器字长
`define     ADDR_WIDTH   16 // 地址宽度
`define     REG_WIDTH    3 // 寄存器地址宽度
`define     CU_STATE_WIDTH     4 // 控制单元状态位宽度

`define     CONST_ZERO  32'd0 // 0常数
`define     CONST_ONE   32'd1 // 1常数
`define     CONST_FOUR   32'd4 // 4常数

// 控制单元的状态标志
`define    CU_STATE_FETCH        4'b0000
`define    CU_STATE_DECODE       4'b0001
`define    CU_STATE_MEMADR       4'b0010
`define    CU_STATE_LBRD         4'b0011
`define    CU_STATE_LBWR         4'b0100
`define    CU_STATE_SBWR         4'b0101
`define    CU_STATE_R_TYPE_EX    4'b0110
`define    CU_STATE_R_TYPE_WR    4'b0111
`define    CU_STATE_BEQEX        4'b1000
`define    CU_STATE_JEX          4'b1001
`define    CU_STATE_ADDIEX       4'b1010

// 指令OP字段
`define    OP_ADDI         6'b001000
`define    OP_LB           6'b100000
`define    OP_SB           6'b101000
`define    OP_R_TYPE       6'b000000
`define    OP_BEQ          6'b000100
`define    OP_J            6'b000010
