
itoa:
    
    mov x8, 0           // contador de numeros
    mov x3, 10          // base
    mov w17, 1          // Control para ver si el numero es negativo

    negativo:
        tst x0, #0x8000000000000000
        bne complemento_2
        b convertirAscii

    complemento_2:
        mvn x0, x0
        add x0, x0, 1
        mov w17, 0

    convertirAscii:
        udiv x16, x0, x3        
        msub x6, x16, x3, x0    // obtener el residuo de la division
        add w6, w6, 48          // convertir en valor ascii el residuo

        
        sub sp, sp, #8          // Reservar 16 bytes (por alineación) en la pila
        str w6, [sp, #0]        // Almacenar el valor de w6 en la pila en la dirección apuntada por sp

        add x8, x8, 1           // Sumar la cantidad de numeros leidos
        mov x0, x16             // Mover el resultado de la division (cociente) para x0 para la siguiente iteracion agarre el nuevo valor
        cbnz x16, convertirAscii

        cbz w17, agregar_signo
        b agregar_ceros

    agregar_signo:
        mov w6, 45
        
        sub sp, sp, #8           // Reservar 16 bytes (por alineación) en la pila
        str w6, [sp, #0]         // Almacenar el valor de w6 en la pila en la dirección apuntada por sp
        add x8, x8, 1

    agregar_ceros:
        mov x16, x2
        sub x16, x16, x8
        add x1, x1, x16

    almacenar:
        // Cargar el valor de vuelta desde la pila
        ldr w6, [sp, #0]        // Cargar el valor almacenado en la pila a w7
        strb w6, [x1], 1

        // Limpiar el espacio de la pila
        add sp, sp, #8          // Recuperar los 16 bytes de la pila

        sub x8, x8, 1           // Restamos el contador de la pila
        cbnz x8, almacenar
        

    endConversion:
        ret


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


