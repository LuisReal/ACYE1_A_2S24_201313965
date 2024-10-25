verificarPalabraIntermedia:

    // retorna en w4, el tipo de palabra intermedia
    ldrb w20, [x0], #1     // Se carga el valor de memoria de x0 en w20
    cmp w20, #'E'           
    beq palabra_en         
    cmp w20, #'H'          // Compara el carácter con 'H'
    beq palabra_hasta      
    cmp w20, #'S'          // Compara el carácter con 'S'
    beq separado_por       
    
    b end_verify_intermedia

    
    palabra_en:
    
        ldrb w20, [x0], #1
        cmp w20, #'N'        
        bne end_verify_intermedia    

        ldrb w20, [x0], #1
        cmp w20, #' '        
        bne end_verify_intermedia    

        mov w4, 1           // w4=1 palabra intermedia EN encontrada
        b end_verify_intermedia


    palabra_hasta:

        ldrb w20, [x0], #1
        cmp w20, #'A'          
        bne end_verify_intermedia            

        ldrb w20, [x0], #1
        cmp w20, #'S'          
        bne end_verify_intermedia            

        ldrb w20, [x0], #1
        cmp w20, #'T'          
        bne end_verify_intermedia            

        ldrb w20, [x0], #1
        cmp w20, #'A'          
        bne end_verify_intermedia            

        ldrb w20, [x0], #1
        cmp w20, #' '          
        bne end_verify_intermedia            

        mov w4, 2                   // w4=2 palabra intermedia HASTA encontrada
        b end_verify_intermedia


    separado_por:

        ldrb w20, [x0], #1
        cmp w20, #'E'           
        bne end_verify_intermedia       

        ldrb w20, [x0], #1
        cmp w20, #'P'           
        bne end_verify_intermedia       

        ldrb w20, [x0], #1
        cmp w20, #'A'            
        bne end_verify_intermedia        

        ldrb w20, [x0], #1
        cmp w20, #'R'            
        bne end_verify_intermedia        

        ldrb w20, [x0], #1
        cmp w20, #'A'            
        bne end_verify_intermedia        

        ldrb w20, [x0], #1
        cmp w20, #'D'            
        bne end_verify_intermedia        

        ldrb w20, [x0], #1
        cmp w20, #'O'            
        bne end_verify_intermedia        

        ldrb w20, [x0], #1
        cmp w20, #' '            
        bne end_verify_intermedia        

        ldrb w20, [x0], #1
        cmp w20, #'P'            
        bne end_verify_intermedia        

        ldrb w20, [x0], #1
        cmp w20, #'O'            
        bne end_verify_intermedia        

        ldrb w20, [x0], #1
        cmp w20, #'R'            
        bne end_verify_intermedia        

        ldrb w20, [x0], #1
        cmp w20, #' '            
        bne end_verify_intermedia       

        ldrb w20, [x0], #1
        cmp w20, #'T'            
        bne end_verify_intermedia 

        ldrb w20, [x0], #1
        cmp w20, #'A'            
        bne end_verify_intermedia

        ldrb w20, [x0], #1
        cmp w20, #'B'            
        bne end_verify_intermedia

        ldrb w20, [x0], #1
        cmp w20, #'U'            
        bne end_verify_intermedia

        ldrb w20, [x0], #1
        cmp w20, #'L'            
        bne end_verify_intermedia

        ldrb w20, [x0], #1
        cmp w20, #'A'            
        bne end_verify_intermedia

        ldrb w20, [x0], #1
        cmp w20, #'D'            
        bne end_verify_intermedia

        ldrb w20, [x0], #1
        cmp w20, #'O'            
        bne end_verify_intermedia

        ldrb w20, [x0], #1
        cmp w20, #'R'            
        bne end_verify_intermedia

        mov w4, 3               // w4=3 palabra intermedia SEPARADO POR encontrada
        b end_verify_intermedia

    end_verify_intermedia:
        ret