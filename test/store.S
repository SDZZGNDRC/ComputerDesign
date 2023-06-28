.set noat

.data
var1: .word 0xff
var2: .word 0x11
var3: .word 0x22
var4: .word 0x33
var5: .word 0x44
var6: .word 0x55

.text
    lb      $1, 0x1000($0) # 读取4096, 载入$1
    addi    $1, $0, 0x11   # $1 = 0x11
    sb      $1, 0x1000($0) # mem(0x1000) = 0x11
    lb      $7, 0x1000($0) # 读取4096, 载入$7
