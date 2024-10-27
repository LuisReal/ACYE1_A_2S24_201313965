p_import:  //proc_import
    ldr x0, =imp   //cmdimp
    ldr x1, =comando

    imp_loop:

        ldrb w2, [x0], 1
        ldrb w3, [x1], 1

        cbz w2, imp_filename        //cuando llega al final (0)

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
            ldr x0, =sep        //"SEPARADO POR COMA"

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

    ldr x25, =buffer    //aqui se guardan los encabezados carnet tarea1 etc
    mov x10, 0
    ldr x11, =fileDescriptor
    ldr x11, [x11]
    mov x17, 0 //contador de columnas
    ldr x15, =listIndex

    read_encabezado://carnet	tarea1	tarea2	parcial1	tarea3(13=retorno de carro, 10=salto de linea)
        read x11, character, 1
        ldr x4, =character
        ldrb w2, [x4]

        cmp w2, 9           //datos separados por tabulador
        beq getIndex

        cmp w2, 10
        beq getIndex

        cmp w2, 13          //si w2 es igual a 13=retorno de carro, no lo agrega a buffer y continua al siguiente
        beq read_encabezado // la ultima columna del archivo csv trae un retorno de carro y hay que quitarlo

        strb w2, [x25], 1  // x25 = buffer que contiene carnet o tarea1 o tarea2 etc
        add x10, x10, 1     //cuenta el numero de caracteres de carnet o tarea1
        B read_encabezado

        getIndex:
            print getIndexMsg, lenGetIndexMsg   //"Ingrese la columna para el encabezado "
            print buffer, x10
            print dospuntos, lenDospuntos
            print espacio, lenEspacio

            ldr x4, =character      //contiene el tabulador 9 o salto de linea 10
            ldrb w7, [x4]

            read 0, character, 2    //ingresar columna por consola y lo guarda en caracter

            ldr x4, =character
            ldrb w2, [x4]
            sub w2, w2, 65          //compara con columna (A-K)
            
            strb w2, [x15], 1       //x15 = listIndex
            add x17, x17, 1         //contador de columnas

            cmp w7, 10
            beq end_header

            ldr x25, =buffer  
            mov x10, 0
            B read_encabezado

        end_header: //cuando termina de leer el encabezado: carnet tarea1 tarea2 etc salta a readCSV
            stp x29, x30, [SP, -16]!
            bl readCSV
            ldp x29, x30, [SP], 16

            ret

readCSV:
    ldr x10, =value             //"0000000000000"
    ldr x11,  =fileDescriptor
    ldr x11, [x11]
    mov x21, 0  // contador de filas
    ldr x15, =listIndex // (posicion de cada valor dentro de la celda no de la tabla) (fer)

    rd_num:
        read x11, character, 1      //200764749	23	88	99	50	43
        ldr x4, =character
        ldrb w3, [x4]
        cmp w3, 9           //datos separados por tabulador
        beq rd_cv_num

        cmp w3, 10
        beq rd_cv_num

        cmp w3, 13          // la ultima columna del archivo csv trae un retorno de carro y hay que quitarlo
        beq rd_num          // si w3 = 13 retorno de carro, no lo agrega a value y salta al siguiente caracter

        mov x25, x0         //x0 = "SEPARADO POR COMA"
        cbz x0, rd_cv_num

        strb w3, [x10], 1   //x10 = value //200764749	23	88	99	50	43
        B rd_num

    rd_cv_num:  //value = 200764749	23	88	99	50	43
        ldr x5, =value          //"0000000000000" tiene agregado un caracter nulo 0 al final son 14 bytes(el tamaño de value) y no 13
        ldr x8, =value

        stp x29, x30, [SP, -16]!

        bl atoi2                //aqui se usa x5 y x8

        ldp x29, x30, [SP], 16

        ldrb w16, [x15], 1         // obtener (posicion de cada valor dentro de la celda no de la tabla) (fer)

        /*
            aarch64-linux-gnu-as -mcpu=cortex-a57 main.s -o main.o
            aarch64-linux-gnu-ld main.o -o main
            qemu-aarch64 -g 1234 ./main

            gdb-multiarch -q --nh \
            -ex 'set architecture aarch64' \
            -ex 'file main' \
            -ex 'target remote localhost:1234' \
            -ex 'layout split' \
            -ex 'layout regs' 

            */
        
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
    
    sub x5, x5, 1    //x5 = direccion memoria de value (fer)
    a_c_digits://200764749
        ldrb w7, [x8], 1   //x8 = tambien es la direccion memoria de value (fer)
        
        cbz w7, a_c_convert //al final de x8(value) hay un caracter nulo 0

        cmp w7, 10
        beq a_c_convert

        B a_c_digits

    a_c_convert: //20076474 9
        sub x8, x8, 2
        mov x4, 1
        mov x9, 0

        a_c_loop:
            ldrb w7, [x8], -1   //20076474 9  despues de cargar el 9 retrocede 1 hacia 4
            
            cmp w7, 45          //si hay un signo menos
            beq a_c_negative

            sub x7, x7, 48      
            mul x7, x7, x4      
            add x9, x9, x7      

            mov x6, 10
            mul x4, x4, x6      

            cmp x8, x5
            bne a_c_loop
            B a_c_end

        a_c_negative:
            neg x9, x9

        a_c_end:
            ret
/* 

atoi:  

    sub x5, x5, 1
    contarDigitos:
        ldrb w1, [x12], 1      //x12 = num parametro 
        cbz w1, convertir
        cmp w1, 32              //32 = espacio  
        beq convertir
        cmp w1, 10
        beq convertir

        b contarDigitos

    convertir:
        sub x12, x12, 2         
        mov x4, 1               // Multiplicador
        mov x7, 0               // Resultado
        
    convertirChars:
        ldrb w1, [x12], -1
        cmp w1, 45
        beq negativeNum

        sub x1, x1, 48      //x1 = num
        mul x1, x1, x4
        add x7, x7, x1

        mov x6, 10
        mul x4, x4, x6
        
        cmp x12, x5
        bne convertirChars
        b endConvertir

    negativeNum:
        neg x7, x7

    endConvertir:
        str x7, [x8]            // 32 bits
    
    ret
*/