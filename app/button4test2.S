.text
    # 数码管初始化
    addi    $6, $0, 0x0
    sb      $6, 0xfff0($0)      # 设置数码管的值为0
    addi    $1, $0, 0xf         # 
    sb      $1, 0xfff4($0)      # 四个数码管全亮

WAIT:
    lb      $7, 0xfff8($0)      # 读取按键值
    sb      $7, 0xfff0($0)      # 设置数码管的值

    j       WAIT



