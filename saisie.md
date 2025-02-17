# SAISIR ET AFFICHER EN NASM
```
nano mon_programme.asm
```
```
section .bss
    num resb 10   ; Réserver de l'espace pour stocker l'entrée utilisateur

section .data
    msg db "Entrez un nombre :", 0xA   ; Message à afficher
    len_msg equ $ - msg                 ; Longueur du message
    newline db 0xA                      ; Saut de ligne

section .text
    global _start

_start:
    ; Afficher le message
    mov eax, 4        ; syscall write
    mov ebx, 1        ; descripteur de fichier (stdout)
    mov ecx, msg      ; adresse du message
    mov edx, len_msg  ; longueur du message
    int 0x80

    ; Lire l'entrée utilisateur
    mov eax, 3        ; syscall read
    mov ebx, 0        ; descripteur de fichier (stdin)
    mov ecx, num      ; adresse du tampon
    mov edx, 10       ; nombre de caractères à lire
    int 0x80

    ; Afficher le nombre saisi
    mov eax, 4        ; syscall write
    mov ebx, 1        ; descripteur de fichier (stdout)
    mov ecx, num      ; adresse du tampon contenant le nombre
    mov edx, 10       ; longueur du tampon
    int 0x80

    ; Afficher un saut de ligne
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Quitter proprement
    mov eax, 1        ; syscall exit
    xor ebx, ebx      ; code de sortie 0
    int 0x80
```
```
nasm -f elf32 mon_programme.asm -o mon_programme.o
```
```
gcc -m32  mon_programme.o -o mon_programme.elf -nostartfiles
```
OU
```
ld -m elf_i386 mon_programme.o -o mon_programme.elf
```
```
chmod +x mon_programme.elf
```
```
./mon_programme.elf
```
