# 从1数到100

.text
    # 初始化
    addi    $7, $0, 0x1         # 计数器, 初始值为1
    addi    $4, $0, 0x37cb      # 延时1毫秒所需的参数
    addi    $5, $0, 0x0         # 内层延时
    addi    $2, $0, 0x03eb      # 1000次延时1ms
    addi    $3, $0, 0x0         # 外层延时

    sb      $7, 0xfff0($0)      # 设置数码管的值为1
    addi    $1, $0, 0xf         # 
    sb      $1, 0xfff4($0)      # 四个数码管全亮

CYCLE:
    # 开始外层延时
DELAY_1S: 
    # 开始内层延时
DELAY_1MS:
    addi    $5, $5, 0x1         # 加1
    bne     $5, $4, DELAY_1MS 

    # 内层延时结束
    addi    $5, $0, 0x0         # 复位内层计数器
    addi    $3, $3, 0x1         # 外层延时加1
    bne     $3, $2, DELAY_1S

    # 数码管加1
    addi    $7, $7, 0x1
    sb      $7, 0xfff0($0)
    addi    $3, $0, 0x0         # 复位外层计数器

    j       CYCLE