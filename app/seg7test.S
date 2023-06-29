# .set noat

.text
    # 1,2,3,4 => 0001_0010_0011_0100 => 0x1234
    addi    $2, $0, 0x1234
    sb      $2, 0xfff0($0)      # 载入MEM[0xfffffff0]
    addi    $3, $0, 0xf
    sb      $3, 0xfff4($0)

    # 阻塞停机
HALT: 
    j       HALT
