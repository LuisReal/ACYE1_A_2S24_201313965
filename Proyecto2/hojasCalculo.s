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

    salto:  .asciz "\n"
        lenSalto = .- salto

    espacio:  
        .asciz "  "
        lenEspacio = .- espacio
    
    columns_header:
        .asciz "          A              B              C              D              E              F              G              H              I              J              K   \n"
        lenColumnsHeader = .- columns_header

    value:  .asciz "0000000000000"
        lenValue = .- value                         // guarda el valor de cada celda (UNICAMENTE 13 espacios)

    ingresarComando:
        .asciz ":"
        lenIngresarComando = .- ingresarComando     // 2 puntos para pedir el ingreso del comando

    row:  
        .asciz "00"

.bss
    tablero:
        .skip 253 * 8   // matriz de 23 * 11 que tiene 64 bits cada numero

    comando:
        .zero 50    // guarda el comando que ingresa el usuario
    
    opcion:
        .space 5

.text
_start:
    print clear, lenClear

    print encabezado, lenEncabezado
    input
    print clear, lenClear
    // imprime_hoja
    
    insert_command:
        bl printCeldas
        bl getCommand

        bl verifyCommand                    // verifica el tipo de comando ingresado
        
    exit:

        //B ingreso_comando
        mov x0, 0
        mov x8, 93
        svc 0

    
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

        printColumns:
            // Guardar el número de columna en la pila
            sub sp, sp, #16                 // Reserva espacio en la pila
            str x11, [sp]                   // Almacena el valor del número de columnas en la pila

            ldr x0, [x25, x26, lsl 3]       // Se carga el valor que tenga la matriz en dicha posicion, en el registro x0
            ldr x1, =value                  
            mov w7, 13                      // Largo del Buffer a limpiar
            cleanValue                      // Se limpia el buffer del numero que se va a convertir

            ldr x1, =value                  
            mov x2, 13                      // imprime un cero antes si el numero es de un solo digito
            stp x29, x30, [SP, -16]!        
            bl itoa                         // Convierte el número a ASCII
            ldp x29, x30, [SP], 16          
            
            print value, lenValue           // Se imprime el valor uno a uno de la matriz
            print espacio, lenEspacio       

            // Recuperar el número de columnas
            ldr x11, [sp]                   // Cargar el valor de la columna en x11
            add sp, sp, #16                 // Liberar el espacio de la pila para la columna

            sub x11, x11, 1                 // Disminuir el número de columnas
            cmp x11, 0                      // Comparar si se llega a 0
            add  x26, x26, 1                // Aumenta el contador de celdas impresas
            cbz x11, end_column             // Si es 0, finalizar impresión de columnas
            b printColumns                  // Volver a imprimir la columna

        end_column:

            // Recuperar el número de filas
            print salto, lenSalto
            ldr x9, [sp]                    // Cargar el valor de la fila en x13
            add sp, sp, #16                 // Libera el espacio de la pila para la fila

            sub x9, x9, 1                   // Disminuir el número de filas
            cmp x9, 0                       // Comparar con 0
            cbz x9, end                     // Si es 0, finalizar impresión de filas

            b printRows                     // imprimir la fila

        end:
            ret

    getCommand:
        print ingresarComando, lenIngresarComando
        read 0, comando, 50
        ret

    verifyCommand:
        
        ldr x0, =comando            // Se carga la direccion de memoria del comando
        ldrb w20, [x0], 1           // Se carga el primer caracter en w20
        cmp w20, #'G'               // Compara el carácter con 'G'
        beq guardar                 // Si es igual, salta a guardar
        b end_verify                // Si no encuentra ningun comando finaliza verificacion
        
        guardar:
            ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
            cmp w20, #'U'           
            bne end_verify          // Si no es igual, salta a end_verificar

            ldrb w20, [x0], 1
            cmp w20, #'A'           
            bne end_verify          // Si no es igual, salta a end_verificar

            ldrb w20, [x0], 1
            cmp w20, #'R'           
            bne end_verify          // Si no es igual, salta a end_verificar
            
            ldrb w20, [x0], 1
            cmp w20, #'D'           
            bne end_verify          // Si no es igual, salta a end_verificar

            ldrb w20, [x0], 1
            cmp w20, #'A'           
            bne end_verify          // Si no es igual, salta a end_verificar

            ldrb w20, [x0], 1
            cmp w20, #'R'           
            bne end_verify          // Si no es igual, salta a end_verificar

            ldrb w20, [x0], 1
            cmp w20, #' '           
            bne end_verify          // Si no es igual, salta a end_verificar

            mov w4, 1               // (Comando Guardar encontrado)

        end_verify:
            ret
