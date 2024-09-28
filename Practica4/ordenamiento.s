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
        .asciz "1. Ingreso de lista de numeros\n"
        .asciz "2. Bubble Sort\n"
        .asciz "3. Quick Sort\n"
        .asciz "4. Insertion Sort\n"
        .asciz "5. Merge Sort\n"
        .asciz "6. Salir\n"
        lenMenu = .- menuPrincipal

    subMenu:
        .asciz ">> subMenu\n"
        .asciz "1. De forma manual\n"
        .asciz "2. Carga de Archivo csv\n"
        .asciz "3. Regresar al menu anterior\n"
        lensubMenu = .- subMenu

    Opcion:
        .asciz "Ingrese Una Opcion: "
        lenOpcion = .- Opcion

    continuar:
        .asciz "Debe presionar la tecla enter para continuar\n"
        lenContinuar = . - continuar
    
    errormsg:
        .asciz "ERROR\n"
        lenErrormsg = . - errormsg

    operacionComa:
        .asciz "Ingrese los numeros separados por coma: "
        lenOperacionComa = . - operacionComa

    msgFilename:
    .asciz "Ingrese el nombre del archivo: "
    lenMsgFilename = .- msgFilename

    errorOpenFile:
        .asciz "Error al abrir el archivo\n"
        lenErrOpenFile = .- errorOpenFile

    readSuccess:
        .asciz "El Archivo Se Ha Leido Correctamente\n"
        lenReadSuccess = .- readSuccess

.bss
    opcion:
        .space 5
    
    operacion:
        .space 20   // => Reserva espacion en bytes para operacion

    filename:
        .zero 50   // reserva bloque de memoria inicializada en ceros

    array:
        .skip 1024

    count:
        .zero 8

    num:
        .space 4

    character:
        .byte 0

    fileDescriptor:
        .space 8

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

// Macro para leer datos
.macro read stdin, buffer, len
    MOV x0, \stdin
    LDR x1, =\buffer
    MOV x2, \len
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
    BEQ ingresoLista

    CMP w10, 50
    BEQ Bubble

    CMP w10, 51
    BEQ Quick

    CMP w10, 52
    BEQ Insertion

    CMP w10, 53
    BEQ Merge

    CMP w10, 54  // 54 es en codigo ascii que equivale a 6, termina el programa
    BEQ end

    ingresoLista:
        print clear, lenClear //limpia la terminal
        print subMenu, lensubMenu //muestra mensaje subMenu en la terminal
        print Opcion, lenOpcion //muestra mensaje Ingrese una opcion en la terminal
        input 

        LDR x10, =opcion //almacena la opcion ingresada en el registro x10
        LDRB w10, [x10]

        CMP w10, 49   // 49 es en codigo ascii equivale a 1
        BEQ manual

        CMP w10, 50
        BEQ archivoCSV

        CMP w10, 51
        BEQ regresar

        B cont // B = branch incondicional - se va a cont
    
    cont:
        input
        B menu // B = branch incondicional - se va a menu, lo cual simula un ciclo while

    openFile:
        // param: x1 -> filename
        MOV x0, -100
        MOV x2, 0
        MOV x8, 56
        SVC 0

        CMP x0, 0
        BLE op_f_error
        LDR x9, =fileDescriptor
        STR x0, [x9]
        B op_f_end

        op_f_error:
            print errorOpenFile, lenErrOpenFile
            read 0, opcion, 1

        op_f_end:
            RET

    closeFile:
        LDR x0, =fileDescriptor
        LDR x0, [x0]
        MOV x8, 57
        SVC 0
        RET