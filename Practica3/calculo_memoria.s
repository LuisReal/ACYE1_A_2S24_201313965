.extern _start  //esto es para que si la contraseña ingresada es incorrecta(etiqueta: compararcontra) pueda llamar a el encabezado y menu principal

.global ingresaroperacion

.data

    clear:
        .asciz "\x1B[2J\x1B[H"
        lenClear = . - clear

    msg1:
        .asciz "Ingrese operacion: "
        lenMsg1 = . - msg1

    resultado:
        .asciz "El resultado es: "
        lenResultado = . - resultado

    contrasena:
        .asciz "201313965-exit\n"
        lenContrasena = . - contrasena

    contrasenaincorrecta:
        .asciz "contrasena incorrecta"
        lenContrasenaincorrecta = . - contrasenaincorrecta

    continue:   // esta instruccion solo se usa para pruebas
        .asciz "Si desea continuar presione enter\n"
        lenContinue = . - continue

    errormsg2:
        .asciz "ERROR: No se puede dividir entre 0\n"
        lenErrormsg2 = . - errormsg2

.bss

    result2:
        .space 20   // => Reserva espacion en bytes para result 

    operacion2:
        .space 20   // => Reserva espacion en bytes para operacion

    contraparte1:
        .space 8   // => Reserva espacion en bytes para contraparte1

    contraparte2:
        .space 8   // => Reserva espacion en bytes para contraparte2

    resultNosaltolinea:
        .space 20   // => Reserva espacion en bytes para resultNosaltolinea

//metodo print para imprimir en consola
.macro printM texto, cantidad
    MOV x0, 1
    LDR x1, =\texto
    LDR x2, =\cantidad
    MOV x8, 64        
    SVC 0 
.endm

.macro inputcalculo
    MOV x0, 0
    LDR x1, =operacion2
    LDR x2, =20  //tiene que ser del mismo tamaño de que space = 20
    MOV x8, 63   //obtener de la consola
    SVC 0
.endm

.macro inputmemoria
    MOV x0, 0
    LDR x1, =operacion2
    ADD x1, x1, x7      //guarda en el registro un valor a ingresar en la posicion especificado de x7
    LDR x2, =20         //tiene que ser del mismo tamaño de que space = 20
    MOV x8, 63          //obtener de la consola
    SVC 0
.endm

.text
ingresaroperacion:
   

    printM msg1, lenMsg1
    inputcalculo
    
    getoperando1:

        //obtiene el primer numero ingresado
        ldr x0, =result2		    // load address of result
        mov x3, 0		        // number size = 0
        //18+22
        bl getsize1              //obtiene tamaño de primer numero y guarda el numero en x6
        bl atoi2
        mov x12, x6              //x12 contiene el primer numero

    getoperador:

        //obtiene el signo del operador
        ldr x0, = result2
        ldr x1, =operacion2		// load address of operacion
        mov x3, 0		        // number size = 0
        bl getoperator          //obtiene el signo del operador(mas, resta, mult, div)
        //w11 contiene en valor ascii el signo del operador(+,-,*,/)

    getoperando2:

        //obtiene el segundo numero ingresado
        ldr x0, =result2		    // load address of result
        //no es necesario resetear x3 a 0, ya que se necesita mantener el valor que fue configurado en getoperator (ejemplo: 12+22)
        add x1, x1, x3          //se suma x3 a la direccion de memoria de x1(12+22) para que inicie en el primer digito despues del signo +
        mov x3, 0               //aqui si es necesario resetear x3 a 0
        bl getsize2              //obtiene tamaño del segundo numero y guarda el numero en x6
        bl atoi2
        mov x13, x6             //x13 contiene el segundo numero


    llamaroperacion:    

        cmp w11, 43             //si w11 = 43 (43= valor ascii que corresponde a +)
        beq llamar_suma  

        cmp w11, 45             //si w11 = 45 (45= valor ascii que corresponde a -)
        beq llamar_resta

        cmp w11, 42             //si w11 = 42 (42= valor ascii que corresponde a *)
        beq llamar_multiplicacion

        cmp w11, 47             //si w11 = 47 (47= valor ascii que corresponde a /)
        beq llamar_division


    continuar:

        bl setstring
        mov x15, x7
        printM resultado, lenResultado
        bl printresultado2
        

        printM continue, lenContinue

        inputcalculo
        ldr x14, =contrasena
        mov x3, 0
        bl getsize2                     //obtiene el tamaño de la contrasena ingresada en consola(lo guarda en x3)
        ldr x5, =contraparte1
        ldr x6, =contraparte2
        bl setasciicontra               //guarda la contraseña ingresada en valores ascii en x5 y x6
        ldr x5, =contraparte1           //resetea la direccion de memoria hacia el inicio
        ldr x6, =contraparte2           //resetea la direccion de memoria hacia el inicio
        bl compararcontra

        ldr x0, =result2                 //contiene el resultado con salto de linea
        ldr x2, = resultNosaltolinea
        mov w1, 0                       // Cargar el valor nulo (0) en w1
        mov x4, 0
        mov x7, x15
        bl rmvSaltolinea
        bl printNosaltolinea            //el resultado anterior esta guardado en x2 (en valores ascii)
        ldr x2, = resultNosaltolinea    //vuelve a la primera posicion de memoria
        ldr x1, =operacion2		        //vuelve a la primera posicion de memoria
        mov x4, 0
        bl insertresultado              //ingresa el valor de resultNosaltolinea x2 en x1(solo contiene los digitos sin el salto linea)
        

        inputmemoria                    //lo ingresado lo guarda en x1(en la posicion de memoria especificada por x3)       (en valores ascii)

        
        ldr x1, =operacion2
        b getoperando1

    
    //ret

    /*  
        gdb-multiarch -q --nh \
    -ex 'set architecture aarch64' \
    -ex 'file memoria' \
    -ex 'target remote localhost:1234' \
    -ex 'layout split' \
    -ex 'layout regs' 
    */

    compararcontra:
        stp x29, x30, [sp, #-16]!
        mov x7, 0
        bl compcontra1
        sub x14, x14, 1     //resta 1 a la posicion de memoria para que continue en la siguiente posicion correct
        cmp w10, 1          //si hubo un mensaje de contrasena incorrecta (ver errorcontrasena)
        beq retornocontra
        mov x7, 0
        bl compcontra2
        cmp w10, 1          //si hubo un mensaje de contrasena incorrecta (ver errorcontrasena)
        beq retornocontra
        b _start              //regresa al menu principal

    compcontra1:
        ldrb w8, [x14]
        add x14, x14, 1
        ldrb w9, [x5]
        add x5, x5, 1
        add x7, x7, 1
        cmp x7, 9           //compara si esta fuera de rango de memoria
        beq retorno
        cmp w8, w9
        beq compcontra1
        b errorcontrasena

    errorcontrasena:
        cmp w9, 10           //si se presiono la tecla enter(se registra salto de linea 10 en ascii) y no se ingreso una contrasena
        beq retornocontra
        mov w10, 1
        printM contrasenaincorrecta, lenContrasenaincorrecta
        ret

    retornocontra:
        ldp x29, x30, [sp], #16
        ret

    retorno:
        ret

    compcontra2:
        ldrb w8, [x14]
        add x14, x14, 1
        ldrb w9, [x6] 
        add x6, x6, 1
        add x7, x7, 1
        cmp x7, 8           //compara si esta fuera de rango de memoria
        beq retorno
        cmp w8, w9
        beq compcontra2
        b errorcontrasena

    setasciicontra:
        stp x29, x30, [sp, #-16]!
        mov x29, sp 

        mov x7, 0
        bl setcontraparte1
        mov x7, 0
        bl setcontraparte2

        ldp x29, x30, [sp], #16
        ret
    
    setcontraparte1:
        ldrb w8, [x1]       //obtiene el valor y lo convierte a ascii   
        add x1, x1, 1
        strb w8, [x5]       //guarda el valor ascii en el registro x5(los primeros 8 bytes de x1)
        add x5, x5, 1
        add x7, x7, 1
        cmp x7, 8
        bne setcontraparte1
        ret

    setcontraparte2:
        ldrb w8, [x1]       //obtiene el valor y lo convierte a ascii   
        add x1, x1, 1
        strb w8, [x6]       //guarda el valor ascii en el registro x6(los siguientes 7 bytes de x1)
        add x6, x6, 1
        add x7, x7, 1
        cmp x7, 7
        bne setcontraparte2
        ret

    insertresultado:    //ingresa el valor de resultNosaltolinea x2 en x1(solo contiene los digitos sin el salto linea)
        ldrb w8, [x2]
        add x2, x2, 1
        strb w8, [x1]
        add x1, x1, 1
        add x4, x4, 1
        cmp x4, x7       //x7 contiene el numero de digitos de resultNosaltolinea
        bne insertresultado
        ret

    rmvSaltolinea: //elimina el salto de linea guardado en result
        
        ldrb w8, [x0]
        strb w8, [x2]
        add x0, x0, 1
        add x2, x2, 1
        add x4, x4, 1 
        cmp x4, x7
        bne rmvSaltolinea
        ret

    printNosaltolinea:
		mov x0, 1		    // stdout
		ldr x1, =resultNosaltolinea		// load resultNosaltolinea
		mov x2, x7		    // x7 contiene el tamaño
		mov x8, 64		    // write syscall_num
		svc 0			    // syscall
        ret

    printresultado2:
		mov x0, 1		    // stdout
		ldr x1, =result2		// load str
		mov x2, x3		    // str size
		mov x8, 64		    // write syscall_num
		svc 0			    // syscall
        ret


    /*  
        gdb-multiarch -q --nh \
    -ex 'set architecture aarch64' \
    -ex 'file memoria' \
    -ex 'target remote localhost:1234' \
    -ex 'layout split' \
    -ex 'layout regs' 
    */
    llamar_suma:
        bl suma
        b continuar

    llamar_resta:
        bl resta
        b continuar

    llamar_multiplicacion:
        bl multiplicacion
        b continuar

    llamar_division:
        bl division
        b continuar

    suma:
        add x12, x12, x13
        ret

    resta:
        sub x12, x12, x13
        ret

    multiplicacion:
        mul x12, x12, x13
        ret

    division:
        udiv x12, x12, x13
        cmp x12, 0
        beq error
        ret

    error:
        printM errormsg2, lenErrormsg2     //muestra mensaje de error de la division entre 0
        inputcalculo                       // ayuda a mostrar el mensaje de error(de lo contrario no lo muestra y se salta)    
        b _start

    getsize1: //ascii a integer
        //18+22
    
		ldrb w9, [x1]      	//obtiene el primer valor ascii
		add x1, x1, 1       //incremento en 1 la direccion de memoria
		add x3, x3, 1		// increment size (para obtener la cantidad de digitos incluyendo salto de linea)
		
        cmp w9, 43          // if w9 == 43 (43=valor ascii de signo +)
		beq encontrado

        cmp w9, 45          // if w9 == 45 (45=valor ascii de signo -)
		beq encontrado

        cmp w9, 42          // if w9 == 42 (42=valor ascii de signo *)
		beq encontrado
        
        cmp w9, 47          // if w9 == 47 (47=valor ascii de signo /)
		beq encontrado

        b getsize1

    encontrado:
        sub x1, x1, x3       
        sub x3, x3, 1        
        mov x4, x3           
        ret                  
    
    getsize2: //ascii a integer
        //18+22
    
		ldrb w9, [x1]      	//obtiene el primer valor ascii
		add x1, x1, 1       //incremento en 1 la direccion de memoria
		add x3, x3, 1		// increment size (para obtener la cantidad de digitos incluyendo salto de linea)
		cmp w9, 10          
		bne getsize2
		sub x1, x1, x3      //reset direccion de memoria de x1
		sub x3, x3, 1       //decrementa 1 para no contar salto de linea ascii=10
		mov x4, x3
        ret 

    atoi2:
		ldrb w9, [x1]		//vuelve a obtener valor ascii desde el inicio
		sub w9, w9, 48      //convierte de ascii a entero
		strb w9, [x0]       //guarda el entero en memoria de x0
		add x0, x0, 1       //incrementa la direccion de memoria en 1
		add x1, x1, 1       //incrementa la direccion de memoria en 1
		sub x3, x3, 1		// decrementa x3 en 1
		cmp x3, 0           // if x3 != 0
		bne atoi2


	setaddress:
		ldr x2, =result2     // Cargar la dirección de memoria donde están los enteros
		mov x6, 0           // Aquí guardaremos el número completo
		mov x7, 1           // Inicializar un multiplicador para la posición de las unidades (comenzamos con 1)
		mov x5, 10
		add x2, x2, x4      //para empezar desde la ultima celda hacia la primera celda de memoria
		sub x2, x2, 1       //resta 1 a para que solo cuente 5 posiciones de memoria

	getnumber:
		ldrb w9, [x2]        // Cargar el siguiente byte (dígito) desde memoria y avanzar la dirección
		mul x10, x9, x7      // Multiplicar el dígito por el multiplicador actual (x7)
		add x6, x6, x10      // Sumar el resultado al número acumulado (x6)
		mul x7, x7, x5       // Aumentar el multiplicador (x10, x100, x1000, etc.)
		sub x2, x2, 1        // decrementa direccion de memoria
		cmp x4, 0            // Verificar si hay más dígitos
		sub x4, x4, 1        // incrementar el contador de dígitos
		bne getnumber        // Repetir si aún hay dígitos por procesar
		ret


    getoperator:
        ldrb w9, [x1]      	//obtiene el primer valor ascii
		add x1, x1, 1       //incremento en 1 la direccion de memoria
		add x3, x3, 1		// increment size (para obtener la cantidad de digitos incluyendo salto de linea)
		//cmp w9, 43          // if w9 != 43 (43=valor ascii de signo +)
		//bne getoperator
		
        cmp w9, 43          // if w9 == 43 (43=valor ascii de signo +)
		beq encontrado2

        cmp w9, 45          // if w9 == 45 (45=valor ascii de signo -)
		beq encontrado2

        cmp w9, 42          // if w9 == 42 (42=valor ascii de signo *)
		beq encontrado2
        
        cmp w9, 47          // if w9 == 47 (47=valor ascii de signo /)
		beq encontrado2

        b getoperator
        

    encontrado2:
        sub x1, x1, x3      //reset direccion de memoria de x1
		mov w11, w9         //guarda el valor ascii de +(43) en w10
        ret
    //convierte a ascii(string) el resultado de (suma, resta)

	setstring:
		ldr x0, =result2		// load address of result
		mov x1, x12			// number to convert (x12 contiene el resultado de la operacion)
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
        mov x7, x5          // mueve el contador a x7 para usarlo posteriormente en etiqueta noSaltolinea


	setascii:	
		ldrb w9, [x0]		// load left digit(carga de la memoria al registro)
		add w9, w9, 48		// set ascii
		strb w9, [x0]		// store ascii
		add x0, x0, 1		// increment offset
		sub x5, x5, 1		// decrement iter
		cmp x5, 0		    // if iter != 0
		bne setascii		// goto setascii
		ret
