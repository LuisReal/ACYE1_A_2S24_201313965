verifyCommand:
        
    ldr x0, =comando            // Se carga la direccion de memoria del comando
    ldrb w20, [x0], 1           // Se carga el primer caracter en w20
    
    cmp w20, #'G'               // Compara el carácter con 'G'
    beq guardar                 // Si es igual, salta a guardar
    
    cmp w20, #'L'
    beq llenar                  // Si es igual, salta a llenar
    
    cmp w20, #'I'               // Compara el carácter con 'I'
    beq importar                // Si es igual, salta a importar
    
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
        B end_verify     // Si no encuentra ningun comando marcar error

    llenar:
        ldrb w20, [x0], #1  // Se sigue avanzando en el buffer (comando)
        cmp w20, #'L'          // Compara el carácter con 'U'
        bne end_verify           // Si no es igual, salta a end_verify

        ldrb w20, [x0], #1  // Se sigue avanzando en el buffer (comando)
        cmp w20, #'E'          // Compara el carácter con 'U'
        bne end_verify           // Si no es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'N'          // Compara el carácter con 'A'
        bne end_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'A'          // Compara el carácter con 'A'
        bne end_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'R'          // Compara el carácter con 'R'
        bne end_verify           // Si es igual, salta a end_verify
        
        ldrb w20, [x0], #1
        cmp w20, #' '          // Compara el carácter con ' '
        bne end_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'D'          // Compara el carácter con ' '
        bne end_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'E'          // Compara el carácter con ' '
        bne end_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'S'          // Compara el carácter con ' '
        bne end_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'D'          // Compara el carácter con ' '
        bne end_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'E'          // Compara el carácter con ' '
        bne end_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #' '          // Compara el carácter con ' '
        bne end_verify           // Si es igual, salta a end_verify

        mov w4, 11   // w4=11 (Comando Llenar encontrado)
        b end_verify     // Si no encuentra ningun comando marcar error
        
    importar:
        ldrb w20, [x0], #1  // Se sigue avanzando en el buffer (comando)
        cmp w20, #'M'          // Compara el carácter con 'U'
        bne end_verify           // Si no es igual, salta a end_verify

        ldrb w20, [x0], #1  // Se sigue avanzando en el buffer (comando)
        cmp w20, #'P'          // Compara el carácter con 'U'
        bne end_verify           // Si no es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'O'          // Compara el carácter con 'A'
        bne end_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'R'          // Compara el carácter con 'A'
        bne end_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'T'          // Compara el carácter con 'R'
        bne end_verify           // Si es igual, salta a end_verify
        
        ldrb w20, [x0], #1
        cmp w20, #'A'          // Compara el carácter con ' '
        bne end_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'R'          // Compara el carácter con ' '
        bne end_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #' '          // Compara el carácter con ' '
        bne end_verify           // Si es igual, salta a end_verify

        MOV w4, 15   // w4=15 (Comando Importar encontrado)
        B end_verify     // Si no encuentra ningun comando marcar error


    end_verify:
        ret
