

bubbleSortAscendente:
    print conjuntoInicial, lenconjuntoInicial
    write conjuntoInicial, lenconjuntoInicial
    BL printArray
    write salto, lenSalto
    write salto, lenSalto
    write msgBubble, lenmsgBubble
    write msgAscendente, lenmsgAscendente
    write salto, lenSalto
    
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


bubbleSortDescendente:
    print conjuntoInicial, lenconjuntoInicial
    write conjuntoInicial, lenconjuntoInicial
    BL printArray
    write salto, lenSalto
    write salto, lenSalto
    write msgBubble, lenmsgBubble
    write msgDescendente, lenmsgDescendente
    write salto, lenSalto
    
    BL reset_numPaso            // resetea el numero de pasos

    LDR x17, =count
    LDR x17, [x17] // length => cantidad de numeros leidos del csv

    MOV x18, 0 // index i - bubble sort algorithm
    SUB x17, x17, 1 // length - 1

    
    MOV x19, 0     //esto sera el contador de cada paso
    MOV x4, 0
    MOV x5,  0
    MOV x3,  0

    bsd_loop1:
        MOV x9, 0 // index j - bubble sort algorithm
        SUB x20, x17, x18 // length[array]-1
        
        bsd_loop2:
            LDR x3, =array
            LDRH w4, [x3, x9, LSL 1] // array[i]  (el valor de x9 multiplicarlo por 2 y luego sumarlo a x3)
            ADD x9, x9, 1
            LDRH w5, [x3, x9, LSL 1] // array[i + 1]

            CMP w4, w5                  // si w4 es menor que w5
            BGT bsd_cont_loop2

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

            bsd_cont_loop2:
                CMP x9, x20                 // si x9 no es igual a x2
                BNE bsd_loop2


        ADD x18, x18, 1
        CMP x18, x17                        // si x18 no es igual a x17
        BNE bsd_loop1
        
        read 0, opcion, 1
        B printNewArray
/*
LDR x0, =array          
LDR x1, =count         
LDR x1, [x1]            
SUB x2, x1, 1           
MOV x1, 0          
*/     
quickSort:  
    //x1 y x2 fueron configurados desde ordenamiento.s
    CMP x1, x2              // Si low >= high, regresa
    BGE qs_end 

    STP x1, x2, [sp, -16]!  
    BL particion            // Llama a la función partition
    LDP x1, x2, [sp], 16   

    MOV x3, x0              // Mover el índice de partición a x3

    // Ordenar la parte izquierda
    SUB x2, x3, 1           // high = p - 1
    STP x0, x2, [sp, #-16]! // Guardar base y high
    BL quickSort            // Llamar recursivamente quickSort(base, low, p - 1)
    LDP x0, x2, [sp], #16   // Recuperar base y high

    // Ordenar la parte derecha
    ADD x1, x3, 1           // low = p + 1
    STP x1, x2, [sp, #-16]! // Guardar low y high
    BL quickSort            // Llamar recursivamente quickSort(base, p + 1, high)
    LDP x1, x2, [sp], #16   // Recuperar low y high

qs_end:
    BL printArray
    B menu
    

particion:

    LDR x3, =array         
    LDRH w4, [x3, x2, LSL 1]    // pivote (w4) se toma como pivote siempre el ultimo elemento
    SUB x5, x1, 1               // i = low - 1 (x5 almacena 'i')
    MOV x6, x1                  // j = low (x6 almacena 'j') 

particion_loop:
    CMP x6, x2                  // Mientras j >= high(x6>=x2)
    BGT particion_done

    LDRH w7, [x3, x6, LSL 1]    // Leer array[j] en w7

    CMP w7, w4                  // Comparar array[j] con el pivote
    BGT particion_saltar        // Si array[j] > pivote, continuar

    ADD x5, x5, 1               // i++
    LDRH w8, [x3, x5, LSL 1]    // Intercambiar array[i] con array[j]

    //CMP x5, x6              
    //BEQ particion_saltar

    STRH w8, [x3, x6, LSL 1]
    STRH w7, [x3, x5, LSL 1]  

particion_saltar:
    ADD x6, x6, 1               // j++
    B particion_loop            // Repetir el ciclo

particion_done:
    ADD x5, x5, 1               // i++
    LDRH w7, [x3, x5, LSL 1]    // Intercambiar array[i] con array[high]
    LDRH w8, [x3, x2, LSL 1]
    STRH w8, [x3, x5, LSL 1]
    STRH w7, [x3, x2, LSL 1]

    MOV x0, x5                  // Regresar el índice de partición (pivote final)
    RET




insertionSortAscendente:

    print conjuntoInicial, lenconjuntoInicial
    write conjuntoInicial, lenconjuntoInicial
    BL printArray
    write salto, lenSalto
    write salto, lenSalto
    write msgInsertion, lenmsgInsertion
    write msgAscendente, lenmsgAscendente
    write salto, lenSalto
    
    BL reset_numPaso            // resetea el numero de pasos
    MOV x19, 0                  // inicia el contador de paso

    LDR x9, =count    
    LDR x9, [x9]                    //n  = arr.length
    LDR x17, =array          
    MOV x18, 1                       //int (i)

loop_1:
    //i < n
    CMP x18, x9
    BGE end_loop                    //  x2 >= x0
    
    LDRH w21, [x17, x18, LSL 1]        //  key = arr[i];
    
    SUB x20, x18, 1                   //  j = i - 1;
    
//x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20

loop_2:
    LDRH w22, [x17, x20, LSL 1]        //  arr[j]

    CMP x20, 0                       // Comparar x3 con 0
    BLT insert_element              // Si x3 < 0, salir del bucle

    CMP w22, w21                      // Comparar w5 con w4
    BLE insert_element              // Si w5 <= w4, salir del bucle

    //arr[j + 1] = arr[j];
    ADD x20, x20, 1                   //incremente j temporalmente
    STRH w22, [x17, x20, LSL 1]
    SUB x20, x20, 1                   //decrementa j temporalmente

    SUB x20, x20, 1 //j = j - 1;      //decrementa j permanentemente

    B loop_2

insert_element:
    //arr[j + 1] = key;
    ADD x20, x20, 1
    STRH w21, [x17, x20, LSL 1]
    SUB x20, x20, 1

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

    ADD x18, x18, 1                   //incrementar i = i+1
    B loop_1

end_loop:
    BL printNewArray
    input
    B menu


insertionSortDescendente:

    print conjuntoInicial, lenconjuntoInicial
    write conjuntoInicial, lenconjuntoInicial
    BL printArray
    write salto, lenSalto
    write salto, lenSalto
    write msgInsertion, lenmsgInsertion
    write msgDescendente, lenmsgDescendente
    write salto, lenSalto
    
    BL reset_numPaso                    // resetea el numero de pasos
    MOV x19, 0                          // inicia el contador de paso

    LDR x9, =count    
    LDR x9, [x9]                        //n  = arr.length
    LDR x17, =array          
    MOV x18, 1                          //int (i)

/*{
        int n = arr.length;
        for (int i = 1; i < n; ++i) {
            int key = arr[i];
            int j = i - 1;
            while (j >= 0 && arr[j] < key) {
                arr[j + 1] = arr[j];
                j = j - 1;
                arr[j + 1] = key;
            }
            
        }
    } */

insdes_loop_1:
    //i < n
    CMP x18, x9
    BGE end_insdes_loop                 //  x18 >= x9
    
    LDRH w21, [x17, x18, LSL 1]         //  key = arr[i]
    
    SUB x20, x18, 1                     //  j = i - 1;
    
//x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20
//45,98,46,78,96,1,6,45,7,8,99,999
//7895,45,0,-9,-999,456,2500
insdes_loop_2:
    LDRH w22, [x17, x20, LSL 1]         //  arr[j]

    CMP x20, 0                          // Comparar x20 con 0
    BLT insert_element_insdes           // Si x20 < 0, salir del bucle

    CMP w22, w21                        // Comparar w5 con w4
    BGT insert_element_insdes           // Si w22 <= w21, salir del bucle

    //arr[j+1] = arr[j];
    ADD x20, x20, 1                   
    STRH w22, [x17, x20, LSL 1]
    //ADD x20, x20, 1                 //incremente j temporalmente
    
    SUB x20, x20, 1                   //decrementa j temporalmente

    SUB x20, x20, 1 //j = j - 1;      //decrementa j permanentemente

    ADD x20, x20, 1
    STRH w21, [x17, x20, LSL 1]
    SUB x20, x20, 1

    
    B insdes_loop_2

insert_element_insdes:

    ADD x18, x18, 1                   //incrementar i = i+1
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

    B insdes_loop_1

end_insdes_loop:
    BL printNewArray

    input
    B menu


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

//verifica los valores guardados en numPaso (contiene el numero de pasos del ordenamiento)
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

//imprime el nuevo array ordenado
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
