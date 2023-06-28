.set noat
.text
    addi $0, $0, 1    # $0 = $0 + 1 (Add immediate) =? 0
    addi $1, $1, 2    # $1 = $1 + 2 (Add immediate) =? 2
    add $2, $0, $1    # $2 = $0 + $1 (Add)          =? 2
    add $3, $2, $1    # $3 = $2 + $1 (Add)          =? 4
    add $4, $3, $2    # $4 = $3 + $2 (Add)          =? 6
    add $5, $4, $3    # $5 = $4 + $3 (Add)          =? 10
    add $6, $5, $4    # $6 = $5 + $4 (Add)          =? 16
    add $7, $6, $5    # $7 = $6 + $5 (Add)          =? 26



