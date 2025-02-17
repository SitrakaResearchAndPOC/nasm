;
; file: skel.asm
; This file is a skeleton that can be used to start assembly programs.

%include "asm_io.inc"
segment .data
;
; initialized data is put in the data segment here
;


segment .bss
;
; uninitialized data is put in the bss segment
;

segment .text
        global  asm_main
asm_main:
; MODIFICATION WITHOUT WRAPPING C
;        enter   0,0               ; setup routine
;        pusha

;
; code is put in the text segment. Do not modify the code before
; or after this comment.
;

; MODIFICATION WITHOUT WRAPPING C
;        popa
;        mov     eax, 0            ; return back to C
;        leave                     
;        ret

; MODIFICATION ADDED FOR RETUN 
    ; Sortie propre du programme
    mov eax, 1      ; syscall sys_exit
    xor ebx, ebx    ; code de retour 0
    int 0x80        ; appel système