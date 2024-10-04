

bubbleSort:
    print conjuntoInicial, lenconjuntoInicial
    BL printArray
    write salto, lenSalto
    //BL copyArray
    //BL array_to_ascii
    
    BL reset_numPaso            // resetea el numero de pasos

    LDR x17, =count
    LDR x17, [x17] // length => cantidad de numeros leidos del csv

    MOV x18, 0 // index i - bubble sort algorithm
    SUB x17, x17, 1 // length - 1

    
    MOV x19, 0     //esto sera el contador de cada paso
    MOV x4, 0
    MOV x5,  0
    MOV x3,  0

    b_loop1:
        MOV x9, 0 // index j - bubble sort algorithm
        SUB x20, x17, x18 // length - 1 - i
        
        b_loop2:
            LDR x3, =array
            LDRH w4, [x3, x9, LSL 1] // array[i]  (el valor de x9 multiplicarlo por 2 y luego sumarlo a x3)
            ADD x9, x9, 1
            LDRH w5, [x3, x9, LSL 1] // array[i + 1]

            CMP w4, w5                  // si w4 es menor que w5
            BLT b_cont_loop2

            //aqui se hace el cambio
            
            STRH w4, [x3, x9, LSL 1]
            SUB x9, x9, 1
            STRH w5, [x3, x9, LSL 1]
            ADD x9, x9, 1

            
            ADD x19, x19, 1                 //se suma el contador de paso
            MOV x7, x19
            print paso, lenPaso             //imprime el texto Paso
            write paso, lenPaso
            ldr x10, =numPaso	            // load address of numPaso
            BL itoa3                        //convierte el contador x7 a ascii
            MOV x4, 8
            print numPaso, x4               //imprime el numero de paso
            BL printPaso
            MOV x4, x3
            write numPaso, x4
            print dosPuntos, lendosPuntos   //imprime el texto (:)
            write dosPuntos, lendosPuntos
            BL printArray                   //imprime el array cambiado
            write salto, lenSalto
            
            //read 0, opcion, 1             //presionar enter para continuar

            b_cont_loop2:
                CMP x9, x20                 // si x9 no es igual a x2
                BNE b_loop2


        ADD x18, x18, 1
        CMP x18, x17
        BNE b_loop1
        
        read 0, opcion, 1
        B printNewArray

printPaso:
    ldr x0, =numPaso
    mov x1, 8
    mov x2, 0

loop_paso:
    ldrb w5, [x0], 1
    add x2, x2, 1
    cmp x1, x2
    bne loop_paso
    ret

printNewArray:
    // recorrer array y convertir a ascii
    LDR x9, =count
    LDR x9, [x9] // length => cantidad de numeros leidos del csv
    MOV x7, 0
    LDR x15, =array

    loop_array:
        LDRH w0, [x15], 2
        LDR x1, =num
        BL itoa

        print espacio, lenEspacio

        ADD x7, x7, 1
        CMP x9, x7
        BNE loop_array

    print salto, lenSalto
    read 0, opcion, 1
    B menu


reset_numPaso:
    LDR x0, =numPaso       // Apuntar al inicio de numPaso
    MOV x3, 0           
    STR x3, [x0]   
    RET

 

copyArray:
    LDR x0, =count
    LDR x0, [x0] // length => cantidad de numeros leidos del csv
    ldr x1, =array
    ldr x2, =arrayAscii
    
    MOV x3, 0 

copyLoop:

    LDRH w4, [x1, x3, LSL 1]
    STRH w4, [x2, x3, LSL 1]

    ADD x3, x3, 1
    
    CMP x3, x0          // SI X3 != x0
    BNE copyLoop

    RET


array_to_ascii:
    LDR x0, =count
    LDR x0, [x0] // length => cantidad de numeros leidos del csv
    ldr x1, =arrayAscii
    MOV x8, 0
    LDR x10, =arrayAscii	// load address of arrayAscii

to_ascii_loop:

    LDRH w7, [x1, x8, LSL 1]
    ADD x8, x8, 1

    
    BL itoa3
    //ADD x10, x10, x3         //aumenta la direccion de memoria (x3 proviene de itoa3)

    CMP x8, x0              // SI X3 != x0
    BNE to_ascii_loop

    RET
    

   

/*
aarch64-linux-gnu-as -mcpu=cortex-a57 ordenamiento.s -o ordenamiento.o
aarch64-linux-gnu-ld ordenamiento.o -o ordenamiento
qemu-aarch64 -g 1234 ./ordenamiento

gdb-multiarch -q --nh \
  -ex 'set architecture aarch64' \
  -ex 'file ordenamiento' \
  -ex 'target remote localhost:1234' \
  -ex 'layout split' \
  -ex 'layout regs' 

*/
 

printArray:
    // recorrer array y convertir a ascii
    LDR x4, =count
    LDR x4, [x4] // length => cantidad de numeros leidos del csv
    MOV x16, 0
    LDR x15, =array

    loop_array2:
        LDRH w12, [x15], 2
        LDR x10, =num

        STP x29, x30, [SP, -16]!
        BL itoa2

        write num, x11
        write coma, lenComa
        LDP x29, x30, [SP], 16

        print espacio, lenEspacio
        //write espacio, lenEspacio

        ADD x16, x16, 1
        CMP x4, x16
        BNE loop_array2

    print salto, lenSalto
    RET

itoa2: //integer a ascii
    // params: x0 => number, x1 => buffer address
    MOV x5,  0
    MOV x3,  0
    MOV x11, 0  // contador de digitos a imprimir
    MOV x13, 0  // flag para indicar si hay signo menos
    MOV w14, 10000  // Base 10
    CMP w12, 0  // Numero a convertir
    BGT i_convertirAscii2
    CBZ w12, i_zero2

    B i_negative2

    i_zero2:
        ADD x11, x11, 1
        MOV w5, 48
        STRB w5, [x10], 1
        B i_endConversion2

    i_negative2:
        MOV  x13, 1
        MOV w5, 45
        STRB w5, [x10], 1
        NEG w12, w12

    i_convertirAscii2:
        CBZ w14, i_endConversion2
        UDIV w3, w12, w14
        CBZ w3, i_reduceBase2

        MOV w5, w3
        ADD w5, w5, 48
        STRB w5, [x10], 1
        ADD x11, x11, 1

        MUL w3, w3, w14
        SUB w12, w12, w3

        CMP w14, 1
        BLE i_endConversion2

        i_reduceBase2:
            MOV w6, 10
            UDIV w14, w14, w6

            CBNZ w11, i_addZero2
            B i_convertirAscii2

        i_addZero2:
            CBNZ w3, i_convertirAscii2
            ADD x11, x11, 1
            MOV w5, 48
            STRB w5, [x10], 1
            B i_convertirAscii2

    i_endConversion2:
        ADD x11, x11, x13
        print num, x11
        RET

itoa3: //convierte de integer a ascii
    
    mov x11, x7			// number to convert
    mov x12, 10		    // base number
    mov x3, 0		    // number size = 0
    mov x4, x11		    // copy of number

    getsizeString:
        udiv x4, x4, x12		// remove last digit
        add x3, x3, 1		    // increment size  (siguiente posicion)
        cmp x4, 0		        // if number != 0  (fin de cadena)
        bne getsizeString		// goto getsize
        
        add x10, x10, x3		// str addr offset
        //mov w5, 10		    // newline ascii
        //strb w5, [x10]		// store newline
        sub x10, x10, 1		    // decrement offset
        //add x3, x3, 1		    // str final size
        mov x4, x11		        // copy of number 
        mov x5, 0		        // iter number = 0
        
    getdigit:
        udiv x6, x4, x12		// remove last digit	
        msub x7, x6, x12, x4	// last digit
        add x5, x5, 1		    // increment iter
        strb w7, [x10]		    // store last digit
        sub x10, x10, 1		    // decrement offset
        mov x4, x6		        // number remain
        cmp x4, 0		        // if number != 0
        bne getdigit		    // goto getdigit
        add x10, x10, 1		    // reset addrgdb-multiarch -q --nh \


    setascii:	
        ldrb w13, [x10]		// load left digit(carga de la memoria al registro)
        add w13, w13, 48		// set ascii
        strb w13, [x10]		// store ascii
        add x10, x10, 1		// increment offset
        sub x5, x5, 1		// decrement iter
        cmp x5, 0		    // if iter != 0
        bne setascii		// goto setascii
        ret
