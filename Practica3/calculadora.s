.extern ingresaroperacion //para poder usar el archivo externo calculo_memoria.s

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
        .asciz "Ingresando Resta\n"
        lenRestaText = . - restaText

    multiplicacionText:
        .asciz "Ingresando Multiplicacion\n"
        lenMultiplicacionText = . - multiplicacionText

    divisionText:
        .asciz "Ingresando Division\n"
        lenDivisionText = . - divisionText
    
    operacionesText:
        .asciz "Ingresando Operaciones\n"
        lenOperacionesText = . - operacionesText

    numero1:
        .asciz "Ingrese numero 1: \n"
        lenNumero1 = . - numero1

    numero2:
        .asciz "Ingrese numero 2: \n"
        lenNumero2 = . - numero2

    resultado:
        .asciz "El resultado es: "
        lenResultado = . - resultado

    operacionCompleta:
        .asciz "Ingrese operacion completa: "
        lenOperacionCompleta = . - operacionCompleta

    continuar:
        .asciz "Debe presionar la tecla enter para continuar\n"
        lenContinuar = . - continuar
    
    errormsg:
        .asciz "ERROR: No se puede dividir entre 0\n"
        lenErrormsg = . - errormsg

    operacionComa:
        .asciz "Ingrese los numeros separados por coma: "
        lenOperacionComa = . - operacionComa

    msg:
        .asciz "Ingrese operacion: "
        lenMsg = . - msg

.bss
    opcion:
        .space 5

    num:
        .space 20   // => Reserva espacion en bytes para num
   
    result:
        .space 20   // => Reserva espacion en bytes para result 
    
    operacion:
        .space 20   // => Reserva espacion en bytes para operacion

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
/* 
.macro inputcalculo
    MOV x0, 0
    LDR x1, =operacion
    LDR x2, =20  //tiene que ser del mismo tamaño de que space = 20
    MOV x8, 63   //obtener de la consola
    SVC 0
.endm
*/
.macro input2
    MOV x0, 0
    LDR x1, =num
    LDR x2, =20
    MOV x8, 63   //obtener de la consola
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

    CMP w10, 54  // 54 es en codigo ascii que equivale a 6, termina el programa
    BEQ end

    suma:
        print sumaText, lenSumaText

        print numero1, lenNumero1
        input2

        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        bl getsize          //llama a la etiqueta getsize
        mov x12, x6

        print numero2, lenNumero2
        input2
        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        
        bl getsize           //llama a la etiqueta getsize
        mov x13, x6

        add x12, x12, x13

        bl setstring
        print resultado, lenResultado
        bl printresultado
        print continuar, lenContinuar

        //aqui se evalua el ingreso de una operacion completa 10+5
        input
        
        print operacionCompleta, lenOperacionCompleta

        input2
        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        
        bl getsizenum1           //llama a la etiqueta getsize2
        bl atoi
        mov x12, x6              //x12 contiene el primer numero

        
        //obtiene el signo del operador
        ldr x0, = result
        //ldr x1, =operacion		// load address of operacion
        mov x3, 0		        // number size = 0
        bl getoperator2          //obtiene el signo del operador(mas, resta, mult, div)
        

        //obtiene el segundo numero ingresado
        ldr x0, =result		    // load address of result
        //no es necesario resetear x3 a 0, ya que se necesita mantener el valor que fue configurado en getoperator (ejemplo: 12+22)
        add x1, x1, x3          //se suma x3 a la direccion de memoria de x1(12+22) para que inicie en el primer digito despues del signo +
        mov x3, 0               //aqui si es necesario resetear x3 a 0
        bl getsizenum2              //obtiene tamaño del segundo numero y guarda el numero en x6
        bl atoi
        mov x13, x6             //x13 contiene el segundo numero

        add x12, x12, x13       //suma los valores

        bl setstring            //convierte el resultado del registro x12 a ascii para poder imprimirlo en consola

        //mov x15, x7
        print resultado, lenResultado
        bl printresultado

        print continuar, lenContinuar

        //aqui se evalua el ingreso de numeros separados por comas 10,5

        input
        
        print operacionComa, lenOperacionComa

        input2
        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        
        bl getsizenum1           //llama a la etiqueta getsize2
        bl atoi
        mov x12, x6              //x12 contiene el primer numero

        
        //obtiene el signo del operador
        ldr x0, = result
        //ldr x1, =operacion		// load address of operacion
        mov x3, 0		        // number size = 0
        bl getoperator2          //obtiene el signo del operador(mas, resta, mult, div)
        

        //obtiene el segundo numero ingresado
        ldr x0, =result		    // load address of result
        //no es necesario resetear x3 a 0, ya que se necesita mantener el valor que fue configurado en getoperator (ejemplo: 12+22)
        add x1, x1, x3          //se suma x3 a la direccion de memoria de x1(12+22) para que inicie en el primer digito despues del signo +
        mov x3, 0               //aqui si es necesario resetear x3 a 0
        bl getsizenum2              //obtiene tamaño del segundo numero y guarda el numero en x6
        bl atoi
        mov x13, x6             //x13 contiene el segundo numero

        add x12, x12, x13       //suma los valores

        bl setstring            //convierte el resultado del registro x12 a ascii para poder imprimirlo en consola

        //mov x15, x7
        print resultado, lenResultado
        bl printresultado

        print continuar, lenContinuar
        
        B cont // B = branch incondicional - se va a cont

    resta:
        /*  
        gdb-multiarch -q --nh \
        -ex 'set architecture aarch64' \
        -ex 'file programa' \
        -ex 'target remote localhost:1234' \
        -ex 'layout split' \
        -ex 'layout regs' 
        */
        print restaText, lenRestaText

        print numero1, lenNumero1
        input2
        
        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        bl getsize          //llama a la etiqueta getsize
        mov x12, x6

        print numero2, lenNumero2
        input2
        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        
        bl getsize           //llama a la etiqueta getsize
        mov x13, x6

        sub x12, x12, x13

        bl setstring
        print resultado, lenResultado
        bl printresultado
        print continuar, lenContinuar

        //aqui se evalua el ingreso de una operacion completa 10-5
        input

        print operacionCompleta, lenOperacionCompleta

        input2
        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        
        bl getsizenum1           //llama a la etiqueta getsize2
        bl atoi
        mov x12, x6              //x12 contiene el primer numero

        
        //obtiene el signo del operador
        ldr x0, = result
        //ldr x1, =operacion		// load address of operacion
        mov x3, 0		        // number size = 0
        bl getoperator2          //obtiene el signo del operador(mas, resta, mult, div)
        

        //obtiene el segundo numero ingresado
        ldr x0, =result		    // load address of result
        //no es necesario resetear x3 a 0, ya que se necesita mantener el valor que fue configurado en getoperator (ejemplo: 12+22)
        add x1, x1, x3          //se suma x3 a la direccion de memoria de x1(12+22) para que inicie en el primer digito despues del signo +
        mov x3, 0               //aqui si es necesario resetear x3 a 0
        bl getsizenum2              //obtiene tamaño del segundo numero y guarda el numero en x6
        bl atoi
        mov x13, x6             //x13 contiene el segundo numero

        sub x12, x12, x13       //suma los valores

        bl setstring            //convierte el resultado del registro x12 a ascii para poder imprimirlo en consola

        //mov x15, x7
        print resultado, lenResultado
        bl printresultado

        print continuar, lenContinuar

        //aqui se evalua el ingreso de numeros separados por comas 10,5

        input
        
        print operacionComa, lenOperacionComa

        input2
        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        
        bl getsizenum1           //llama a la etiqueta getsize2
        bl atoi
        mov x12, x6              //x12 contiene el primer numero

        
        //obtiene el signo del operador
        ldr x0, = result
        //ldr x1, =operacion		// load address of operacion
        mov x3, 0		        // number size = 0
        bl getoperator2          //obtiene el signo del operador(mas, resta, mult, div)
        

        //obtiene el segundo numero ingresado
        ldr x0, =result		    // load address of result
        //no es necesario resetear x3 a 0, ya que se necesita mantener el valor que fue configurado en getoperator (ejemplo: 12+22)
        add x1, x1, x3          //se suma x3 a la direccion de memoria de x1(12+22) para que inicie en el primer digito despues del signo +
        mov x3, 0               //aqui si es necesario resetear x3 a 0
        bl getsizenum2              //obtiene tamaño del segundo numero y guarda el numero en x6
        bl atoi
        mov x13, x6             //x13 contiene el segundo numero

        sub x12, x12, x13       //suma los valores

        bl setstring            //convierte el resultado del registro x12 a ascii para poder imprimirlo en consola

        //mov x15, x7
        print resultado, lenResultado
        bl printresultado

        print continuar, lenContinuar

        B cont // B = branch incondicional - se va a cont

    multiplicacion:
        print multiplicacionText, lenMultiplicacionText

        print numero1, lenNumero1
        input2
        
        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        bl getsize          //llama a la etiqueta getsize
        mov x12, x6

        print numero2, lenNumero2
        input2
        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        
        bl getsize           //llama a la etiqueta getsize
        mov x13, x6

        mul x12, x12, x13

        bl setstring
        print resultado, lenResultado
        bl printresultado
        print continuar, lenContinuar

        //Aqui se evalua una operacion completa
        input

        print operacionCompleta, lenOperacionCompleta

        input2
        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        
        bl getsizenum1           //llama a la etiqueta getsize2
        bl atoi
        mov x12, x6              //x12 contiene el primer numero

        
        //obtiene el signo del operador
        ldr x0, = result
        //ldr x1, =operacion		// load address of operacion
        mov x3, 0		        // number size = 0
        bl getoperator2          //obtiene el signo del operador(mas, resta, mult, div)
        

        //obtiene el segundo numero ingresado
        ldr x0, =result		    // load address of result
        //no es necesario resetear x3 a 0, ya que se necesita mantener el valor que fue configurado en getoperator (ejemplo: 12+22)
        add x1, x1, x3          //se suma x3 a la direccion de memoria de x1(12+22) para que inicie en el primer digito despues del signo +
        mov x3, 0               //aqui si es necesario resetear x3 a 0
        bl getsizenum2              //obtiene tamaño del segundo numero y guarda el numero en x6
        bl atoi
        mov x13, x6             //x13 contiene el segundo numero

        mul x12, x12, x13       //suma los valores

        bl setstring            //convierte el resultado del registro x12 a ascii para poder imprimirlo en consola

        //mov x15, x7
        print resultado, lenResultado
        bl printresultado

        print continuar, lenContinuar

        //aqui se evalua el ingreso de numeros separados por comas 10,5

        input
        
        print operacionComa, lenOperacionComa

        input2
        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        
        bl getsizenum1           //llama a la etiqueta getsize2
        bl atoi
        mov x12, x6              //x12 contiene el primer numero

        
        //obtiene el signo del operador
        ldr x0, = result
        //ldr x1, =operacion		// load address of operacion
        mov x3, 0		        // number size = 0
        bl getoperator2          //obtiene el signo del operador(mas, resta, mult, div)
        

        //obtiene el segundo numero ingresado
        ldr x0, =result		    // load address of result
        //no es necesario resetear x3 a 0, ya que se necesita mantener el valor que fue configurado en getoperator (ejemplo: 12+22)
        add x1, x1, x3          //se suma x3 a la direccion de memoria de x1(12+22) para que inicie en el primer digito despues del signo +
        mov x3, 0               //aqui si es necesario resetear x3 a 0
        bl getsizenum2              //obtiene tamaño del segundo numero y guarda el numero en x6
        bl atoi
        mov x13, x6             //x13 contiene el segundo numero

        mul x12, x12, x13       //suma los valores

        bl setstring            //convierte el resultado del registro x12 a ascii para poder imprimirlo en consola

        //mov x15, x7
        print resultado, lenResultado
        bl printresultado

        print continuar, lenContinuar

        B cont // B = branch incondicional - se va a cont

    division:
        print divisionText, lenDivisionText

        print numero1, lenNumero1
        input2
        
        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        bl getsize          //llama a la etiqueta getsize
        mov x12, x6

        print numero2, lenNumero2
        input2
        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        
        bl getsize           //llama a la etiqueta getsize
        mov x13, x6

        udiv x12, x12, x13
        cmp x12, 0
        beq error

        bl setstring
        print resultado, lenResultado
        bl printresultado
        print continuar, lenContinuar

        //Aqui se evalua una operacion completa
        input

        print operacionCompleta, lenOperacionCompleta

        input2
        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        
        bl getsizenum1           //llama a la etiqueta getsize2
        bl atoi
        mov x12, x6              //x12 contiene el primer numero

        
        //obtiene el signo del operador
        ldr x0, = result
        //ldr x1, =operacion		// load address of operacion
        mov x3, 0		        // number size = 0
        bl getoperator2          //obtiene el signo del operador(mas, resta, mult, div)
        

        //obtiene el segundo numero ingresado
        ldr x0, =result		    // load address of result
        //no es necesario resetear x3 a 0, ya que se necesita mantener el valor que fue configurado en getoperator (ejemplo: 12+22)
        add x1, x1, x3          //se suma x3 a la direccion de memoria de x1(12+22) para que inicie en el primer digito despues del signo +
        mov x3, 0               //aqui si es necesario resetear x3 a 0
        bl getsizenum2              //obtiene tamaño del segundo numero y guarda el numero en x6
        bl atoi
        mov x13, x6             //x13 contiene el segundo numero

        udiv x12, x12, x13       //suma los valores
        cmp x12, 0
        beq error

        bl setstring            //convierte el resultado del registro x12 a ascii para poder imprimirlo en consola

        //mov x15, x7
        print resultado, lenResultado
        bl printresultado

        print continuar, lenContinuar

        //aqui se evalua el ingreso de numeros separados por comas 10,5

        input
        
        print operacionComa, lenOperacionComa

        input2
        ldr x0, =result		// load address of result
        mov x3, 0		    // number size = 0
        
        bl getsizenum1           //llama a la etiqueta getsize2
        bl atoi
        mov x12, x6              //x12 contiene el primer numero

        
        //obtiene el signo del operador
        ldr x0, = result
        //ldr x1, =operacion		// load address of operacion
        mov x3, 0		        // number size = 0
        bl getoperator2          //obtiene el signo del operador(mas, resta, mult, div)
        

        //obtiene el segundo numero ingresado
        ldr x0, =result		    // load address of result
        //no es necesario resetear x3 a 0, ya que se necesita mantener el valor que fue configurado en getoperator (ejemplo: 12+22)
        add x1, x1, x3          //se suma x3 a la direccion de memoria de x1(12+22) para que inicie en el primer digito despues del signo +
        mov x3, 0               //aqui si es necesario resetear x3 a 0
        bl getsizenum2              //obtiene tamaño del segundo numero y guarda el numero en x6
        bl atoi
        mov x13, x6             //x13 contiene el segundo numero

        udiv x12, x12, x13       //suma los valores
        cmp x12, 0
        beq error

        bl setstring            //convierte el resultado del registro x12 a ascii para poder imprimirlo en consola

        //mov x15, x7
        print resultado, lenResultado
        bl printresultado

        print continuar, lenContinuar

        B cont // B = branch incondicional - se va a cont
    
    operacion_memoria:

        b ingresaroperacion //llama a la etiqueta ingresaroperacion que esta en el archivo externo calculo_memoria.s


    cont:
        input   // es importante agregar este input para poder irse a menu(presionar enter para continuar)
        B menu // B = branch incondicional - se va a menu, lo cual simula un ciclo while

    error:
        print errormsg, lenErrormsg     //muestra mensaje de error de la division entre 0
        input                           // ayuda a mostrar el mensaje de error(de lo contrario no lo muestra y se salta)    
        B menu

    printresultado:
        mov x0, 1		    // stdout
        ldr x1, =result		// load str
        mov x2, x3		    // str size
        mov x8, 64		    // write syscall_num
        svc 0			    // syscall
        ret

    getsizenum1: //ascii a integer
        //18+22
    
		ldrb w9, [x1]      	//obtiene el primer valor ascii
		add x1, x1, 1       //incremento en 1 la direccion de memoria
		add x3, x3, 1		// increment size (para obtener la cantidad de digitos incluyendo salto de linea)
		
        cmp w9, 43          // if w9 == 43 (43=valor ascii de signo +)
		beq encontradonum1

        cmp w9, 45          // if w9 == 45 (45=valor ascii de signo -)
		beq encontradonum1

        cmp w9, 42          // if w9 == 42 (42=valor ascii de signo *)
		beq encontradonum1
        
        cmp w9, 47          // if w9 == 47 (47=valor ascii de signo /)
		beq encontradonum1

        cmp w9, 44          // if w9 == 44 (44=valor ascii de signo ,)
		beq encontradonum1

        b getsizenum1

    encontradonum1:
        sub x1, x1, x3       
        sub x3, x3, 1        
        mov x4, x3           
        ret  

    getsizenum2: //calcula el tamaño del segundo entero con salto de linea
        //18+22
    
		ldrb w9, [x1]      	//obtiene el primer valor ascii
		add x1, x1, 1       //incremento en 1 la direccion de memoria
		add x3, x3, 1		// increment size (para obtener la cantidad de digitos incluyendo salto de linea)
		cmp w9, 10          
		bne getsizenum2
		sub x1, x1, x3      //reset direccion de memoria de x1
		sub x3, x3, 1       //decrementa 1 para no contar salto de linea ascii=10
		mov x4, x3
        ret 

    getoperator2:
        ldrb w9, [x1]      	//obtiene el primer valor ascii
		add x1, x1, 1       //incremento en 1 la direccion de memoria
		add x3, x3, 1		// increment size (para obtener la cantidad de digitos incluyendo salto de linea)
		//cmp w9, 43          // if w9 != 43 (43=valor ascii de signo +)
		//bne getoperator
		
        cmp w9, 43          // if w9 == 43 (43=valor ascii de signo +)
		beq encontrado3

        cmp w9, 45          // if w9 == 45 (45=valor ascii de signo -)
		beq encontrado3

        cmp w9, 42          // if w9 == 42 (42=valor ascii de signo *)
		beq encontrado3
        
        cmp w9, 47          // if w9 == 47 (47=valor ascii de signo /)
		beq encontrado3

        cmp w9, 44          // if w9 == 44 (44=valor ascii de signo ,)
		beq encontrado3

        b getoperator2
        

    encontrado3:
        sub x1, x1, x3      //reset direccion de memoria de x1
		mov w11, w9         //guarda el valor ascii de +(43) en w10
        ret


    //convierte a entero el valor ingresado por consola

	getsize: //ascii a integer
    
		ldrb w9, [x1]      	//obtiene el primer valor ascii
		add x1, x1, 1       //incremento en 1 la direccion de memoria
		add x3, x3, 1		// increment size (para obtener la cantidad de digitos incluyendo salto de linea)
		cmp w9, 10          // if w9 != 10 (10=valor ascii de nueva linea)
		bne getsize
		sub x1, x1, x3      //reset direccion de memoria de x1
		sub x3, x3, 1       //decrementa 1 para no contar salto de linea ascii=10
		mov x4, x3

	atoi:
		ldrb w9, [x1]		//vuelve a obtener valor ascii desde el inicio
		sub w9, w9, 48      //convierte de ascii a entero
		strb w9, [x0]       //guarda el entero en memoria de x0
		add x0, x0, 1       //incrementa la direccion de memoria en 1
		add x1, x1, 1       //incrementa la direccion de memoria en 1
		sub x3, x3, 1		// decrementa x3 en 1
		cmp x3, 0           // if x3 != 0
		bne atoi

	setaddress:
		ldr x2, =result   // Cargar la dirección de memoria donde están los enteros
		mov x6, 0         // Aquí guardaremos el número completo
		mov x7, 1         // Inicializar un multiplicador para la posición de las unidades (comenzamos con 1)
		mov x5, 10
		add x2, x2, x4        //para empezar desde la ultima celda hacia la primera celda de memoria
		sub x2, x2, 1         //resta 1 a para que solo cuente 5 posiciones de memoria

	getnumber:
		ldrb w9, [x2]        // Cargar el siguiente byte (dígito) desde memoria y avanzar la dirección
		mul x10, x9, x7      // Multiplicar el dígito por el multiplicador actual (x7)
		add x6, x6, x10      // Sumar el resultado al número acumulado (x6)
		mul x7, x7, x5       // Aumentar el multiplicador (x10, x100, x1000, etc.)
		sub x2, x2, 1        // decrementa direccion de memoria
		cmp x4, 0            // Verificar si hay más dígitos
		sub x4, x4, 1        // incrementar el contador de dígitos
		bne getnumber   // Repetir si aún hay dígitos por procesar
		ret


	//convierte a ascii(string) el resultado de (suma, resta)

	setstring:
		ldr x0, =result		// load address of result
		mov x1, x12			// number to convert
		mov x2, 10		    // base number
		mov x3, 0		    // number size = 0
		mov x4, x1		    // copy of number

	getsizeString:
		udiv x4, x4, x2		// remove last digit
		add x3, x3, 1		// increment size  (siguiente posicion)
		cmp x4, 0		    // if number != 0  (fin de cadena)
		bne getsizeString		    // goto getsize
		
		add x0, x0, x3		// str addr offset
		mov w5, 10		    // newline ascii
		strb w5, [x0]		// store newline
		sub x0, x0, 1		// decrement offset
		add x3, x3, 1		// str final size
		mov x4, x1		    // copy of number 
		mov x5, 0		    // iter number = 0
		
	getdigit:
		udiv x6, x4, x2		// remove last digit	
		msub x7, x6, x2, x4	// last digit
		add x5, x5, 1		// increment iter
		strb w7, [x0]		// store last digit
		sub x0, x0, 1		// decrement offset
		mov x4, x6		    // number remain
		cmp x4, 0		    // if number != 0
		bne getdigit		// goto getdigit
		add x0, x0, 1		// reset addrgdb-multiarch -q --nh \


	setascii:	
		ldrb w9, [x0]		// load left digit(carga de la memoria al registro)
		add w9, w9, 48		// set ascii
		strb w9, [x0]		// store ascii
		add x0, x0, 1		// increment offset
		sub x5, x5, 1		// decrement iter
		cmp x5, 0		    // if iter != 0
		bne setascii		// goto setascii
		ret

    end:
        mov x0, 0   // Codigo de error de la aplicacion -> 0: no hay error
        mov x8, 93  // Codigo de la llamada al sistema
        svc 0       // Ejecutar la llamada al sistema
