# 该文件包含常用的函数, 如延时函数
.set noat

.text

DELAY_1MS:   # 延时1毫秒 (主频100MS)
    # 初始化
    addi    $4, $0, 0x0         # 初始化计数器
    addi    $5, $0, 0x37cb      # 循环次数, 经过实验检测, 这个参数刚好可以延时1ms, 
DELAY_1MS_START_1: 
    addi    $4, $4, 0x1         # 循环次数加1
    bne     $4, $5, DELAY_1MS_START_1

    # 结束
 