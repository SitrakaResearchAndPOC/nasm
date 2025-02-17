section .data
    message db 'Hello, World!', 0xA  ; Message
    length equ $ - message            ; Calculer la longueur du message

    newline db 0xA  ; Saut de ligne
    newline_len equ $ - newline

section .text
    global _start

_start:
    ; Écriture du message sur la sortie standard (stdout)
    mov eax, 4      ; syscall sys_write
    mov ebx, 1      ; file descriptor 1 (stdout)
    mov ecx, message ; adresse du message
    mov edx, length ; longueur du message
    int 0x80        ; appel système

    ; Écriture du saut de ligne
    mov eax, 4      ; syscall sys_write
    mov ebx, 1      ; file descriptor 1 (stdout)
    mov ecx, newline ; adresse du saut de ligne
    mov edx, newline_len ; longueur du saut de ligne
    int 0x80        ; appel système

    ; Sortie propre du programme
    mov eax, 1      ; syscall sys_exit
    xor ebx, ebx    ; code de retour 0
    int 0x80        ; appel système