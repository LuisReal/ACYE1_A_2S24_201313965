.global _start

.data
    clear:
        .asciz "\x1B[2J\x1B[H"
        lenClear = . - clear
    
    columns_header:
        .asciz "          A              B              C              D              E              F              G              H              I              J              K   \n"
        lenColumnsHeader = .- columns_header

    ingresarComando:
        .asciz ":"
        lenIngresarComando = .- ingresarComando   // 2 puntos para pedir el ingreso del comando

.bss
    comando:
        .zero 50    // guarda el comando que ingresa el usuario

.text
_start:
    print clear, lenClear

    // imprime_hoja
    
    insert_command:
        BL printCeldas
        BL getCommand
        
    
    printCeldas:
        print columns_header, lenColumnsHeader

        end_PrintCeldas:
            mov x9, 23                      // x23 contador de las filas
            adrp x25, tablero
            add  x25, x25, :lo12:tablero    // Sumar el offset para la dirección completa
            mov x26, 0                      // x26 contador de celdas
    
    getCommand:
        print ingresarComando, lenIngresarComando
        read 0, comando, 50
        RET