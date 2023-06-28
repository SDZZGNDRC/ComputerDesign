.set noat
.text
    addi $0, $0, 1    # $0 = $0 + 1 (Add immediate) =? 0
    addi $1, $1, 1    # $1 = $1 + 1 (Add immediate) =? 1
    addi $2, $1, 2    # $2 = $1 + 2 (Add immediate) =? 3
    and $3, $2, $1    # $3 = $2 AND $1 (Bitwise AND) =? 1
    addi $1, $1, 1    # $1 = $1 + 1 (Add immediate) =? 2
    and $4, $2, $1    # $4 = $2 AND $1 (Bitwise AND) =? 2
