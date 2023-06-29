.text
    # 初始化堆栈指针寄存器
    addi    $29, $0, 0x1ffc

    # 数码管初始化
    addi    $6, $0, 0x0
    sb      $6, 0xfff0($0)      # 设置数码管的值为0
    addi    $1, $0, 0xf         # 
    sb      $1, 0xfff4($0)      # 四个数码管全亮

WAIT:
    lb      $7, 0xfff8($0)      # 读取按键值
    beq     $7, $0, WAIT        # 继续读取按键值

    # 延时 20 毫秒
    addi    $4, $0, 0x14
    lra     MAIN_INTERNAL_1     # 设置返回地址
    j       DELAY_N_MS
MAIN_INTERNAL_1:

    # 重新读取按键值, 并判断按键是否按下
    lb      $7, 0xfff8($0)      # 读取按键值
    addi    $5, $0, 0x1         # 只有一个按键被按下
    bne     $7, $5, WAIT        # 继续读取按键值

    # 计数器加一
    addi    $6, $6, 0x1
    sb      $6, 0xfff0($0)      # 设置数码管的值

    # 延时 100 毫秒, 等待按键恢复
    addi    $4, $0, 0x64
    lra     MAIN_INTERNAL_2     # 设置返回地址
    j       DELAY_N_MS
MAIN_INTERNAL_2:

    j       WAIT


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

