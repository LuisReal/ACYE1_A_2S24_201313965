.section .text
    .global _start

_start:
// syscall write(int fd, const void *buf, size_t count)
    mov x0, #1    
    adr x1, msg
    mov x2, len
    mov w8, #64 /*Syscall number for write for ARM64*/
    svc #0

// syscall exit(int status)
    mov x0, #0
    mov w8, #93 /*Syscall number for exit for ARM64*/
    svc #0

msg:
    .asciz "Hello World!\n"
    len = . - msg