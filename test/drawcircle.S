.data
vga_start: .word 0xfff00000
vga_end: .word 0xfff4b000

.text
    # 初始化堆栈指针寄存器
    addi    $29, $0, 0x1ffc

    addi    $2, $0, 0x1234
    sb      $2, 0xfff0($0)      # 载入MEM[0xfffffff0]
    addi    $2, $0, 0xf
    sb      $2, 0xfff4($0)      # 载入MEM[0xfffffff0]

    addi    $8, $0, 0xa0       # 圆心x坐标
    sb      $8, 0x1008($0)
    addi    $9, $0, 0x78       # 圆心y坐标
    sb      $9, 0x100c($0)
    addi    $10, $0, 0x64       # 半径
    sb      $10, 0x1010($0)

    addi    $18, $0, 0xff0      # 前景色
    addi    $19, $0, 0xf0f      # 后景色

    addi    $16, $0, 0x0        # 当前x坐标
    addi    $17, $0, 0x0        # 当前y坐标

NEXT_PIXEL:
    addi    $4, $16, 0x0
    addi    $5, $17, 0x0
    lra     MAIN_INTERNAL_1
    j       IN_CYCLE
MAIN_INTERNAL_1:
    beq     $2, $0, MAIN_INTERNAL_2 # 不在圆内, 绘制后景色
    j       MAIN_INTERNAL_3         # 在圆内, 绘制前景色
MAIN_INTERNAL_2:
    addi    $8, $19, 0x0
    # 计算像素在显存中的地址, addr = y * 320 + x
    addi    $9, $0, 0x140
    mul     $9, $17, $9
    add     $9, $9, $16
    addi    $10, $0, 0x4
    mul     $9, $9, $10
    lb      $10, 0x1000($0)     # 起始地址
    add     $10, $10, $9

    sb      $8, 0x0($10)
    j       MAIN_INTERNAL_4

MAIN_INTERNAL_3: 
    addi    $8, $18, 0x0
    # 计算像素在显存中的地址, addr = y * 320 + x
    addi    $9, $0, 0x140
    mul     $9, $17, $9
    add     $9, $9, $16
    addi    $10, $0, 0x4
    mul     $9, $9, $10
    lb      $10, 0x1000($0)     # 起始地址
    add     $10, $10, $9

    sb      $8, 0x0($10)
    j       MAIN_INTERNAL_4

MAIN_INTERNAL_4:
    # 修改像素坐标
    addi    $8, $0, 0x13f
    beq     $16, $8, MAIN_INTERNAL_5
    addi    $16, $16, 0x1
    j       NEXT_PIXEL

MAIN_INTERNAL_5:
    addi    $16, $0, 0x0
    j       MAIN_INTERNAL_6

MAIN_INTERNAL_6:
    addi    $8, $0, 0xef
    beq     $17, $8, MAIN_INTERNAL_7
    addi    $17, $17, 0x1
    j       NEXT_PIXEL

MAIN_INTERNAL_7:
    addi    $17, $0, 0x0
    j       NEXT_PIXEL


HALT:
    j       HALT

IN_CYCLE:
    # 判断给定坐标是否在圆周上
    # $4: x, $5: y
    # $2: 返回值

    # 保存现场
    addi    $29, $29, 0xfffc    # $sp-4
    sb      $31, 0x0($29)       # 保存$31

    lb      $8, 0x1008($0)      # 获取圆心x坐标
    sub     $8, $4, $8
    mul     $8, $8, $8          # 计算(x-x0)*(x-x0)

    lb      $9, 0x100c($0)      # 获取圆心y坐标
    sub     $9, $5, $9
    mul     $9, $9, $9          # 计算(y-y0)*(y-y0)

    lb      $10, 0x1010($0)     # 获取半径r
    mul     $10, $10, $10       # 计算r*r

    add     $11, $8, $9         # 计算(x-x0)*(x-x0)+(y-y0)*(y-y0)
    addi    $12, $0, 0x0
    slt     $12, $11, $10       # 
    beq     $12, $0, ON_CYCLE_INTERNAL_1 # 不在圆内
    j       ON_CYCLE_INTERNAL_2 # 在圆内

ON_CYCLE_INTERNAL_1:
    addi    $2, $0, 0x0
    j       ON_CYCLE_INTERNAL_3

ON_CYCLE_INTERNAL_2:
    addi    $2, $0, 0x1
    j       ON_CYCLE_INTERNAL_3

ON_CYCLE_INTERNAL_3:
    # 恢复现场
    lb      $31, 0x0($29)
    addi    $29, $29, 0x4

    jr       $31



