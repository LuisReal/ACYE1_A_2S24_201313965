p_import:  //proc_import
    ldr x0, =imp   //cmdimp
    ldr x1, =comando

    imp_loop:

        ldrb w2, [x0], 1
        ldrb w3, [x1], 1

        cbz w2, imp_filename

        cmp w2, w3
        bne imp_err

        b imp_loop

        imp_err:
            print errorImport, lenError
            b end_p_import

    imp_filename:

        ldr x0, =filename

        file_loop:
            ldrb w2, [x1], 1

            cmp w2, 32
            beq cont_file

            strb w2, [x0], 1
            b file_loop

        cont_file:
            strb wzr, [x0]
            ldr x0, =sep

            cont_loop:
                ldrb w2, [x0], 1
                ldrb w3, [x1], 1
                
                cbz w2, end_p_import
                b cont_loop

                cmp w2, w3
                bne imp_err

    end_p_import:
        ret


itoa2:
    
    mov x10, 0      // contador de digitos a imprimir
    mov x12, 0      // flag para indicar si hay signo menos

    cbz x0, i_zero

    mov x2, 1

    base:
        cmp x2, x0
        mov x5, 0
        bgt cont
        mov x5, 10
        mul x2, x2, x5
        B base

    cont:
        cmp x0, 0  // Numero a convertir
        bgt i_convertirAscii
        B i_negative

    i_zero:
        add x10, x10, 1
        mov w5, 48
        strb w5, [x1], 1
        B i_endConversion

    i_negative:
        mov  x12, 1
        mov w5, 45
        strb w5, [x1], 1
        neg x0, x0

    i_convertirAscii:
        cbz x2, i_endConversion
        udiv x3, x0, x2
        cbz x3, i_reduceBase

        mov w5, w3
        add w5, w5, 48
        strb w5, [x1], 1
        add x10, x10, 1

        mul x3, x3, x2
        sub x0, x0, x3

        cmp x2, 1
        ble i_endConversion

        i_reduceBase:
            mov x6, 10
            udiv x2, x2, x6

            cbnz x10, i_addZero
            B i_convertirAscii

        i_addZero:
            cbnz x3, i_convertirAscii
            add x10, x10, 1
            mov w5, 48
            strb w5, [x1], 1
            B i_convertirAscii

    i_endConversion:
        add x10, x10, x12
        print num, x10
        ret