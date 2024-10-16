.include "macros.s"
.include "convertidores.s"

.global _start

.data
    clear:
        .asciz "\x1B[2J\x1B[H"
        lenClear = . - clear
    
    encabezado:
        .asciz "Universidad de San Carlos de Guatemala\n"
        .asciz "Facultad de Ingenieria\n"
        .asciz "Escuela de Ciencias y Sistemas\n"
        .asciz "Arquitectura de Computadores y Ensambladores 1\n"
        .asciz "Seccion A\n"
        .asciz "Luis Fernando Gonzalez Real\n"
        .asciz "201313965\n"
        lenEncabezado = . - encabezado

    espacio:  
        .asciz "  "
        lenEspacio = .- espacio
    
    columns_header:
        .asciz "          A              B              C              D              E              F              G              H              I              J              K   \n"
        lenColumnsHeader = .- columns_header

    ingresarComando:
        .asciz ":"
        lenIngresarComando = .- ingresarComando   // 2 puntos para pedir el ingreso del comando

    row:  
        .asciz "00"

.bss
    tablero:
        .skip 253 * 8   // matriz de 23 * 11 que tiene 64 bits cada numero

    comando:
        .zero 50    // guarda el comando que ingresa el usuario
    

.text
_start:
    print clear, lenClear

    print encabezado, lenEncabezado
    input
    // imprime_hoja
    
    insert_command:
        BL printCeldas
        BL getCommand
        
    
    printCeldas:
        print columns_header, lenColumnsHeader

        end_PrintCeldas:
            mov x9, 23                      // x23 contador de las filas
            adrp x25, tablero
            add  x25, x25, :lo12:tablero    // Sumar el offset para la dirección completa
            mov x26, 0                      // x26 contador de celdas

        printRows:
            
            mov x0, 24                      
            ldr x1, =row                    // almacenara el numero convertido
            mov w7, 2                       // Largo del Buffer a limpiar
            cleanValue
            ldr x1, =row
            mov x2, 2                       // Tamaño del buffer, sirve para que imprima un cero antes si el numero es de un solo digito
            sub x0, x0, x9

            sub sp, sp, #16                 // Reservar espacio en la pila (16 bytes)
            str x9, [sp]                    

            stp x29, x30, [SP, -16]!        
            bl itoa                         // Convierte el número a ASCII
            ldp x29, x30, [SP], 16          
            
            print row, 2                    // Se imprime la fila en consola
            print espacio, lenEspacio       // Se imprime un espacio en consola

            // Obtener el número de columnas
            ldr x9, [sp]                    // Cargar el valor de la columna en x12
            add sp, sp, #16                 // Liberar el espacio de la pila para la columna

            sub sp, sp, #16                 // Reservar espacio en la pila (16 bytes)
            str x9, [sp]                    // Almacenar el valor de x9 (número de filas) en la pila

            
            // x11 Sera el contador de las filas
            mov x11, 11                     // Reiniciar el número de columnas
    
    getCommand:
        print ingresarComando, lenIngresarComando
        read 0, comando, 50
        ret

    exit:

        //B ingreso_comando
        mov x0, 0
        mov x8, 93
        svc 0