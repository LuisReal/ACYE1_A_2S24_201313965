.include "leerArchivo.s"
.include "tipoOrdenamiento.s"


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

    salto:
        .asciz "\n"
        lenSalto = .- salto

    espacio:
        .asciz " "
        lenEspacio = .- espacio

    prueba:
        .asciz "Estoy por aca"
        lenPrueba = .- prueba

.bss
    opcion:
        .space 5
    
    operacion:
        .space 20   // => Reserva espacio en bytes para operacion

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
        BEQ bubble

        /* 
        CMP w10, 51
        BEQ quick

        CMP w10, 52
        BEQ insertion

        CMP w10, 53
        BEQ merge
        */

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

            CMP w10, 51   // 50 es en codigo ascii equivale a 3
            BEQ cont

            //aqui va un mensaje de error sino ingresa la opcion correcta

        bubble:
            BL bubbleSort

            // recorrer array y convertir a ascii
            LDR x9, =count
            LDR x9, [x9] // length => cantidad de numeros leidos del csv
            MOV x7, 0
            LDR x15, =array

            loop_array:
                LDRH w0, [x15], 2
                LDR x1, =num
                BL itoa

                print espacio, lenEspacio

                ADD x7, x7, 1
                CMP x9, x7
                BNE loop_array

            print salto, lenSalto

            B cont // B = branch incondicional - se va a cont

        quick:
            B cont // B = branch incondicional - se va a cont

        insertion:
            B cont // B = branch incondicional - se va a cont

        merge:
            B cont // B = branch incondicional - se va a cont

        cont:
            input   // es importante agregar este input para poder continuar(presionar enter para continuar)
            B menu // B = branch incondicional - se va a menu, lo cual simula un ciclo while

        end:
            mov x0, 0   // Codigo de error de la aplicacion -> 0: no hay error
            mov x8, 93  // Codigo de la llamada al sistema
            svc 0       // Ejecutar la llamada al sistema


    