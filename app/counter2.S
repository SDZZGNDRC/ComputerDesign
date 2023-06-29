.text
    # 初始化堆栈指针寄存器
    addi    $29, $0, 0x1ffc

    addi    $7, $0, 0x1         # 计数器, 初始值为1

    sb      $7, 0xfff0($0)      # 设置数码管的值为1
    addi    $1, $0, 0xf         # 
    sb      $1, 0xfff4($0)      # 四个数码管全亮

CYCLE:
    addi    $4, $0, 0x37cb
    lra     MAIN_INTERNAL_2     # 设置返回地址
    j       DELAY_N_MS
MAIN_INTERNAL_2:
    # 数码管加1
    addi    $7, $7, 0x1
    sb      $7, 0xfff0($0)

    j       CYCLE


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