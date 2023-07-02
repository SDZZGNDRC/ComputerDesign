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

    lb          $1, 0x1054($0)
    lb          $2, 0x1058($0)
    lb          $3, 0x105c($0)
    lb          $4, 0x1060($0)
    lb          $5, 0x1064($0)
    lb          $6, 0x1068($0)
    lb          $7, 0x106c($0)

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




