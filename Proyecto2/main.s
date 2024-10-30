.include "macros.s"
.include "convertidores.s"
.include "verificarComando.s"
.include "palabraIntermedia.s"
.include "importar.s"

.global itoa
.global atoi
.global _start

.data
    clear:
        .asciz "\x1b[2J\x1b[H"
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

    salto:  .asciz "\n"
        lenSalto = .- salto

    espacio:  
        .asciz "  "
        lenEspacio = .- espacio
    
    columns_header:
        .asciz "          A              B              C              D              E              F              G              H              I              J              K   \n"
        lenColumnsHeader = .- columns_header

    value:  .asciz "0000000000000"
    lenValue = .- value // SE ENCARGARA DE GUARDAR EL VALOR DE CADA CELDA (UNICAMENTE 13 espacios)

    ingresarComando:
        .asciz ":"
        lenIngresarComando = .- ingresarComando     // 2 puntos para pedir el ingreso del comando
    
    msgIngresarValor:
        .asciz "Ingresar un valor para @@@:"
        lenMsgIngresarValor = .- msgIngresarValor

    row:  
        .asciz "00"
    
    letra:  
        .asciz "A"
    /* 
    buffer:  
        .asciz "0\n"*/
    prueba:  
        .asciz "9223372036854775807\0"
    
    imp:
        .asciz "IMPORTAR"

    sep:
        .asciz "SEPARADO POR TABULADOR"

    errorImport:
        .asciz "Error En El Comando De Importación"
        lenError = .- errorImport

    errorOpenFile:
        .asciz "Error al abrir el archivo\n"
        lenErrOpenFile = .- errorOpenFile

    getIndexMsg:
        .asciz "Ingrese la columna para el encabezado "
        lenGetIndexMsg = .- getIndexMsg

    msgSuccess:
        .asciz "El Archivo Se Ha Leido Correctamente\n"
        lenMsgSuccess = .- msgSuccess

    dospuntos:
        .asciz ":"
        lenDospuntos = .- dospuntos   

    errormsg:
        .asciz "ERROR: No se puede dividir entre 0\n"
        lenErrormsg = . - errormsg 

.bss

    tablero:
        .skip 253 * 8   // matriz de 23 * 11 que tiene 64 bits cada numero

    comando:
        .zero 50    // guarda el comando que ingresa el usuario
    
    any_number:
        .skip 20

    tipo_comando: 
        .zero 1
    
    num64:
        .skip 8 

    param1:
        .skip 8         // Reservar 8 bytes (64 bits) sin inicializar

    posicion_param1:
        .skip 1
        
    param2:
        .skip 8         // Reservar 8 bytes (64 bits) sin inicializar

    posicion_param2:
        .skip 2

    fila64:
        .skip 8         // guarda fila que se este trabajando 

    opcion:
        .space 5

    num:
        .space 19   // guarda los parametros que ingrese el usuario (Numero, Celda o retorno)

    num2:
        .space 8

    filename:
        .space 100

    buffer:
        .zero 1024

    fileDescriptor:
        .space 8

    listIndex:
        .zero 13

    character:
        .space 2

    v_retorno:
        .space 8

.text

printCeldas:
    print columns_header, lenColumnsHeader

    end_PrintCeldas:
        mov x9, 23                      // x23 contador de las filas
        adrp x25, tablero
        add  x25, x25, :lo12:tablero    // Sumar el offset para la dirección completa
        mov x26, 0                      // x26 contador de celdas

    printRows:
        
        mov x0, 24                      
        ldr x1, =row                    // almacenara el numero convertido
        mov w7, 2                       // Largo del buffer a limpiar
        cleanValue
        ldr x1, =row
        mov x2, 2                       // Tamaño del buffer, sirve para que imprima un cero antes si el numero es de un solo digito
        sub x0, x0, x9

        sub sp, sp, #16                 // Reservar espacio en la pila (16 bytes)
        str x9, [sp]                    

        stp x29, x30, [SP, -16]!        
        bl itoa                         // Convierte el número a ASCII
        ldp x29, x30, [SP], 16          
        
        print row, 2                    // Se imprime la fila en consola
        print espacio, lenEspacio       // Se imprime un espacio en consola

        // Obtener el número de columnas
        ldr x9, [sp]                    // Cargar el valor de la columna en x12
        add sp, sp, #16                 // Liberar el espacio de la pila para la columna

        sub sp, sp, #16                 // Reservar espacio en la pila (16 bytes)
        str x9, [sp]                    // Almacenar el valor de x9 (número de filas) en la pila

        
        // x11 Sera el contador de las filas
        mov x11, 11                     // Reiniciar el número de columnas

    printColumns:
        // Guardar el número de columna en la pila
        sub sp, sp, #16                 // Reserva espacio en la pila
        str x11, [sp]                   // Almacena el valor del número de columnas en la pila

        ldr x0, [x25, x26, lsl 3]       // Se carga el valor que tenga la matriz en dicha posicion, en el registro x0
        ldr x1, =value                  
        mov w7, 13                      // Largo del buffer a limpiar
        cleanValue                      // Se limpia el buffer del numero que se va a convertir

        ldr x1, =value                  
        mov x2, 13                      // imprime un cero antes si el numero es de un solo digito
        stp x29, x30, [SP, -16]!        
        bl itoa                         // Convierte el número a ASCII
        ldp x29, x30, [SP], 16          
        
        print value, lenValue           // Se imprime el valor uno a uno de la matriz
        print espacio, lenEspacio       

        // Recuperar el número de columnas
        ldr x11, [sp]                   // Cargar el valor de la columna en x11
        add sp, sp, #16                 // Liberar el espacio de la pila para la columna

        sub x11, x11, 1                 // Disminuir el número de columnas
        cmp x11, 0                      // Comparar si se llega a 0
        add  x26, x26, 1                // Aumenta el contador de celdas impresas
        cbz x11, end_column             // Si es 0, exitizar impresión de columnas
        b printColumns                  // Volver a imprimir la columna

    end_column:

        // Recuperar el número de filas
        print salto, lenSalto
        ldr x9, [sp]                    // Cargar el valor de la fila en x13
        add sp, sp, #16                 // Libera el espacio de la pila para la fila

        sub x9, x9, 1                   // Disminuir el número de filas
        cmp x9, 0                       // Comparar con 0
        cbz x9, end                     // Si es 0, exitizar impresión de filas

        b printRows                     // imprimir la fila

    end:
        ret

cleanParam:
    adrp x1, num               // Carga la página base de 'num'
    add x1, x1, :lo12:num      // Obtener la dirección de 'num'

    // Escribie 0's en 'num' para limpiarla
    mov w5, #0                 
    str w5, [x1]               
    ret

cleanCommand:
    adrp x1, comando               // Carga la página base de 'comando'
    add x1, x1, :lo12:comando      // Obtener la dirección de 'comando'

    // Escribie 0's en 'num' para limpiarla
    mov x2, 50
    mov w5, #0  

    reset_loop:
        strb w5, [x1], 1      // Escribir 0 en cada byte y avanzar la dirección
        sub x2, x2, 1         // Decrementar el contador de bytes
        cbnz x2, reset_loop    // Repetir hasta que X1 llegue a cero               
              
    ret

cleanPosicion_params:
    adr x1, param1               // Carga la página base de 'param1'
    // Escribie 0's en 'num' para limpiarla
    mov x5, #0
    str x5, [x1]
                   
    adr x1, posicion_param1               // Carga la página base de 'posicion_param1'
    // Escribie 0's en 'num' para limpiarla
    ldr x5, [x1]

    mov w5, #0             
    strb w5, [x1]   

    ldr x5, [x1]     

    adr x1, param2               // Carga la página base de 'param2'
    // Escribie 0's en 'num' para limpiarla
    mov x5, #0                
    str x5, [x1]
    

    adr x1, posicion_param2               // Carga la página base de 'posicion_param2'
    // Escribie 0's en 'num' para limpiarla
    mov w5, #0         
    strb w5, [x1], 1
    strb w5, [x1]               


    ldr x1, =fila64               // Carga la página base de 'fila64'
    //add x1, x1, :lo12:fila64      // Obtener la dirección de 'fila64'

    // Escribie 0's en 'num' para limpiarla
    str x5, [x1]               
    
    ret

posicionCelda:
    // row-major
    
    ldr x12, =num           // Se carga la direccion de memoria del parametro de la celda(num fue modificado en verifyParam num=param1 o param2)
    ldrb w5, [x12], 1       // Se carga el primer valor que se espera sea la letra de (A01,A02) (fer)
    sub w20, w5, 65         // Se resta 65 ya que se espera que sea una letra entre A-K (A01,A02,A03, etc) (fer)
    /* secuencia de las letras 
    A=0
    b=1
    C=2
    */
    mov x5, x12             // Se carga solamente la direccion de memoria de x12=num (fer)

    // Columna x20, fila x19
    stp x29, x30, [SP, -16]!
    ldr x8, =fila64         // x8 contendra el numero de fila que se guarda con atoi (fer)
    bl atoi                 // aqui se usa x5=direccion memoria de num y x8 contendra el numero entero(fer)
    ldp x29, x30, [SP], 16

    sub x7, x7, 1           // De la funcion Atoi, se tiene que x7 tiene el resultado del numero convertido(A01,A02), se le resta 1
    mov x19, x7             //x19 = el numero entero

    //aqui se configura la posicion de param1 o param2
    // row-Major x5 = posicion_param1  o posicion_param2 (fer)
    mov x5, 11              // 11 es el numero de columnas
    mul x5, x5, x19         // x5 = x5 * x19 (x19 = el numero entero de A01, A02)
    add x5, x5, x20         // w20= a la posicion (el indice 0000000000000, 13 valores caben en una celda)
    ret

verifyParam:
    // retorna en w4, el tipo de parametro
    //w4=1=numero        w4=2=celda

    ldr x10, =num                   // Direccion en memoria donde se almacenara el parametro por primera vez
    mov x4, 0                       // x4=tipo de parametro puede ser: Numero, Celda, retorno
                                

    celda_column:
        ldrb w20, [x0], 1           // Se Carga en w20 lo que sigue del comando, se espera que ya sea algun parametro
        add x4, x4, 1               // Numero de caracteres leidos se aumenta
        
        cmp w20, 10
        beq retonar_archivo
        
        cmp w20, #'A'                
        blt analizar_numero_resta   // Si w20 < 'A', salta a evaluar el numero

        cmp w20, #'K'               
        bgt analizar_archivo_resta  // Si w20 > 'K', salta fuera del rango (da error)
        

        strb w20, [x10], 1          // Guardar la columna de la celda en num
    
    celda_row:// si w20 = A - K
        ldrb w20, [x0], 1           
        add x4, x4, 1              

        cmp w20, #' '               
        beq retonar_celda           // Si w20 = ' ', salta a retornar celda

        cmp w20, 10                 
        beq retonar_celda           
        cbz w20, retonar_celda      // Si w20 = '\0', salta a retornar celda

        cmp w20, #'0'              
        blt analizar_archivo_resta  // Si w20 < '0', salta fuera del rango deberia de dar error

        cmp w20, #'9'               
        bgt analizar_archivo_resta  // Si w20 > '9', salta fuera del rango deberia de dar error
        
        // si w20 = 0-9 (numero de fila)
        strb w20, [x10], 1          // Guardar la fila de la celda en num (num = A01,A02, etc)
        b celda_row                 // Sigue leyendo los numeros de la fila

    analizar_numero_resta:
        
        sub x0, x0, x4
        mov x4, 0                   // Se reinicia las lecturas que se estan haciendo

    analizar_numero:

        ldrb w20, [x0], 1

        cmp w20, #'*'
        beq retornar_var_retorno    // si es igual, salta a retornar_var_retorno

        cmp w20, #' '              
        beq retornar_numero         // Si es igual, salta a retornar_numero
        
        cmp w20, 10                 
        beq retornar_numero         // Si es igual, salta a retornar_numero

        // valida que sean solo numeros
        strb w20, [x10], 1          //guarda w20 en num
        add x4, x4, 1               // Numero de caracteres leidos se aumenta
        b analizar_numero

    analizar_archivo_resta:
        // Se debe restar lo que se leyo antes para que pueda leer el numero completo en caso sea numero
        sub x0, x0, x4
        mov x4, 0 // Se reinicia las lecturas que se estan haciendo
        ldr x10, =num

    analizar_archivo:
        ldrb w20, [x0], #1          // Se carga el siguiente caracter del comando
        add x4, x4, 1               // Nuevamente se aumenta la cantidad de caracteres leidos

        cmp w20, #' '               // Compara w20 con ' ' (65 en ASCII)
        beq retonar_archivo         // Si w20 = ' ', salta a retornar archivo
        cmp w20, 10                 // Compara w20 con '\10' (65 en ASCII)
        beq retonar_archivo         // Si w20 = '\10', salta a retornar archivo
        cbz w20, retonar_archivo    // Si w20 = '\0', salta a retornar archivo

        strb w20, [x10], 1          // Guardar las letras del nombre del archivo.csv
        add x4, x4, 1               // Numero de caracteres leidos se aumenta
        b analizar_archivo          // Sigue leyendo las letras del nombre del archivo.csv

    retornar_numero:
        mov w4, 1
        b v_fin

    retonar_celda: //A01, A02
        mov w4, 2
        b v_fin

    retornar_var_retorno:
        add x0, x0, 1       //aumenta la direccion de memoria en 1 para que este en la palabra intermedia
        mov w4, 3
        b v_fin
    
    retonar_archivo:
        mov w4, 4
        b v_fin

    v_fin:

        ret


getCommand:
    print ingresarComando, lenIngresarComando
    read 0, comando, 50
    ret

getNumber:
    adr x6, any_number
    mov x7, 0
    str x7, [x6]
    print msgIngresarValor, lenMsgIngresarValor
    read 0, any_number, 20

    ret


paramNumero:
    
    cmp w4, 1  // Si el parametro es un numero
    beq param_numero
    cmp w4, 2  // Si el parametro es una celda
    beq param_celda
    cmp w4, 3  // Si el parametro es una asterisco(variable de retorno)
    beq param_retorno
    cmp w4, 4  // Si el parametro es un archivo
    beq param_texto
    b retornar_param

    param_numero: // solo numeros
        
        ldr x12, =num
        ldr x5, =num
        stp x29, x30, [SP, -16]!     // Guardar x29 y x30 antes de la llamada
        bl atoi                      // [x8]=param1 o param2 contendra el numero entero
        ldp x29, x30, [SP], 16       // Restaurar x29 y x30 después de la llamada
        b retornar_param

    param_celda:    //A01, A02 etc
        //x8 = param1 o  param2 (fer)
        str x8, [sp, #-16]!         // Decrementa el puntero de la pila y guarda x8 en la pila para no perder el valor de x8 (fer)
        stp x29, x30, [SP, -16]!    // Guardar x29 y x30 antes de la llamada
        bl posicionCelda            // aqui se calcula la posicion de param1 o param2 y se guarda en x5 A01 = A columna 01 fila 
        ldp x29, x30, [SP], 16
        ldr x8, [sp], #16           // Carga x8(param1 o param2) desde la pila y luego incrementa el puntero de la pila (fer)
        str x5, [x9]                // x9 = posicion_param1  o posicion_param2 (fer)

        //En dado caso se ingrese una celda para obtener su valor ej: SUMA A01 Y A02
        adrp x25, tablero
        add  x25, x25, :lo12:tablero    // Sumar el offset para la dirección completa
        ldr  x2, [x25, x5, lsl 3]       // Se carga el valor que tenga nuestra matriz en dicha posicion, en el registro x2
        str x2, [x8]                    //x8 = param1 o  param2
        b retornar_param

    param_texto:
        ldr x12, =num
        ldr x13, [x12]
        str x13, [x8]                   //x8 = param1 o param2
        b retornar_param

    param_retorno:
        ldr x12, =v_retorno             
        ldr x13, [x12]                  //x13 contiene un numero entero
        str x13, [x8]                   //guarda el valor de v_retorno en param1
        b retornar_param

    retornar_param:
        ret



posicionACelda:

    mov x22, 11
    sdiv x21, x20, x22          //x20 = posicion_param1

    // multiplicar el cociente por el divisor
    mul x23, x21, x22       // x23 = x21 * x22

    // Restar el producto del dividendo para obtener el residuo
    sub x24, x20, x23       // x24 = x20 - (x21 * x22) (residuo)
    
    // Columna
    add w1, w24, 65
    // mov w1, w21
    adr x5, msgIngresarValor
    strb w1, [x5, #23]      //guarda w1 en el primer @ de "Ingresar un valor para @@@:"

    // Fila
    add x21, x21, 1
    mov x22, 10
    sdiv x19, x21, x22

    add w1, w19, 48
    strb w1, [x5, #24]      //guarda w1 en el segundo @ de "Ingresar un valor para @@@:"

    // multiplicar el cociente por el divisor
    mul x23, x19, x22       // x23 = x21 * x22

    // Restar el producto del dividendo para obtener el residuo
    sub x24, x21, x23       // x24 = x20 - (x21 * x22) (residuo)
    add w1, w24, 48
    strb w1, [x5, #25]      //guarda w1 en el tercer @ de "Ingresar un valor para @@@:"

    ret



llenarFilaColumna:
    // x27: cuanto se va a sumar o restar para avanzar en la matriz
    // x3: cantidad de veces que se repite el bucle
    adrp x25, tablero
    add  x25, x25, :lo12:tablero       // Sumar el offset para la dirección completa

    loop_llenar:
        adr x4, posicion_param1
        ldr w20, [x4]                //0
        
        stp x29, x30, [SP, -16]!     // Guardar x29 y x30 antes de la llamada
        bl posicionACelda            // aqui se usa w20 = x20
        ldp x29, x30, [SP], 16       // Restaurar x29 y x30 después de la llamada

        stp x29, x30, [SP, -16]!     // Guardar x29 y x30 antes de la llamada
        bl getNumber
        ldp x29, x30, [SP], 16       // Restaurar x29 y x30 después de la llamada
        ldr x12, =any_number         //obtiene el valor ingresado por consola
        ldr x5, =any_number          //obtiene el valor ingresado por consola   
        ldr x8, =fila64
        stp x29, x30, [SP, -16]!     // Guardar x29 y x30 antes de la llamada
        bl atoi
        ldp x29, x30, [SP], 16       // Restaurar x29 y x30 después de la llamada

        // x20 = w20 = posicion_param1
        str  x7, [x25, x20, lsl 3]   //x7(numero entero) proviene de atoi y lo guarda en el tablero

        adr x4, posicion_param1
        ldr w20, [x4]
        add w20, w20, w27           //w27 = 1 o 11 al inicio
        strb w20, [x4]

        sub x3, x3, 1               //x3 = posicion_param2 - posicion_param1
        cmp x3, 0
        bge loop_llenar
    ret


getValues:      //obtiene  los valores almacenados de la celda en el rango especificado

    mov x10, 0                          //contendra el resultado solo de la suma total

    adrp x25, tablero
    add  x25, x25, :lo12:tablero    // Sumar el offset para la dirección completa

    loop_get:
        adr x4, posicion_param1
        ldrb w20, [x4]

        //En dado caso se ingrese una celda para obtener su valor ej: SUMA A01 Y A02
        ldr  x2, [x25, x20, lsl 3]    // Se carga el valor que tenga nuestra matriz en dicha posicion, en el registro x2
        //str x2, [x8]                 //x8 = param1 o  param2

        add x10, x10, x2             //x10 = contendra el resultado solo de la suma total de los valores

        adr x4, posicion_param1
        ldrb w20, [x4]
        add w20, w20, w27
        strb w20, [x4]

        sub x3, x3, 1               //x3 = posicion_param2 - posicion_param1 que es igual a cantidad de veces que se repite el bucle
        cmp x3, 0
        bge loop_get
    ret
//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
_start:
    print clear, lenClear

    print encabezado, lenEncabezado
    input
    print clear, lenClear
    // imprime_hoja
    
    insert_command:
        bl printCeldas
        bl cleanCommand                     //limpia el comando anterior para ingresar el nuevo por consola
        bl getCommand

        bl verifyCommand                    // verifica el tipo de comando ingresado
        adr x5, tipo_comando
        strb w4, [x5]                       //w4 es lo que regresa verifyCommand
        
        bl cleanParam                       // limpia la variable num que que contiene los valores del parametro
        
        bl verifyParam                      // verifica el tipo de parametro (w4 Numero=1, Celda=2 o retorno=3)
        bl cleanPosicion_params             //resetea posicion_param1 y posicion_param2

        ldr x8, =param1                     //contendra el valor ingresado
        ldr x9, =posicion_param1
        bl paramNumero                      //aqui es donde se guardan el parametro en x8 y calcula posicion del parametro

        bl verificarPalabraIntermedia
        bl cleanParam

        cmp w4, 0                           //si no hay palabra intermedia(caso para el not logico)
        beq concluir

        // segundo parametro
        bl verifyParam
        ldr x8, =param2
        ldr x9, =posicion_param2
        bl paramNumero                      //aqui es donde se guardan el parametro en x8 y calcula posicion del parametro

        

    concluir:

        adr x0, tipo_comando
        ldrb w2, [x0]

        cmp w2, 1
        beq concluir_guardar
        cmp w2, 2
        beq concluir_suma
        cmp w2, 3
        beq concluir_resta
        cmp w2, 4
        beq concluir_multiplicacion
        cmp w2, 5
        beq concluir_division
        cmp w2, 6
        beq concluir_potenciar
        cmp w2, 7
        beq concluir_ologico
        cmp w2, 8
        beq concluir_ylogico
        cmp w2, 9
        beq concluir_oxlogico
        cmp w2, 10
        beq concluir_nologico
        cmp w2, 11
        beq concluir_llenar
        cmp w2, 12
        beq concluir_promedio
        cmp w2, 15
        beq concluir_importar
        
        B exit

//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------

    concluir_guardar:
        
        ldr x8, =param1
        ldr x9, [x8]
        ldr x11, =param2
        ldr x10, [x11]

        adrp x25, tablero
        add  x25, x25, :lo12:tablero       // Sumar el offset para la dirección completa
        str  x9, [x25, x5, lsl 3]           //x5 = posicion_param1  o posicion_param2 se calcula en paramNumero->posicionCelda (fer)

        B exit_programa

    concluir_suma:

        ldr x8, =param1             //contiene el primer valor entero
        ldr x9, [x8]
        ldr x11, =param2            //contiene el segundo valor entero
        ldr x10, [x11]

        add x9, x9, x10

        ldr x10, =v_retorno
        str x9, [x10]               //almacena el resultado en v_retorno

        B exit_programa

    concluir_resta:

        ldr x8, =param1             //contiene el primer valor entero
        ldr x9, [x8]
        ldr x11, =param2            //contiene el segundo valor entero
        ldr x10, [x11]

        sub x9, x9, x10

        ldr x10, =v_retorno
        str x9, [x10]               //almacena el resultado en v_retorno

        B exit_programa

    concluir_multiplicacion:

        ldr x8, =param1             //contiene el primer valor entero
        ldr x9, [x8]
        ldr x11, =param2            //contiene el segundo valor entero
        ldr x10, [x11]

        mul x9, x9, x10

        ldr x10, =v_retorno
        str x9, [x10]               //almacena el resultado en v_retorno

        B exit_programa

    concluir_division:

        ldr x8, =param1             //contiene el primer valor entero
        ldr x9, [x8]
        ldr x11, =param2            //contiene el segundo valor entero
        ldr x10, [x11]

        udiv x9, x9, x10
        cmp x9, 0
        beq error

        ldr x10, =v_retorno
        str x9, [x10]               //almacena el resultado en v_retorno

        B exit_programa

    error:
        print errormsg, lenErrormsg     //muestra mensaje de error de la division entre 0
        input                           // ayuda a mostrar el mensaje de error(de lo contrario no lo muestra y se salta)    
        B insert_command

    concluir_potenciar:

        ldr x8, =param1             //contiene el primer valor entero
        ldr x9, [x8]
        ldr x11, =param2            //contiene el segundo valor entero
        ldr x10, [x11]

        mov x2, 1

        pot_loop:

            mul x2, x2, x9       // x2 = resultado 2, 4, 8
            sub x10, x10, 1      // exponente, 3 = 2, 1 

            cmp x10, 0
            bne pot_loop         // Repetir el bucle

        ldr x10, =v_retorno
        str x2, [x10]               //almacena el resultado en v_retorno

        B exit_programa
    
    concluir_ologico:

        ldr x8, =param1             //contiene el primer valor entero
        ldr x9, [x8]
        ldr x11, =param2            //contiene el segundo valor entero
        ldr x10, [x11]

        orr x9, x9, x10

        ldr x10, =v_retorno
        str x9, [x10]               //almacena el resultado en v_retorno

        B exit_programa

    concluir_oxlogico: //XOR

        ldr x8, =param1             //contiene el primer valor entero
        ldr x9, [x8]
        ldr x11, =param2            //contiene el segundo valor entero
        ldr x10, [x11]

        eor x9, x9, x10             //XOR

        ldr x10, =v_retorno
        str x9, [x10]               //almacena el resultado en v_retorno

        B exit_programa

    concluir_ylogico:

        ldr x8, =param1             //contiene el primer valor entero
        ldr x9, [x8]
        ldr x11, =param2            //contiene el segundo valor entero
        ldr x10, [x11]

        and x9, x9, x10

        ldr x10, =v_retorno
        str x9, [x10]               //almacena el resultado en v_retorno

        B exit_programa

    concluir_nologico: //NOT

        ldr x8, =param1             //contiene el primer valor entero
        ldr x9, [x8]

        mvn x9, x9                  //NOT

        ldr x10, =v_retorno
        str x9, [x10]               //almacena el resultado en v_retorno

        B exit_programa

    
    concluir_llenar:

        adr x2, posicion_param1     
        ldrb w0, [x2]               //0
        adr x3, posicion_param2
        ldrb w1, [x3]               //22
        sub x3, x1, x0              //22
        
        cmp x3, 0
        bgt llenar_fila_positivo
        cmp x3, 0
        blt llenar_fila_negativo
        b exit_programa

        llenar_fila_positivo:

            cmp x3, 10
            bgt llenar_columna_positivo

            mov w27, 1
            bl llenarFilaColumna
            b exit_programa

        llenar_fila_negativo:
            cmp x3, -10
            blt llenar_columna_negativo

            neg x3, x3
            mov w27, -1
            bl llenarFilaColumna
            b exit_programa

        llenar_columna_positivo:
            mov x0, 11
            sdiv x4, x3, x0       //x4=2
            // multiplicar el cociente por el divisor
            mul x5, x4, x0     //x5=22  // x5 = x4 * x0
            // Restar el producto del dividendo para obtener el residuo
            sub x6, x3, x5     //x6=0  // x6 = x3 - (x4 * x0) (residuo)
            mov x3, x4         //x3=2 
            cmp x6, 0
            bne exit

            mov w27, 11
            bl llenarFilaColumna
            b exit_programa

        llenar_columna_negativo:
            mov x0, 11
            sdiv x4, x3, x0         
            // multiplicar el cociente por el divisor
            mul x5, x4, x0       // x5 = x4 * x0
            // Restar el producto del dividendo para obtener el residuo
            sub x6, x3, x5       // x6 = x3 - (x4 * x0) (residuo)
            mov x3, x4
            cmp x6, 0
            bne exit

            neg x3, x3
            mov w27, -11
            bl llenarFilaColumna
            b exit_programa

    concluir_promedio:

        adr x2, posicion_param1  //0
        ldrb w0, [x2]
        adr x3, posicion_param2     //22
        ldrb w1, [x3]
        sub x3, x1, x0          //x3= posicion_param2 - posicion_param1 (x3=22)

        //mov x1, 0
        //mov x1, x3              //x1 = numero de valores

        cmp x3, 0
        bgt fila_positivo
        //cmp x3, 0
        //blt fila_negativo
        b exit_programa

        fila_positivo:

            cmp x3, 10
            bgt columna_positivo

            mov w27, 1
            bl getValues
            udiv x10, x10, x1

            ldr x1, =v_retorno
            str x10, [x1]               //almacena el resultado en v_retorno
            b exit_programa


        columna_positivo:
            mov x0, 11
            sdiv x4, x3, x0             
            // multiplicar el cociente por el divisor
            mul x5, x4, x0       // x5 = x4 * x0
            // Restar el producto del dividendo para obtener el residuo
            sub x6, x3, x5       // x6 = x3 - (x4 * x0) (residuo)
            mov x3, x4          //x3 = 2
            mov x1, x3
            cmp x6, 0
            bne exit

            mov w27, 11
            bl getValues
            add x1, x1, 1
            udiv x10, x10, x1   //x1 = numero de valores

            ldr x1, =v_retorno
            str x10, [x1]               //almacena el resultado en v_retorno

            b exit_programa


        

    concluir_importar:
        //print param1, 5
        bl p_import

        bl imp_data

        b exit_programa

    exit_programa:
        b insert_command
        mov x0, 0
        mov x8, 93
        svc 0
    exit:
        bl printCeldas
        mov x0, 0
        mov x8, 93
        svc 0

    
    

    