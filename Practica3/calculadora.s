.global _start

.data
    encabezado:
        .asciz "Universidad de San Carlos de Guatemala\n"
        .asciz "Facultad de Ingenieria\n"
        .asciz "Escuela de Ciencias y Sistemas\n"
        .asciz "Arquitectura de Computadores y Ensambladores 1\n"
        .asciz "Seccion A\n"
        .asciz "Luis Fernando Gonzalez Real\n"
        .asciz "201313965\n"
        lenEncabezado = . - encabezado

    menu:
        .asciz ">> Menu Principal\n"
        .asciz "1. Suma\n"
        .asciz "2. Resta\n"
        .asciz "3. Multiplicacion\n"
        .asciz "4. Division\n"
        .asciz "5. Calculo Con Memoria\n"
        .asciz "6. Salir\n"
        lenMenu = .- menu

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


.text
_start:
    mov x0, 1
    ldr x1, =encabezado
    ldr x2, =lenEncabezado
    mov x8, 64
    svc 0

    end:
        mov x0, 0   // Codigo de error de la aplicacion -> 0: no hay error
        mov x8, 93  // Codigo de la llamada al sistema
        svc 0       // Ejecutar la llamada al sistema