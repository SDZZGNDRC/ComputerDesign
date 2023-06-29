.text
    # 初始化堆栈指针寄存器
    addi    $29, $0, 0x1ffc

    addi    $8, $0, 0x0
    addi    $9, $0, 0x0
MAIN_INTERNAL_1:
    lra     MAIN_INTERNAL_2
    j       FUNC1
MAIN_INTERNAL_2:
    j       MAIN_INTERNAL_1



FUNC1:
    addi    $29, $29, 0xfffc    # $sp-4
    sb      $31, 0x0($29)       # 保存返回地址

    addi    $8, $8, 0x1
    lra     FUNC1_INTERNAL_1
    j       FUNC2
FUNC1_INTERNAL_1:

    # 执行结束, 恢复$ra
    lb      $31, 0x0($29)
    addi    $29, $29, 0x4
    jr      $31

FUNC2:
    addi    $9, $9, 0x1

    jr      $31 
