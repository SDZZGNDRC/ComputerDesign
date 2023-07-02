.set noat

.data
#        1
#       /  \
#     /      \
#    2        3
#   /  \     /  \
#  4    5   6    7
# 
# 
# 前序遍历为: 1->2->4->5->3->6->7
# 
# 节点1
n1_lp: .word 0x100c     # 左子树指针 0x1000
n1_rp: .word 0x1018     # 右子树指针
n1_ch: .word 0x0001     # 该节点的值 1

# 节点2
n2_lp: .word 0x1024     # 0x100c
n2_rp: .word 0x1030     
n2_ch: .word 0x0002     

# 节点3
n3_lp: .word 0x103c     # 0x1018
n3_rp: .word 0x1048     
n3_ch: .word 0x0003     

# 节点4
n4_lp: .word 0x0000     # 0x1024
n4_rp: .word 0x0000     
n4_ch: .word 0x0004     

# 节点5
n5_lp: .word 0x0000     # 0x1030
n5_rp: .word 0x0000     
n5_ch: .word 0x0005     

# 节点6
n6_lp: .word 0x0000     # 0x103c
n6_rp: .word 0x0000     
n6_ch: .word 0x0006     

# 节点7
n6_lp: .word 0x0000     # 0x1048
n6_rp: .word 0x0000     
n6_ch: .word 0x0007     


.text
# 开始对二叉树进行前序遍历
    # 初始化堆栈指针寄存器
    addi    $29, $0, 0x1ffc

    # 初始化
    addi        $30, $30, 0x0           # 用于debug
    addi        $1, $0, 0x1000          # 根节点的地址
    addi        $28, $0, 0x1054         # 数组首地址
    addi        $27, $28, 0x18          # 数组尾地址

    addi        $4, $1, 0x0             # 根节点的地址
    addi        $5, $28, 0x0
    lra         MAIN_INTERNAL_1
    j           PREORDER 
MAIN_INTERNAL_1:

    # 设置数码管, 显示"PRE", 由于数码管难以显示R, 用A代替.

    addi    $24, $0, 0xfae0
    sb      $24, 0xfff0($0)      # 载入MEM[0xfffffff0]
    addi    $24, $0, 0xe
    sb      $24, 0xfff4($0)

    # 读取按键, 等待开始
WAIT:
    lb      $24, 0xfff8($0)      # 读取按键值
    beq     $24, $0, WAIT        # 继续读取按键值

    # 延时 20 毫秒
    addi    $4, $0, 0x14
    lra     MAIN_INTERNAL_3     # 设置返回地址
    j       DELAY_N_MS
MAIN_INTERNAL_3:

    # 重新读取按键值, 并判断按键是否按下
    lb      $24, 0xfff8($0)      # 读取按键值
    addi    $25, $0, 0x1         # 只有一个按键被按下
    bne     $24, $25, WAIT        # 继续读取按键值

    # 延时 200 毫秒
    addi    $4, $0, 0xcb
    lra     MAIN_INTERNAL_35     # 设置返回地址
    j       DELAY_N_MS
MAIN_INTERNAL_35:

    # 开始显示
    addi    $24, $28, 0x0        # 从第一个元素开始显示
    lb      $25, 0x0($24)
    sb      $25, 0xfff0($0)
    addi    $25, $0, 0xf
    sb      $25, 0xfff4($0)     # 设置数码管的位数

CYCLE:
    lb      $8, 0xfff8($0)      # 读取按键值
    beq     $8, $0, CYCLE        # 继续读取按键值

    # 延时 20 毫秒
    addi    $4, $0, 0x14
    lra     MAIN_INTERNAL_4     # 设置返回地址
    j       DELAY_N_MS
MAIN_INTERNAL_4:

    # 重新读取按键值, 并判断按键是否按下
    lb      $8, 0xfff8($0)      # 读取按键值
    addi    $5, $0, 0x1         # 第一个按键被按下
    beq     $8, $5, NEXT_ELE    # 显示下一个元素
    addi    $5, $0, 0x8         # 最后一个按键被按下
    beq     $8, $5, LAST_ELE    # 显示上一个元素
    j       MAIN_INTERNAL_5

NEXT_ELE: 
    beq     $24, $27, MAIN_INTERNAL_5     # 到达最后一个元素, 操作无效
    addi    $24, $24, 0x4
    lb      $25, 0x0($24)
    sb      $25, 0xfff0($0)
    j       MAIN_INTERNAL_5


LAST_ELE:
    beq     $24, $28, MAIN_INTERNAL_5     # 到达第一个元素, 操作无效
    addi    $24, $24, 0xfffc    #
    lb      $25, 0x0($24)
    sb      $25, 0xfff0($0)
    j       MAIN_INTERNAL_5

MAIN_INTERNAL_5: 
    # 延时 200 毫秒, 等待按键恢复
    addi    $4, $0, 0xcb
    lra     MAIN_INTERNAL_6     # 设置返回地址
    j       DELAY_N_MS
MAIN_INTERNAL_6:
    j       CYCLE

HALT:
    j           HALT    # 停机阻塞


PREORDER:   # 函数
    # 采用递归实现前序遍历, $4 存放头节点地址, $5 存放数组的下一个位置的地址
    
    # 保存现场
    addi    $30, $30, 0x1       # 用于debug
    addi    $29, $29, 0xfffc    # $sp-4
    sb      $31, 0x0($29)       # 保存$31
    addi    $29, $29, 0xfffc    # $sp-4
    sb      $16, 0x0($29)        # 保存$16


    # 保存当前节点的地址
    addi    $16, $4, 0x0

    # 访问当前节点的值, 将其存入指定位置
    lb      $8, 0x8($16)         # 将值读入$8
    sb      $8, 0x0($5)         # 将值存入数组
    addi    $5, $5, 0x4         # 指向数组的下一个位置
    
    # 如果当前节点存在左子树, 则进行递归遍历
    lb      $8, 0x0($16)
    beq     $8, $0, PREORDER_INTERNAL_1 # 地址为0, 不存在左子节点
    
    # 调用PREORDER, 遍历左子节点
    addi    $4, $8, 0x0         # 传入参数: 左子树的地址
    lra     PREORDER_INTERNAL_1 # 设置返回地址
    j       PREORDER

PREORDER_INTERNAL_1:

    # 如果当前节点存在右子树, 则进行递归遍历
    lb      $8, 0x4($16)
    beq     $8, $0, PREORDER_INTERNAL_2 # 地址为0, 不存在右子节点
    
    # 调用PREORDER, 遍历右子节点
    addi    $4, $8, 0x0         # 传入参数: 左子树的地址
    lra     PREORDER_INTERNAL_2 # 设置返回地址
    j       PREORDER
PREORDER_INTERNAL_2:

    # 结束, 恢复现场
    lb      $16, 0x0($29)
    addi    $29, $29, 0x4
    lb      $31, 0x0($29)
    addi    $29, $29, 0x4
    addi    $30, $30, 0xffff       # 用于debug

    jr      $31     # 函数结束, 返回

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




