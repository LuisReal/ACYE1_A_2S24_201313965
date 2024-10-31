verifyCommand:
        
    ldr x0, =comando            // Se carga la direccion de memoria del comando
    ldrb w20, [x0], 1           // Se carga el primer caracter en w20
    
    cmp w20, #'G'               // Compara el carácter con 'G'
    beq guardar                 // Si es igual, salta a guardar

    cmp w20, #'S'               // Compara el carácter con 'S'
    beq suma                    // Si es igual, salta a suma

    cmp w20, #'R'               // Compara el carácter con 'R'
    beq resta                   // Si es igual, salta a resta

    cmp w20, #'M'               // Compara el carácter con 'M'
    beq multiplicacion          // Si es igual, salta a multiplicacion

    cmp w20, #'D'               // Compara el carácter con 'D'
    beq division                // Si es igual, salta a division

    cmp w20, #'P'               // Compara el carácter con 'P'
    beq potenciar                // Si es igual, salta a potenciar
    
    cmp w20, #'O'               // Compara el carácter con 'O'
    beq decidir_logico                // Si es igual, salta a decidir_logico

    cmp w20, #'Y'               // Compara el carácter con 'Y'
    beq ylogico                // Si es igual, salta a ylogico

    cmp w20, #'N'               // Compara el carácter con 'N'
    beq nologico                // Si es igual, salta a nologico
    
    cmp w20, #'L'
    beq llenar                  // Si es igual, salta a llenar
    
    cmp w20, #'I'               // Compara el carácter con 'I'
    beq importar                // Si es igual, salta a importar
    
    b error_verify                // Si no encuentra ningun comando finaliza verificacion
    
    error_verify:
        print msgErrorComando, lenErrorComando
        input
        b insert_command

    guardar:
        ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
        cmp w20, #'U'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'A'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'R'           
        bne error_verify          // Si no es igual, salta a error_verify
        
        ldrb w20, [x0], 1
        cmp w20, #'D'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'A'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'R'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #' '           
        bne error_verify          // Si no es igual, salta a error_verify

        mov w4, 1               // (Comando Guardar encontrado)
        B end_verify     // Si no encuentra ningun comando marcar error
    
    suma:
        ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
        cmp w20, #'U'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'M'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'A'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #' '           
        bne error_verify          // Si no es igual, salta a error_verify

        mov w4, 2               // (Comando Guardar encontrado)
        B end_verify     // Si no encuentra ningun comando marcar error

    resta:
        ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
        cmp w20, #'E'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'S'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'T'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'A'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #' '           
        bne error_verify          // Si no es igual, salta a error_verify

        mov w4, 3               // (Comando Guardar encontrado)
        B end_verify            // Si no encuentra ningun comando marcar error

    multiplicacion:
        ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
        cmp w20, #'I'           
        beq valor_minimo          // Si no es igual, salta a error_verify
        
        cmp w20, #'A'          // Compara el carácter con 'U'
        beq valor_maximo          // Si no es igual, salta a end_verify

        cmp w20, #'U'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'L'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'T'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'I'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
        cmp w20, #'P'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'L'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'I'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'C'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
        cmp w20, #'A'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'C'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'I'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'O'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'N'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #' '           
        bne error_verify          // Si no es igual, salta a error_verify

        mov w4, 4               // (Comando Guardar encontrado)
        B end_verify            // Si no encuentra ningun comando marcar error

    division:
        ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
        cmp w20, #'I'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'V'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'I'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'D'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'I'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'R'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #' '           
        bne error_verify          // Si no es igual, salta a error_verify

        mov w4, 5               // (Comando Guardar encontrado)
        B end_verify            // Si no encuentra ningun comando marcar error

    potenciar:

        ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
        cmp w20, #'R'
        beq promedio 
        
        cmp w20, #'O'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'T'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'E'           
        bne error_verify          // Si no es igual, salta a error_verify
        
        ldrb w20, [x0], 1
        cmp w20, #'N'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'C'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'I'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'A'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'R'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #' '           
        bne error_verify          // Si no es igual, salta a error_verify

        mov w4, 6               // (Comando Guardar encontrado)
        B end_verify     // Si no encuentra ningun comando marcar error
    
    decidir_logico:
        ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
        cmp w20, #'L'           
        beq ologico            // Si no es igual, salta a oxlogico (XOR)
        
        cmp w20, #'X'           
        beq oxlogico            // Si no es igual, salta a oxlogico (XOR)

    ologico:
        sub x0, x0, 1

        ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
        cmp w20, #'L'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'O'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'G'           
        bne error_verify          // Si no es igual, salta a error_verify
        
        ldrb w20, [x0], 1
        cmp w20, #'I'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'C'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'O'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #' '           
        bne error_verify          // Si no es igual, salta a error_verify

        mov w4, 7               // (Comando Guardar encontrado)
        B end_verify     // Si no encuentra ningun comando marcar error

    ylogico:
        ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
        cmp w20, #'L'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'O'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'G'           
        bne error_verify          // Si no es igual, salta a error_verify
        
        ldrb w20, [x0], 1
        cmp w20, #'I'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'C'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'O'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #' '           
        bne error_verify          // Si no es igual, salta a error_verify

        mov w4, 8               // (Comando Guardar encontrado)
        B end_verify     // Si no encuentra ningun comando marcar error


    oxlogico:

        ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
        cmp w20, #'L'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'O'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'G'           
        bne error_verify          // Si no es igual, salta a error_verify
        
        ldrb w20, [x0], 1
        cmp w20, #'I'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'C'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'O'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #' '           
        bne error_verify          // Si no es igual, salta a error_verify

        mov w4, 9               // (Comando Guardar encontrado)
        B end_verify     // Si no encuentra ningun comando marcar error

    nologico:
        ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
        cmp w20, #'O'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
        cmp w20, #'L'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'O'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'G'           
        bne error_verify          // Si no es igual, salta a error_verify
        
        ldrb w20, [x0], 1
        cmp w20, #'I'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'C'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'O'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #' '           
        bne error_verify          // Si no es igual, salta a error_verify

        mov w4, 10               // (Comando Guardar encontrado)
        B end_verify     // Si no encuentra ningun comando marcar error
    
    llenar:
        ldrb w20, [x0], #1  // Se sigue avanzando en el buffer (comando)
        cmp w20, #'L'          // Compara el carácter con 'U'
        bne error_verify           // Si no es igual, salta a end_verify

        ldrb w20, [x0], #1  // Se sigue avanzando en el buffer (comando)
        cmp w20, #'E'          // Compara el carácter con 'U'
        bne error_verify           // Si no es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'N'          // Compara el carácter con 'A'
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'A'          // Compara el carácter con 'A'
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'R'          // Compara el carácter con 'R'
        bne error_verify           // Si es igual, salta a end_verify
        
        ldrb w20, [x0], #1
        cmp w20, #' '          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'D'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'E'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'S'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'D'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'E'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #' '          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        mov w4, 11   // w4=11 (Comando Llenar encontrado)
        b end_verify     // Si no encuentra ningun comando marcar error

    promedio:
        ldrb w20, [x0], 1       // Se sigue avanzando en el buffer (comando)
        cmp w20, #'O'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'M'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'E'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'D'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'I'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'O'           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #' '           
        bne error_verify          // Si no es igual, salta a error_verify

        ldrb w20, [x0], 1
        cmp w20, #'D'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], 1
        cmp w20, #'E'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], 1
        cmp w20, #'S'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], 1
        cmp w20, #'D'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], 1
        cmp w20, #'E'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], 1
        cmp w20, #' '          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        mov w4, 12              // (Comando Guardar encontrado)
        B end_verify            // Si no encuentra ningun comando marcar error
    
    valor_minimo:
        ldrb w20, [x0], #1  // Se sigue avanzando en el buffer (comando)
        cmp w20, #'N'          // Compara el carácter con 'U'
        bne error_verify           // Si no es igual, salta a end_verify

        ldrb w20, [x0], #1  // Se sigue avanzando en el buffer (comando)
        cmp w20, #'I'          // Compara el carácter con 'U'
        bne error_verify           // Si no es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'M'          // Compara el carácter con 'A'
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'O'          // Compara el carácter con 'A'
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #' '          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], 1
        cmp w20, #'D'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], 1
        cmp w20, #'E'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], 1
        cmp w20, #'S'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], 1
        cmp w20, #'D'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], 1
        cmp w20, #'E'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #' '          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        MOV w4, 13           // w4=13 (Comando Importar encontrado)
        B end_verify        // Si no encuentra ningun comando marcar error

    valor_maximo:
        ldrb w20, [x0], #1  // Se sigue avanzando en el buffer (comando)
        cmp w20, #'X'          // Compara el carácter con 'N'
        bne error_verify           // Si no es igual, salta a end_verify

        ldrb w20, [x0], #1  // Se sigue avanzando en el buffer (comando)
        cmp w20, #'I'          // Compara el carácter con 'U'
        bne error_verify           // Si no es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'M'          // Compara el carácter con 'A'
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'O'          // Compara el carácter con 'A'
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #' '          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], 1
        cmp w20, #'D'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], 1
        cmp w20, #'E'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], 1
        cmp w20, #'S'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], 1
        cmp w20, #'D'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], 1
        cmp w20, #'E'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #' '          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        MOV w4, 14           // w4=13 (Comando Importar encontrado)
        B end_verify        // Si no encuentra ningun comando marcar error

    importar:
        ldrb w20, [x0], #1  // Se sigue avanzando en el buffer (comando)
        cmp w20, #'M'          // Compara el carácter con 'U'
        bne error_verify           // Si no es igual, salta a end_verify

        ldrb w20, [x0], #1  // Se sigue avanzando en el buffer (comando)
        cmp w20, #'P'          // Compara el carácter con 'U'
        bne error_verify           // Si no es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'O'          // Compara el carácter con 'A'
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'R'          // Compara el carácter con 'A'
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'T'          // Compara el carácter con 'R'
        bne error_verify           // Si es igual, salta a end_verify
        
        ldrb w20, [x0], #1
        cmp w20, #'A'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #'R'          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        ldrb w20, [x0], #1
        cmp w20, #' '          // Compara el carácter con ' '
        bne error_verify           // Si es igual, salta a end_verify

        MOV w4, 15   // w4=15 (Comando Importar encontrado)
        B end_verify     // Si no encuentra ningun comando marcar error


    end_verify:
        ret
