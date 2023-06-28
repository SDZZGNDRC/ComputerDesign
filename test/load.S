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
    lb      $2, 0x1004($0) # 读取4100, 载入$2
    lb      $3, 0x1008($0) # 读取4100, 载入$2
    lb      $4, 0x100c($0) # 读取4100, 载入$2
    lb      $5, 0x1010($0) # 读取4100, 载入$2
    lb      $6, 0x1014($0) # 读取4100, 载入$2
