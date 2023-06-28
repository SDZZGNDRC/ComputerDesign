.set noat

.text
    addi    $1, $0, 0x64        # 最大循环次数
    addi    $2, $0, 0x0         # 当前循环次数
    addi    $3, $0, 0x1         # 初始值

START:  # 循环开始
    addi    $2, $2, 0x1         # 循环次数加 1
    add     $3, $2, $3          # 累加
    bne     $2, $1, START       # 判断是否达到最大循环次数, 否则继续累加

    # 结束累加
    sb      $3, 0x1000($0)      # 保存结果

EXIT:   # 阻塞停机
    j       EXIT
