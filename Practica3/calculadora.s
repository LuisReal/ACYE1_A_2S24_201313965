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
.text
_start:

    end:
        mov x0, 0   // Codigo de error de la aplicacion -> 0: no hay error
        mov x8, 93  // Codigo de la llamada al sistema
        svc 0       // Ejecutar la llamada al sistema