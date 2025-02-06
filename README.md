# nasm
```
section .data
    msg db 'Hello, World!', 0xA  ; Message avec saut de ligne
    len equ $ - msg  ; Longueur du message

section .text
    global _start

_start:
    ; Écriture du message sur la sortie standard (stdout)
    mov eax, 4      ; syscall sys_write
    mov ebx, 1      ; file descriptor 1 (stdout)
    mov ecx, msg    ; adresse du message
    mov edx, len    ; longueur du message
    int 0x80        ; appel système

    ; Sortie propre du programme
    mov eax, 1      ; syscall sys_exit
    xor ebx, ebx    ; code de retour 0
    int 0x80        ; appel système
```
```
nasm -f elf hello.asm -o hello.o
```
```
ld -m elf_i386 hello.o -o hello
```
```
./hello
```

