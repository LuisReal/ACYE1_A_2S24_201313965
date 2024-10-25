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
    
    num:
        .space 19   // guarda los parametros que ingrese el usuario (Numero, Celda o Retorno)

    param1:
        .skip 8         // Reservar 8 bytes (64 bits) sin inicializar
    param2:
        .skip 8         // Reservar 8 bytes (64 bits) sin inicializar

    fila64:
        .skip 8         // guarda fila que se este trabajando 


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
        bl cleanParam                       // limpia la variable num que que contiene los valores del parametro
        
        bl verifyParam                      // verifica el tipo de parametro (Numero, Celda o Retorno) y guarda el parametro
        ldr x8, =param1
        bl paramNumero

        bl verificarPalabraIntermedia

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

    cleanParam:
        adrp x1, num               // Carga la página base de 'num'
        add x1, x1, :lo12:num      // Obtener la dirección de 'num'

        // Escribie 0's en 'num' para limpiarla
        mov w5, #0                 
        str w5, [x1]               
        ret

    verifyParam:
        // Retorna en w4, el tipo de parametro
        //w4=1=numero        w4=2=celda

        ldr x10, =num                   // Direccion en memoria donde se almacena el parametro
        mov x4, 0                       // x4=tipo de parametro puede ser: Numero, Celda, Retorno
                                    

        celda_column:
            ldrb w20, [x0], 1           // Se Carga en w20 lo que sigue del comando, se espera que ya sea algun parametro
            add x4, x4, 1               // Numero de caracteres leidos se aumenta
            cmp w20, #'A'                
            blt analizar_numero_resta   // Si w20 < 'A', salta a evaluar el numero

            cmp w20, #'K'               
            bgt v_fin                   // Si w20 > 'K', salta fuera del rango (da error)
            strb w20, [x10], 1          // Guardar la columna de la celda en num
        
        celda_row:
            ldrb w20, [x0], 1           
            add x4, x4, 1              

            cmp w20, #' '               
            beq retonar_celda           // Si w20 = ' ', salta a retornar celda

            cmp w20, 10                 
            beq retonar_celda           
            cbz w20, retonar_celda      // Si w20 = '\0', salta a retornar celda

            cmp w20, #'0'              
            blt v_fin                   // Si w20 < '0', salta fuera del rango deberia de dar error

            cmp w20, #'9'               
            bgt v_fin                   // Si w20 > '9', salta fuera del rango deberia de dar error
            strb w20, [x10], 1          // Guardar la fila de la celda en num
            b celda_row                 // Sigue leyendo los numeros de la fila

        analizar_numero_resta:
            
            sub x0, x0, x4
            mov x4, 0                   // Se reinicia las lecturas que se estan haciendo

        analizar_numero:
            ldrb w20, [x0], 1
            cmp w20, #' '              
            beq retornar_numero         // Si es igual, salta a retornar_numero
            cmp w20, #0                 
            beq retornar_numero         // Si es igual, salta a retornar_numero

            // valida que sean solo numeros
            strb w20, [x10], 1
            b analizar_numero

        retornar_numero:
            mov w4, 1
            b v_fin

        retonar_celda:
            mov w4, 2
            b v_fin

        v_fin:

            ret

    paramNumero:
        
        cmp w4, 01                      // Si el parametro es una celda
        beq param_numero
        cmp w4, 02                      // Si el parametro es una celda
        beq param_celda
        b retornar_param

        param_numero:
            // El numero de celda estara en w4
            ldr x12, =num
            ldr x5, =num

            stp x29, x30, [SP, -16]!     
            bl atoi
            ldp x29, x30, [SP], 16  

            b retornar_param

        param_celda:
            stp x29, x30, [SP, -16]!     
            bl posicionCelda
            ldp x29, x30, [SP], 16

            adrp x25, tablero
            add  x25, x25, :lo12:tablero // Suma el offset para la dirección completa
            ldr  x2, [x25, x5]           // carga el valor que tenga la matriz en dicha posicion, en el registro x2
            // LDR x8, =num64
            str x2, [x8]

        retornar_param:
            ret

    posicionCelda:
        // row-major
        
        ldr x12, =num           // Se carga la direccion de memoria del parametro de la celda
        ldrb w5, [x12], 1       // Se carga el primer valor que se espera sea la letra
        sub w20, w5, 65         // Se resta 65 ya que se espera que sea una letra entre A-K
        /* secuencia de las letras 
        A=0
        B=1
        C=2
        */
        mov x5, x12             // Se carga el valor de la fila a x5

        // Columna x20, fila x19
        stp x29, x30, [SP, -16]!
        ldr x8, =fila64         // Este parametro se envia unicamente porque lo pide la funcion sin embargo no se usara
        bl atoi 
        ldp x29, x30, [SP], 16

        sub x7, x7, 1           // De la funcion Atoi, se tiene que x7 tiene el resultado del numero convertido, se le resta 1
        mov x19, x7             // Fila=x19

        // row-Major
        mov x5, 11              // 11 es el numero de columnas
        mul x5, x5, x19         // x5 = x5 * x19 (el resultado se almacena en x5)
        add x5, x5, x20         // x5=posicion final en nuestra matriz
        ret

    verificarPalabraIntermedia:

        // Retorna en w4, el tipo de palabra intermedia
        ldrb w20, [x0], #1     // Se carga el valor de memoria de x0 en w20
        cmp w20, #'E'           
        beq palabra_en         
        cmp w20, #'H'          // Compara el carácter con 'H'
        beq palabra_hasta      
        cmp w20, #'S'          // Compara el carácter con 'S'
        beq separado_por       
        
        b fin_verificar
        
        palabra_en:
        
            ldrb w20, [x0], #1
            cmp w20, #'N'        
            bne fin_verificar    

            ldrb w20, [x0], #1
            cmp w20, #' '        
            bne fin_verificar    

            mov w4, 1           // w4=1 palabra intermedia EN encontrada
            b fin_verificar

        palabra_hasta:

            ldrb w20, [x0], #1
            cmp w20, #'A'          
            bne fin_verificar            

            ldrb w20, [x0], #1
            cmp w20, #'S'          
            bne fin_verificar            

            ldrb w20, [x0], #1
            cmp w20, #'T'          
            bne fin_verificar            

            ldrb w20, [x0], #1
            cmp w20, #'A'          
            bne fin_verificar            

            ldrb w20, [x0], #1
            cmp w20, #' '          
            bne fin_verificar            

            mov w4, 2                   // w4=2 palabra intermedia HASTA encontrada
            b fin_verificar

        separado_por:
        
            ldrb w20, [x0], #1
            cmp w20, #'E'           
            bne fin_verificar       

            ldrb w20, [x0], #1
            cmp w20, #'P'           
            bne fin_verificar       

            ldrb w20, [x0], #1
            cmp w20, #'A'            
            bne fin_verificar        

            ldrb w20, [x0], #1
            cmp w20, #'R'            
            bne fin_verificar        

            ldrb w20, [x0], #1
            cmp w20, #'A'            
            bne fin_verificar        

            ldrb w20, [x0], #1
            cmp w20, #'D'            
            bne fin_verificar        

            ldrb w20, [x0], #1
            cmp w20, #'O'            
            bne fin_verificar        

            ldrb w20, [x0], #1
            cmp w20, #' '            
            bne fin_verificar        

            ldrb w20, [x0], #1
            cmp w20, #'P'            
            bne fin_verificar        

            ldrb w20, [x0], #1
            cmp w20, #'O'            
            bne fin_verificar        

            ldrb w20, [x0], #1
            cmp w20, #'R'            
            bne fin_verificar        

            ldrb w20, [x0], #1
            cmp w20, #' '            
            bne fin_verificar        

            mov w4, 3               // w4=3 palabra intermedia SEPARADO POR encontrada
            B fin_verificar

        fin_verificar:
            ret