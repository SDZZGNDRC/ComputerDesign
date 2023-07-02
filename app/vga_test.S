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



CYCLE:

    lb      $24, 0xfff8($0)      # 读取按键值
    beq     $24, $0, CYCLE        # 继续读取按键值

    # 延时 20 毫秒
    addi    $4, $0, 0x14
    lra     MAIN_INTERNAL_1     # 设置返回地址
    j       DELAY_N_MS
MAIN_INTERNAL_1:
    # 重新读取按键值, 并判断按键是否按下
    lb      $24, 0xfff8($0)      # 读取按键值
    addi    $25, $0, 0x1         # 只有一个按键被按下
    bne     $24, $25, CYCLE        # 继续读取按键值

    # 开始渲染VGA
    lb      $24, 0xfffc($0)      # 读取拨码开关的值

    sb      $24, 0xfff0($0)

    addi    $4, $24, 0x0
    lra     CYCLE
    j       VGA_DRAW

HALT:
    j       HALT



VGA_DRAW:
    # 填充显存, $4 存放像素值

    # 保存现场
    addi    $29, $29, 0xfffc    # $sp-4
    sb      $31, 0x0($29)       # 保存$31

    lb      $8, 0x1000($0)      # vga显存的起始地址
    lb      $9, 0x1004($0)      # vga显存的结束地址
    addi    $10, $8, 0x0        # 当前需要填充的像素地址

VGA_DRAW_INTERNAL_1:
    sb      $4, 0x0($10)
    addi    $10, $10, 0x4

    bne     $10, $9, VGA_DRAW_INTERNAL_1

    # 恢复现场
    lb      $31, 0x0($29)
    addi    $29, $29, 0x4

    jr      $31

DELAY_N_MS:
    # 延时 $a0($4) 毫秒
    addi    $29, $29, 0xfffc    # $sp-4
    sb      $31, 0x0($29)       # 保存返回地址

    addi    $16, $0, 0x0        # 初始化循环次数
DELAY_N_MS_INTERNAL_1:
    lra     DELAY_N_MS_INTERNAL_2 # 伪指令, 保存返回地址
    j       DELAY_1MS
DELAY_N_MS_INTERNAL_2:
    addi    $16, $16, 0x1       # 循环次数加 1
    bne     $16, $4, DELAY_N_MS_INTERNAL_1

    # 执行结束, 恢复$ra
    lb      $31, 0x0($29)
    addi    $29, $29, 0x4
    jr      $31

DELAY_1MS:
    addi    $8, $0, 0x37cb
    addi    $9, $0, 0x0
DELAY_1MS_INTERNAL:
    addi    $9, $9, 0x1         # 加1
    bne     $9, $8, DELAY_1MS_INTERNAL

    # 延时结束, 返回
    jr      $31 
