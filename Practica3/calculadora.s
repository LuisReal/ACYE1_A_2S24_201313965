.global _start

.data
    
    //clear es para limpiar la terminal
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

    menuPrincipal:
        .asciz ">> Menu Principal\n"
        .asciz "1. Suma\n"
        .asciz "2. Resta\n"
        .asciz "3. Multiplicacion\n"
        .asciz "4. Division\n"
        .asciz "5. Calculo Con Memoria\n"
        .asciz "6. Salir\n"
        lenMenu = .- menuPrincipal

    Opcion:
        .asciz "Ingrese Una Opcion: "
        lenOpcion = .- Opcion

    sumaText:
        .asciz "Ingresando Suma\n"
        lenSumaText = . - sumaText

    restaText:
        .asciz "Ingresando Resta\n1"
        lenRestaText = . - restaText

    multiplicacionText:
        .asciz "Ingresando Multiplicacion\n"
        lenMultiplicacionText = . - multiplicacionText

    divisionText:
        .asciz "Ingresando Division\n"
        lenDivisionText = . - divisionText

bss
    opcion:
        .space 5 

//metodo print para imprimir en consola
.macro print texto, cantidad
    MOV x0, 1
    LDR x1, =\texto
    LDR x2, =\cantidad
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

.text
_start:
    print clear, lenClear //limpia la terminal
    print encabezado, lenEncabezado //muestra mensaje encabezado en la terminal
    input

    menu:
        print clear, lenClear //limpia la terminal
        print menuPrincipal, lenMenu //muestra mensaje menuPrincipal en la terminal
        print Opcion, lenOpcion //muestra mensaje Ingrese una opcion en la terminal
        input 

        LDR x10, =opcion //almacena la opcion ingresada en el registro x10
        LDRB w10, [x10]

        CMP w10, 49   // 49 es en codigo ascii equivale a 1
        BEQ suma

        CMP w10, 50
        BEQ resta

        CMP w10, 51
        BEQ multiplicacion

        CMP w10, 52
        BEQ division

        CMP w10, 53
        BEQ operacion_memoria

        CMP w10, 54  // 54 es en codigo ascii que equivale a 6
        BEQ end

    end:
        mov x0, 0   // Codigo de error de la aplicacion -> 0: no hay error
        mov x8, 93  // Codigo de la llamada al sistema
        svc 0       // Ejecutar la llamada al sistema