.set noat
.text
    addi $0, $0, 1    # $0 = $0 + 1 (Add immediate) =? 0
    addi $1, $1, 1    # $1 = $1 + 2 (Add immediate) =? 1
    addi $2, $1, 1    # $2 = $1 + 1 (Add immediate) =? 2
    sub $3, $2, $1    # $3 = $2 - $1 (Subtract)     =? 1
    sub $4, $3, $2    # $4 = $3 - $2 (Subtract)     =? -1
    sub $5, $4, $3    # $5 = $4 - $3 (Subtract)     =? -2
    sub $6, $5, $2    # $6 = $5 - $2 (Subtract)     =? -4
    sub $7, $6, $2    # $7 = $6 - $2 (Subtract)     =? -6
