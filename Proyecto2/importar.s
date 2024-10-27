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


imp_data:
    ldr x1, =filename
    stp x29, x30, [SP, -16]!
    bl openFile
    ldp x29, x30, [SP], 16

    ldr x25, =buffer
    mov x10, 0
    ldr x11, =fileDescriptor
    ldr x11, [x11]
    mov x17, 0 //contador de columnas
    ldr x15, =listIndex

    read_encabezado:
        read x11, character, 1
        ldr x4, =character
        ldrB w2, [x4]

        cmp w2, 44
        beq getIndex

        cmp w2, 10
        beq getIndex

        strb w2, [x25], 1
        add x10, x10, 1
        B read_encabezado

        getIndex:
            print getIndexMsg, lenGetIndexMsg
            print buffer, x10
            print dospuntos, lenDospuntos
            print espacio, lenEspacio

            ldr x4, =character
            ldrB w7, [x4]

            read 0, character, 2

            ldr x4, =character
            ldrB w2, [x4]
            sub w2, w2, 65
            
            strb w2, [x15], 1
            add x17, x17, 1

            cmp w7, 10
            beq end_header

            ldr x25, =buffer
            mov x10, 0
            B read_encabezado

        end_header:
            stp x29, x30, [SP, -16]!
            bl readCSV
            ldp x29, x30, [SP], 16

            ret

readCSV:
    ldr x10, =value
    ldr x11,  =fileDescriptor
    ldr x11, [x11]
    mov x21, 0  // contador de filas
    ldr x15, =listIndex // contador de columnas

    rd_num:
        read x11, character, 1
        ldr x4, =character
        ldrB w3, [x4]
        cmp w3, 44
        BEQ rd_cv_num

        cmp w3, 10
        BEQ rd_cv_num

        mov x25, x0
        CBZ x0, rd_cv_num

        STRB w3, [x10], 1   //x10 = value
        B rd_num

    rd_cv_num:
        ldr x5, =value
        ldr x8, =value

        stp x29, x30, [SP, -16]!

        bl atoi2

        ldp x29, x30, [SP], 16

        ldrB w16, [x15], 1 // obtener la columna
        
        adrp x20, tablero
        add  x20, x20, :lo12:tablero       // Sumar el offset para la dirección completa
        
        //ldr x20, =tablero
        mov x22, 11             //11 columnas de (A-K) (fer)
        mul x22, x21, x22       //x21 = 0 = contador filas
        add x22, x16, x22       //X16 =listIndex 
        str x9, [x20, x22, LSL 3]

        ldr x12, =value
        mov w13, 0
        mov x14, 0
        
        ldr x20, =listIndex
        sub x20, x15, x20
        cmp x20, x17
        bne cls_num
        
        ldr x15, =listIndex
        add x21, x21, 1

        cls_num:
            strb w13, [x12], 1
            add x14, x14, 1
            cmp x14, 7
            bne cls_num
            ldr x10, =value
            cbnz x25, rd_num

    rd_end:
        print salto, lenSalto
        print msgSuccess, lenMsgSuccess
        read 0, character, 2
        RET

openFile:
    // param: x1 => filename
    mov x0, -100
    mov x2, 0
    mov x8, 56
    svc 0

    cmp x0, 0
    ble op_f_error
    ldr x9, =fileDescriptor
    str x0, [x9]
    B op_f_end

    op_f_error:
        print errorOpenFile, lenErrOpenFile
        read 0, character, 2
    
    op_f_end:
        ret

closeFile:
    ldr x0, =fileDescriptor
    ldr x0, [x0]
    mov x8, 57
    svc 0
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
        print value, x10
        ret

atoi2:
    
    sub x5, x5, 1
    a_c_digits:
        ldrb w7, [x8], 1
        cbz w7, a_c_convert
        cmp w7, 10
        beq a_c_convert
        B a_c_digits

    a_c_convert:
        sub x8, x8, 2
        mov x4, 1
        mov x9, 0

        a_c_loop:
            ldrb w7, [x8], -1
            cmp w7, 45
            beq a_c_negative

            sub w7, w7, 48
            mul w7, w7, w4
            add w9, w9, w7

            mov w6, 10
            mul w4, w4, w6

            cmp x8, x5
            bne a_c_loop
            B a_c_end

        a_c_negative:
            neg w9, w9

        a_c_end:
            ret

