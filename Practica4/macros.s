

//metodo print para imprimir en consola
.macro print texto, cantidad
    MOV x0, 1
    LDR x1, =\texto
    MOV x2, \cantidad
    MOV x8, 64        
    SVC 0 
.endm

//metodo input para obtener los valores ingresados en la consola
.macro input
    MOV x0, 0
    LDR x1, =opcion
    LDR x2, =5 //es el tamaño bss .space 5 rservado para la variable de entrada
    MOV x8, 63
    SVC 0
.endm

// Macro para leer datos
.macro read stdin, buffer, len
    MOV x0, \stdin
    LDR x1, =\buffer
    MOV x2, \len
    MOV x8, 63
    SVC 0
.endm

// Macro para leer datos
.macro write buffer, lenbuffer
    // abrir archivo
    mov x0, -100        // abrir
    ldr x1, =nombreArchivo   
    mov x2, 101       
    mov x3, 0777        // permisos
    mov x8, 56          
    svc 0              
    mov x5, x0   

    mov x0, x5            // file descriptor
    mov x1, 0             // offset 0
    mov x2, 2             // SEEK_END (mover al final del archivo)
    mov x8, 62            // syscall para lseek
    svc 0       

    // escribir archivo
    mov x0, x5          
    ldr x1, =\buffer     
    mov x2, \lenbuffer         
    mov x8, 64          // escribir
    svc 0               

    // cerrar archivo
    mov x0, x5          // file descriptor
    mov x8, 57          // cerrar archivo
    svc 0 
.endm
