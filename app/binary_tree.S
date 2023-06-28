.set noat

.data
#        1
#       /  \
#     /      \
#    2        3
#   /  \     /  \
#  4    5   6    7
# 
# 节点1
n1_lp: .word 0x100c     # 左子树指针 0x1000
n1_rp: .word 0x1018     # 右子树指针
n1_ch: .word 0x0041     # 该节点的值 A

# 节点2
n2_lp: .word 0x1024     # 0x100c
n2_rp: .word 0x1030     
n2_ch: .word 0x0042     

# 节点3
n3_lp: .word 0x103c     # 0x1018
n3_rp: .word 0x1048     
n3_ch: .word 0x0043     

# 节点4
n4_lp: .word 0x0000     # 0x1024
n4_rp: .word 0x0000     
n4_ch: .word 0x0044     

# 节点5
n5_lp: .word 0x0000     # 0x1030
n5_rp: .word 0x0000     
n5_ch: .word 0x0045     

# 节点6
n6_lp: .word 0x0000     # 0x103c
n6_rp: .word 0x0000     
n6_ch: .word 0x0046     

# 节点6
n6_lp: .word 0x0000     # 0x1048
n6_rp: .word 0x0000     
n6_ch: .word 0x0047     


.text
# 开始对二叉树进行前序遍历
# 