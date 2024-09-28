

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
