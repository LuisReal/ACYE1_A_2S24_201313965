

bubbleSort:
    LDR x0, =count
    LDR x0, [x0] // length => cantidad de numeros leidos del csv

    MOV x1, 0 // index i - bubble sort algorithm
    SUB x0, x0, 1 // length - 1

    bs_loop1:
        MOV x9, 0 // index j - bubble sort algorithm
        SUB x2, x0, x1 // length - 1 - i

        bs_loop2:
            LDR x3, =array
            LDRH w4, [x3, x9, LSL 1] // array[i]
            ADD x9, x9, 1
            LDRH w5, [x3, x9, LSL 1] // array[i + 1]

            CMP w4, w5
            BLT bs_cont_loop2

            STRH w4, [x3, x9, LSL 1]
            SUB x9, x9, 1
            STRH w5, [x3, x9, LSL 1]
            ADD x9, x9, 1

            bs_cont_loop2:
                CMP x9, x2
                BNE bs_loop2

        ADD x1, x1, 1
        CMP x1, x0
        BNE bs_loop1

        RET

