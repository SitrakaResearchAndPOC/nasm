# Installation des dependances
Installation en windows
# HELLO WORLD : nasm
```
notepad++ hello.asm
```
```
section .data
    msg db 'Hello, World!', 0xA  ; Message avec saut de ligne
    len equ $ - msg  ; Longueur du message

section .text
    extern _GetStdHandle@4, _WriteConsoleA@20, _ExitProcess@4
    global _start

_start:
    ; Obtenir le handle de la sortie standard (console)
    push -11              ; STD_OUTPUT_HANDLE
    call _GetStdHandle@4  ; Appel de GetStdHandle

    ; Sauvegarder le handle retourné dans ebx
    mov ebx, eax

    ; Appel à WriteConsoleA pour afficher le message
    push 0                ; lpNumberOfCharsWritten (pas nécessaire ici)
    push len              ; nombre de caractères à écrire
    lea eax, [msg]        ; Charger l'adresse de msg dans eax
    push eax              ; adresse du message
    push ebx              ; handle de la sortie standard
    call _WriteConsoleA@20 ; Appel de WriteConsoleA

    ; Terminer proprement le programme
    push 0                ; code de retour
    call _ExitProcess@4   ; Appel de ExitProcess
```
```
nasm -f win32 hello.asm -o hello.o
```
```
gcc -m32 hello.o -o hello.exe -nostartfiles
```
```
hello.exe
```
* hello world avec saut à la ligne dans l'ethiquette _start
```
del hello.asm hello.exe *.o
```
```
notepad++ hello.asm
```
```
section .data
    message db 'Hello, World!', 0xA  ; Message
    length equ $ - message            ; Calculer la longueur du message
    newline db 0xA                    ; Saut de ligne
    newline_len equ $ - newline

section .text
    extern _GetStdHandle@4, _WriteConsoleA@20, _ExitProcess@4
    global _start

_start:
    ; Obtenir le handle de la sortie standard (stdout)
    push -11              ; STD_OUTPUT_HANDLE
    call _GetStdHandle@4  ; Appel à GetStdHandle pour récupérer le handle de stdout

    ; Sauvegarder le handle retourné dans ebx
    mov ebx, eax

    ; Afficher le message
    push 0                ; lpNumberOfCharsWritten (pas nécessaire ici)
    push length           ; Longueur du message
    lea eax, [message]    ; Charger l'adresse du message
    push eax              ; Adresse du message
    push ebx              ; Handle de la sortie standard
    call _WriteConsoleA@20 ; Appel à WriteConsoleA pour afficher le message

    ; Afficher un saut de ligne
    push 0                ; lpNumberOfCharsWritten (pas nécessaire ici)
    push newline_len      ; Longueur du saut de ligne
    lea eax, [newline]    ; Charger l'adresse du saut de ligne
    push eax              ; Adresse du saut de ligne
    push ebx              ; Handle de la sortie standard
    call _WriteConsoleA@20 ; Afficher le saut de ligne

    ; Terminer proprement le programme
    push 0                ; Code de sortie
    call _ExitProcess@4   ; Appel à ExitProcess pour quitter proprement
```
exercice compilation !?
```
nasm -f win32 hello.asm -o hello.o
```
```
gcc -m32 hello.o -o hello.exe -nostartfiles
```
```
hello.exe
```

# SAISIR ET AFFICHER EN NASM
```
nano mon_programme.asm
```
```
section .data 
    prompt db 'Entrez un message: ', 0  ; Texte du prompt
    prompt_len equ $ - prompt           ; Longueur du prompt

    crlf db 0xD, 0xA  ; Retour chariot + saut de ligne (Windows)
    crlf_len equ $ - crlf

section .bss
    hStdIn resd 1    ; Handle pour stdin
    hStdOut resd 1   ; Handle pour stdout
    buffer resb 128  ; Buffer pour stocker l'entrée utilisateur
    bytesRead resd 1 ; Nombre d'octets lus

section .text
    extern _GetStdHandle@4, _ReadConsoleA@20, _WriteConsoleA@20, _ExitProcess@4
    global _start

_start:
    ; Obtenir le handle de la sortie standard (stdout)
    push -11              ; STD_OUTPUT_HANDLE (-11)
    call _GetStdHandle@4  
    mov [hStdOut], eax    

    ; Afficher le prompt avec WriteConsoleA
    push dword 0          ; lpReserved (NULL)
    push dword 0          ; lpNumberOfCharsWritten (NULL)
    push dword prompt_len ; Nombre de caractères à écrire
    push dword prompt     ; Adresse du message
    push dword [hStdOut]  ; Handle de la sortie standard
    call _WriteConsoleA@20    

    ; Obtenir le handle de l'entrée standard (stdin)
    push -10              ; STD_INPUT_HANDLE (-10)
    call _GetStdHandle@4  
    mov [hStdIn], eax     

    ; Lire l'entrée utilisateur avec ReadConsoleA
    push dword 0          ; lpReserved (NULL)
    push dword bytesRead  ; Adresse où stocker le nombre d'octets lus
    push dword 128        ; Nombre maximum de caractères à lire
    push dword buffer     ; Adresse du buffer
    push dword [hStdIn]   ; Handle de l'entrée standard
    call _ReadConsoleA@20     

    ; Ajouter un saut de ligne après l'entrée utilisateur sur stdout
    push dword 0          ; lpReserved (NULL)
    push dword 0          ; lpNumberOfCharsWritten (NULL)
    push dword crlf_len   ; Nombre de caractères à écrire
    push dword crlf       ; Adresse du saut de ligne
    push dword [hStdOut]  ; Handle de la sortie standard
    call _WriteConsoleA@20    

    ; Afficher l'entrée utilisateur sur stdout
    push dword 0           ; lpReserved (NULL)
    push dword 0           ; lpNumberOfCharsWritten (NULL)
    push dword [bytesRead] ; Nombre réel de caractères lus
    push dword buffer      ; Adresse du buffer contenant l'entrée
    push dword [hStdOut]   ; Handle de la sortie standard
    call _WriteConsoleA@20    

    ; Quitter proprement
    push dword 0
    call _ExitProcess@4
```
```
nasm -f win32 mon_programme.asm -o mon_programme.o
```
```
gcc -m32  mon_programme.o -o mon_programme.exe -nostartfiles
```
```
mon_programme.exe
```


# COMPILATION DE SKEL AVEC CODE C 
* Code C
```
mkdir skel_c
```
```
cd skel_c
```
```
notepad++ cdecl.h
```
```
#ifndef CDECL_HEADER_FILE
#define CDECL_HEADER_FILE

/*
 * Define macros to specify the standard C calling convention
 * The macros are designed so that they will work with all
 * supported C/C++ compilers.
 *
 * To use define your function prototype like this:
 *
 * return_type PRE_CDECL func_name( args ) POST_CDECL;
 *
 * For example:
 *
 * int PRE_CDECL f( int x, int y) POST_CDECL;
 */


#if defined(__GNUC__)
#  define PRE_CDECL
#  define POST_CDECL __attribute__((cdecl))
#else
#  define PRE_CDECL __cdecl
#  define POST_CDECL
#endif


#endif

```
```
notepad++ driver.c
```
```
#include "cdecl.h"

int PRE_CDECL asm_main( void ) POST_CDECL;

int main()
{
  int ret_status;
  ret_status = asm_main();
  return ret_status;
}
```
```
notepad++ skel.asm
```
```
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
        global  _asm_main
_asm_main:
        enter   0,0               ; setup routine
        pusha

;
; code is put in the text segment. Do not modify the code before
; or after this comment.
;

        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret
```

* BIBLIOTHEQUE POUR LA COMPILATION SEPAREE asm_io.inc (pour l'inclusion) asm_io.asm (pour le code)
```
notepad++ asm_io.inc
```
```
	extern  read_int, print_int, print_string
	extern	read_char, print_char, print_nl
	extern  sub_dump_regs, sub_dump_mem, sub_dump_math, sub_dump_stack

%macro 	dump_regs 1
	push	  dword %1
	call	  sub_dump_regs
%endmacro


;
; usage: dump_mem label, start-address, # paragraphs
%macro  dump_mem 3
	push	 dword %1
	push	 dword %2
	push	 dword %3
	call	 sub_dump_mem
%endmacro

%macro	dump_math 1
	push	 dword %1
	call	 sub_dump_math
%endmacro

%macro  dump_stack 3
	push	 dword %3
        push     dword %2
	push	 dword %1
        call     sub_dump_stack
%endmacro
```
```
notepad++ asm_io.asm
```
```
%define NL 10
%define CF_MASK 00000001h
%define PF_MASK 00000004h
%define AF_MASK 00000010h
%define ZF_MASK 00000040h
%define SF_MASK 00000080h
%define DF_MASK 00000400h
%define OF_MASK 00000800h


;
; Linux C doesn't put underscores on labels
;
%ifdef ELF_TYPE
  %define _scanf   scanf
  %define _printf  printf
  %define _getchar getchar
  %define _putchar putchar
%endif

;
; Watcom puts underscores at end of label
;
%ifdef WATCOM
  %define _scanf   scanf_
  %define _printf  printf_
  %define _getchar getchar_
  %define _putchar putchar_
%endif

%ifdef OBJ_TYPE
segment .data public align=4 class=data use32
%else
segment .data
%endif

int_format	    db  "%i", 0
string_format       db  "%s", 0
reg_format	    db  "Register Dump # %d", NL
		    db  "EAX = %.8X EBX = %.8X ECX = %.8X EDX = %.8X", NL
                    db  "ESI = %.8X EDI = %.8X EBP = %.8X ESP = %.8X", NL
                    db  "EIP = %.8X FLAGS = %.4X %s %s %s %s %s %s %s", NL
	            db  0
carry_flag	    db  "CF", 0
zero_flag	    db  "ZF", 0
sign_flag	    db  "SF", 0
parity_flag	    db	"PF", 0
overflow_flag	    db	"OF", 0
dir_flag	    db	"DF", 0
aux_carry_flag	    db	"AF", 0
unset_flag	    db	"  ", 0
mem_format1         db  "Memory Dump # %d Address = %.8X", NL, 0
mem_format2         db  "%.8X ", 0
mem_format3         db  "%.2X ", 0
stack_format        db  "Stack Dump # %d", NL
	            db  "EBP = %.8X ESP = %.8X", NL, 0
stack_line_format   db  "%+4d  %.8X  %.8X", NL, 0
math_format1        db  "Math Coprocessor Dump # %d Control Word = %.4X"
                    db  " Status Word = %.4X", NL, 0
valid_st_format     db  "ST%d: %.10g", NL, 0
invalid_st_format   db  "ST%d: Invalid ST", NL, 0
empty_st_format     db  "ST%d: Empty", NL, 0

;
; code is put in the _TEXT segment
;
%ifdef OBJ_TYPE
segment text public align=1 class=code use32
%else
segment .text
%endif
	global	read_int, print_int, print_string, read_char
	global  print_char, print_nl, sub_dump_regs, sub_dump_mem
        global  sub_dump_math, sub_dump_stack
        extern  _scanf, _printf, _getchar, _putchar

read_int:
	enter	4,0
	pusha
	pushf

	lea	eax, [ebp-4]
	push	eax
	push	dword int_format
	call	_scanf
	pop	ecx
	pop	ecx
	
	popf
	popa
	mov	eax, [ebp-4]
	leave
	ret

print_int:
	enter	0,0
	pusha
	pushf

	push	eax
	push	dword int_format
	call	_printf
	pop	ecx
	pop	ecx

	popf
	popa
	leave
	ret

print_string:
	enter	0,0
	pusha
	pushf

	push	eax
	push    dword string_format
	call	_printf
	pop	ecx
	pop	ecx

	popf
	popa
	leave
	ret

read_char:
	enter	4,0
	pusha
	pushf

	call	_getchar
	mov	[ebp-4], eax

	popf
	popa
	mov	eax, [ebp-4]
	leave
	ret

print_char:
	enter	0,0
	pusha
	pushf

%ifndef WATCOM
	push	eax
%endif
	call	_putchar
%ifndef WATCOM
	pop	ecx
%endif

	popf
	popa
	leave
	ret


print_nl:
	enter	0,0
	pusha
	pushf

%ifdef WATCOM
	mov	eax, 10		; WATCOM doesn't use the stack here
%else
	push	dword 10	; 10 == ASCII code for \n
%endif
	call	_putchar
%ifndef WATCOM
	pop	ecx
%endif
	popf
	popa
	leave
	ret


sub_dump_regs:
	enter   4,0
	pusha
	pushf
	mov     eax, [esp]      ; read FLAGS back off stack
	mov	[ebp-4], eax    ; save flags

;
; show which FLAGS are set
;
	test	eax, CF_MASK
	jz	cf_off
	mov	eax, carry_flag
	jmp	short push_cf
cf_off:
	mov	eax, unset_flag
push_cf:
	push	eax

	test	dword [ebp-4], PF_MASK
	jz	pf_off
	mov	eax, parity_flag
	jmp	short push_pf
pf_off:
	mov	eax, unset_flag
push_pf:
	push	eax

	test	dword [ebp-4], AF_MASK
	jz	af_off
	mov	eax, aux_carry_flag
	jmp	short push_af
af_off:
	mov	eax, unset_flag
push_af:
	push	eax

	test	dword [ebp-4], ZF_MASK
	jz	zf_off
	mov	eax, zero_flag
	jmp	short push_zf
zf_off:
	mov	eax, unset_flag
push_zf:
	push	eax

	test	dword [ebp-4], SF_MASK
	jz	sf_off
	mov	eax, sign_flag
	jmp	short push_sf
sf_off:
	mov	eax, unset_flag
push_sf:
	push	eax

	test	dword [ebp-4], DF_MASK
	jz	df_off
	mov	eax, dir_flag
	jmp	short push_df
df_off:
	mov	eax, unset_flag
push_df:
	push	eax

	test	dword [ebp-4], OF_MASK
	jz	of_off
	mov	eax, overflow_flag
	jmp	short push_of
of_off:
	mov	eax, unset_flag
push_of:
	push	eax

	push    dword [ebp-4]   ; FLAGS
	mov	eax, [ebp+4]
	sub	eax, 10         ; EIP on stack is 10 bytes ahead of orig
	push	eax             ; EIP
	lea     eax, [ebp+12]
	push    eax             ; original ESP
	push    dword [ebp]     ; original EBP
        push    edi
        push    esi
	push    edx
	push	ecx
	push	ebx
	push	dword [ebp-8]   ; original EAX
	push	dword [ebp+8]   ; # of dump
	push	dword reg_format
	call	_printf
	add	esp, 76
	popf
	popa
	leave
	ret     4

sub_dump_stack:
	enter   0,0
	pusha
	pushf

	lea     eax, [ebp+20]
	push    eax             ; original ESP
	push    dword [ebp]     ; original EBP
	push	dword [ebp+8]   ; # of dump
	push	dword stack_format
	call	_printf
	add	esp, 16

	mov	ebx, [ebp]	; ebx = original ebp
	mov	eax, [ebp+16]   ; eax = # dwords above ebp
	shl	eax, 2          ; eax *= 4
	add	ebx, eax	; ebx = & highest dword in stack to display
	mov	edx, [ebp+16]
	mov	ecx, edx
	add	ecx, [ebp+12]
	inc	ecx		; ecx = # of dwords to display

stack_line_loop:
	push	edx
	push	ecx		; save ecx & edx

	push	dword [ebx]	; value on stack
	push	ebx		; address of value on stack
	mov	eax, edx
	sal	eax, 2		; eax = 4*edx
	push	eax		; offset from ebp
	push	dword stack_line_format
	call	_printf
	add	esp, 16

	pop	ecx
	pop	edx

	sub	ebx, 4
	dec	edx
	loop	stack_line_loop

	popf
	popa
	leave
	ret     12


sub_dump_mem:
	enter	0,0
	pusha
	pushf

	push	dword [ebp+12]
	push	dword [ebp+16]
	push	dword mem_format1
	call	_printf
	add	esp, 12		
	mov	esi, [ebp+12]      ; address
	and	esi, 0FFFFFFF0h    ; move to start of paragraph
	mov	ecx, [ebp+8]
	inc	ecx
mem_outer_loop:
	push	ecx
	push	esi
	push	dword mem_format2
	call	_printf
	add	esp, 8

	xor	ebx, ebx
mem_hex_loop:
	xor	eax, eax
	mov	al, [esi + ebx]
	push	eax
	push	dword mem_format3
	call	_printf
	add	esp, 8
	inc	ebx
	cmp	ebx, 16
	jl	mem_hex_loop
	
	mov	eax, '"'
	call	print_char
	xor	ebx, ebx
mem_char_loop:
	xor	eax, eax
	mov	al, [esi+ebx]
	cmp	al, 32
	jl	non_printable
	cmp	al, 126
	jg	non_printable
	jmp	short mem_char_loop_continue
non_printable:
	mov	eax, '?'
mem_char_loop_continue:
	call	print_char

	inc	ebx
	cmp	ebx, 16
	jl	mem_char_loop

	mov	eax, '"'
	call	print_char
	call	print_nl

	add	esi, 16
	pop	ecx
	loop	mem_outer_loop

	popf
	popa
	leave
	ret	12

; function sub_dump_math
;   prints out state of math coprocessor without modifying the coprocessor
;   or regular processor state
; Parameters:
;  dump number - dword at [ebp+8]
; Local variables:
;   ebp-108 start of fsave buffer
;   ebp-116 temp double
; Notes: This procedure uses the Pascal convention.
;   fsave buffer structure:
;   ebp-108   control word
;   ebp-104   status word
;   ebp-100   tag word
;   ebp-80    ST0
;   ebp-70    ST1
;   ebp-60    ST2 ...
;   ebp-10    ST7
;
sub_dump_math:
	enter	116,0
	pusha
	pushf

	fsave	[ebp-108]	; save coprocessor state to memory
	mov	eax, [ebp-104]  ; status word
	and	eax, 0FFFFh
	push	eax
	mov	eax, [ebp-108]  ; control word
	and	eax, 0FFFFh
	push	eax
	push	dword [ebp+8]
	push	dword math_format1
	call	_printf
	add	esp, 16
;
; rotate tag word so that tags in same order as numbers are
; in the stack
;
	mov	cx, [ebp-104]	; ax = status word
	shr	cx, 11
	and	cx, 7           ; cl = physical state of number on stack top
	mov	bx, [ebp-100]   ; bx = tag word
	shl     cl,1		; cl *= 2
	ror	bx, cl		; move top of stack tag to lowest bits

	mov	edi, 0		; edi = stack number of number
	lea	esi, [ebp-80]   ; esi = address of ST0
	mov	ecx, 8          ; ecx = loop counter
tag_loop:
	push	ecx
	mov	ax, 3
	and	ax, bx		; ax = current tag
	or	ax, ax		; 00 -> valid number
	je	valid_st
	cmp	ax, 1		; 01 -> zero
	je	zero_st
	cmp	ax, 2		; 10 -> invalid number
	je	invalid_st
	push	edi		; 11 -> empty
	push	dword empty_st_format
	call	_printf
	add	esp, 8
	jmp	short cont_tag_loop
zero_st:
	fldz
	jmp	short print_real
valid_st:
	fld	tword [esi]
print_real:
	fstp	qword [ebp-116]
	push	dword [ebp-112]
	push	dword [ebp-116]
	push	edi
	push	dword valid_st_format
	call	_printf
	add	esp, 16
	jmp	short cont_tag_loop
invalid_st:
	push	edi
	push	dword invalid_st_format
	call	_printf
	add	esp, 8
cont_tag_loop:
	ror	bx, 2		; mov next tag into lowest bits
	inc	edi
	add	esi, 10         ; mov to next number on stack
	pop	ecx
	loop    tag_loop

	frstor	[ebp-108]       ; restore coprocessor state
	popf
	popa
	leave
	ret	4
```
```
dir
```
Compilation skel avec code C
```
nasm -f win32  -o asm_io.o asm_io.asm
```
```
nasm -f win32 -o skel.o skel.asm
```
```
gcc -m32 -o skel.exe driver.c skel.o asm_io.o
```
```
skel.exe
```
```
cd ..
```
EXERCICE : REFAIRE L'EXERCICE EN AFFICHANT : HELLO WORLD DANS LE CODE

# COMPIlATION SKEL EN NASM
```
mkdir skel
```
```
cd skel
```
```
notepad++ skel.asm
```
```
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
        global  _start ; TIRET BAS POUR WINDOWS  ; avec nostartfiles sans options c'est _start le point d'entrée
_start:
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
;       ret


; MODIFICATION ADDED FOR RETUN 
    ; Sortie propre du programme
   ; mov eax, 1      ; syscall sys_exit
   ; xor ebx, ebx    ; code de retour 0
   ; int 0x80        ; appel système
 ; Terminer proprement le programme
  mov eax, 0
  ret 	
```
NEED asm_io.inc and asm_io.asm
```
notepad++ asm_io.inc
```
```
	extern  read_int, print_int, print_string
	extern	read_char, print_char, print_nl
	extern  sub_dump_regs, sub_dump_mem, sub_dump_math, sub_dump_stack

%macro 	dump_regs 1
	push	  dword %1
	call	  sub_dump_regs
%endmacro


;
; usage: dump_mem label, start-address, # paragraphs
%macro  dump_mem 3
	push	 dword %1
	push	 dword %2
	push	 dword %3
	call	 sub_dump_mem
%endmacro

%macro	dump_math 1
	push	 dword %1
	call	 sub_dump_math
%endmacro

%macro  dump_stack 3
	push	 dword %3
        push     dword %2
	push	 dword %1
        call     sub_dump_stack
%endmacro
```
```
notepad++ asm_io.asm
```
```
%define NL 10
%define CF_MASK 00000001h
%define PF_MASK 00000004h
%define AF_MASK 00000010h
%define ZF_MASK 00000040h
%define SF_MASK 00000080h
%define DF_MASK 00000400h
%define OF_MASK 00000800h


;
; Linux C doesn't put underscores on labels
;
%ifdef ELF_TYPE
  %define _scanf   scanf
  %define _printf  printf
  %define _getchar getchar
  %define _putchar putchar
%endif

;
; Watcom puts underscores at end of label
;
%ifdef WATCOM
  %define _scanf   scanf_
  %define _printf  printf_
  %define _getchar getchar_
  %define _putchar putchar_
%endif

%ifdef OBJ_TYPE
segment .data public align=4 class=data use32
%else
segment .data
%endif

int_format	    db  "%i", 0
string_format       db  "%s", 0
reg_format	    db  "Register Dump # %d", NL
		    db  "EAX = %.8X EBX = %.8X ECX = %.8X EDX = %.8X", NL
                    db  "ESI = %.8X EDI = %.8X EBP = %.8X ESP = %.8X", NL
                    db  "EIP = %.8X FLAGS = %.4X %s %s %s %s %s %s %s", NL
	            db  0
carry_flag	    db  "CF", 0
zero_flag	    db  "ZF", 0
sign_flag	    db  "SF", 0
parity_flag	    db	"PF", 0
overflow_flag	    db	"OF", 0
dir_flag	    db	"DF", 0
aux_carry_flag	    db	"AF", 0
unset_flag	    db	"  ", 0
mem_format1         db  "Memory Dump # %d Address = %.8X", NL, 0
mem_format2         db  "%.8X ", 0
mem_format3         db  "%.2X ", 0
stack_format        db  "Stack Dump # %d", NL
	            db  "EBP = %.8X ESP = %.8X", NL, 0
stack_line_format   db  "%+4d  %.8X  %.8X", NL, 0
math_format1        db  "Math Coprocessor Dump # %d Control Word = %.4X"
                    db  " Status Word = %.4X", NL, 0
valid_st_format     db  "ST%d: %.10g", NL, 0
invalid_st_format   db  "ST%d: Invalid ST", NL, 0
empty_st_format     db  "ST%d: Empty", NL, 0

;
; code is put in the _TEXT segment
;
%ifdef OBJ_TYPE
segment text public align=1 class=code use32
%else
segment .text
%endif
	global	read_int, print_int, print_string, read_char
	global  print_char, print_nl, sub_dump_regs, sub_dump_mem
        global  sub_dump_math, sub_dump_stack
        extern  _scanf, _printf, _getchar, _putchar

read_int:
	enter	4,0
	pusha
	pushf

	lea	eax, [ebp-4]
	push	eax
	push	dword int_format
	call	_scanf
	pop	ecx
	pop	ecx
	
	popf
	popa
	mov	eax, [ebp-4]
	leave
	ret

print_int:
	enter	0,0
	pusha
	pushf

	push	eax
	push	dword int_format
	call	_printf
	pop	ecx
	pop	ecx

	popf
	popa
	leave
	ret

print_string:
	enter	0,0
	pusha
	pushf

	push	eax
	push    dword string_format
	call	_printf
	pop	ecx
	pop	ecx

	popf
	popa
	leave
	ret

read_char:
	enter	4,0
	pusha
	pushf

	call	_getchar
	mov	[ebp-4], eax

	popf
	popa
	mov	eax, [ebp-4]
	leave
	ret

print_char:
	enter	0,0
	pusha
	pushf

%ifndef WATCOM
	push	eax
%endif
	call	_putchar
%ifndef WATCOM
	pop	ecx
%endif

	popf
	popa
	leave
	ret


print_nl:
	enter	0,0
	pusha
	pushf

%ifdef WATCOM
	mov	eax, 10		; WATCOM doesn't use the stack here
%else
	push	dword 10	; 10 == ASCII code for \n
%endif
	call	_putchar
%ifndef WATCOM
	pop	ecx
%endif
	popf
	popa
	leave
	ret


sub_dump_regs:
	enter   4,0
	pusha
	pushf
	mov     eax, [esp]      ; read FLAGS back off stack
	mov	[ebp-4], eax    ; save flags

;
; show which FLAGS are set
;
	test	eax, CF_MASK
	jz	cf_off
	mov	eax, carry_flag
	jmp	short push_cf
cf_off:
	mov	eax, unset_flag
push_cf:
	push	eax

	test	dword [ebp-4], PF_MASK
	jz	pf_off
	mov	eax, parity_flag
	jmp	short push_pf
pf_off:
	mov	eax, unset_flag
push_pf:
	push	eax

	test	dword [ebp-4], AF_MASK
	jz	af_off
	mov	eax, aux_carry_flag
	jmp	short push_af
af_off:
	mov	eax, unset_flag
push_af:
	push	eax

	test	dword [ebp-4], ZF_MASK
	jz	zf_off
	mov	eax, zero_flag
	jmp	short push_zf
zf_off:
	mov	eax, unset_flag
push_zf:
	push	eax

	test	dword [ebp-4], SF_MASK
	jz	sf_off
	mov	eax, sign_flag
	jmp	short push_sf
sf_off:
	mov	eax, unset_flag
push_sf:
	push	eax

	test	dword [ebp-4], DF_MASK
	jz	df_off
	mov	eax, dir_flag
	jmp	short push_df
df_off:
	mov	eax, unset_flag
push_df:
	push	eax

	test	dword [ebp-4], OF_MASK
	jz	of_off
	mov	eax, overflow_flag
	jmp	short push_of
of_off:
	mov	eax, unset_flag
push_of:
	push	eax

	push    dword [ebp-4]   ; FLAGS
	mov	eax, [ebp+4]
	sub	eax, 10         ; EIP on stack is 10 bytes ahead of orig
	push	eax             ; EIP
	lea     eax, [ebp+12]
	push    eax             ; original ESP
	push    dword [ebp]     ; original EBP
        push    edi
        push    esi
	push    edx
	push	ecx
	push	ebx
	push	dword [ebp-8]   ; original EAX
	push	dword [ebp+8]   ; # of dump
	push	dword reg_format
	call	_printf
	add	esp, 76
	popf
	popa
	leave
	ret     4

sub_dump_stack:
	enter   0,0
	pusha
	pushf

	lea     eax, [ebp+20]
	push    eax             ; original ESP
	push    dword [ebp]     ; original EBP
	push	dword [ebp+8]   ; # of dump
	push	dword stack_format
	call	_printf
	add	esp, 16

	mov	ebx, [ebp]	; ebx = original ebp
	mov	eax, [ebp+16]   ; eax = # dwords above ebp
	shl	eax, 2          ; eax *= 4
	add	ebx, eax	; ebx = & highest dword in stack to display
	mov	edx, [ebp+16]
	mov	ecx, edx
	add	ecx, [ebp+12]
	inc	ecx		; ecx = # of dwords to display

stack_line_loop:
	push	edx
	push	ecx		; save ecx & edx

	push	dword [ebx]	; value on stack
	push	ebx		; address of value on stack
	mov	eax, edx
	sal	eax, 2		; eax = 4*edx
	push	eax		; offset from ebp
	push	dword stack_line_format
	call	_printf
	add	esp, 16

	pop	ecx
	pop	edx

	sub	ebx, 4
	dec	edx
	loop	stack_line_loop

	popf
	popa
	leave
	ret     12


sub_dump_mem:
	enter	0,0
	pusha
	pushf

	push	dword [ebp+12]
	push	dword [ebp+16]
	push	dword mem_format1
	call	_printf
	add	esp, 12		
	mov	esi, [ebp+12]      ; address
	and	esi, 0FFFFFFF0h    ; move to start of paragraph
	mov	ecx, [ebp+8]
	inc	ecx
mem_outer_loop:
	push	ecx
	push	esi
	push	dword mem_format2
	call	_printf
	add	esp, 8

	xor	ebx, ebx
mem_hex_loop:
	xor	eax, eax
	mov	al, [esi + ebx]
	push	eax
	push	dword mem_format3
	call	_printf
	add	esp, 8
	inc	ebx
	cmp	ebx, 16
	jl	mem_hex_loop
	
	mov	eax, '"'
	call	print_char
	xor	ebx, ebx
mem_char_loop:
	xor	eax, eax
	mov	al, [esi+ebx]
	cmp	al, 32
	jl	non_printable
	cmp	al, 126
	jg	non_printable
	jmp	short mem_char_loop_continue
non_printable:
	mov	eax, '?'
mem_char_loop_continue:
	call	print_char

	inc	ebx
	cmp	ebx, 16
	jl	mem_char_loop

	mov	eax, '"'
	call	print_char
	call	print_nl

	add	esi, 16
	pop	ecx
	loop	mem_outer_loop

	popf
	popa
	leave
	ret	12

; function sub_dump_math
;   prints out state of math coprocessor without modifying the coprocessor
;   or regular processor state
; Parameters:
;  dump number - dword at [ebp+8]
; Local variables:
;   ebp-108 start of fsave buffer
;   ebp-116 temp double
; Notes: This procedure uses the Pascal convention.
;   fsave buffer structure:
;   ebp-108   control word
;   ebp-104   status word
;   ebp-100   tag word
;   ebp-80    ST0
;   ebp-70    ST1
;   ebp-60    ST2 ...
;   ebp-10    ST7
;
sub_dump_math:
	enter	116,0
	pusha
	pushf

	fsave	[ebp-108]	; save coprocessor state to memory
	mov	eax, [ebp-104]  ; status word
	and	eax, 0FFFFh
	push	eax
	mov	eax, [ebp-108]  ; control word
	and	eax, 0FFFFh
	push	eax
	push	dword [ebp+8]
	push	dword math_format1
	call	_printf
	add	esp, 16
;
; rotate tag word so that tags in same order as numbers are
; in the stack
;
	mov	cx, [ebp-104]	; ax = status word
	shr	cx, 11
	and	cx, 7           ; cl = physical state of number on stack top
	mov	bx, [ebp-100]   ; bx = tag word
	shl     cl,1		; cl *= 2
	ror	bx, cl		; move top of stack tag to lowest bits

	mov	edi, 0		; edi = stack number of number
	lea	esi, [ebp-80]   ; esi = address of ST0
	mov	ecx, 8          ; ecx = loop counter
tag_loop:
	push	ecx
	mov	ax, 3
	and	ax, bx		; ax = current tag
	or	ax, ax		; 00 -> valid number
	je	valid_st
	cmp	ax, 1		; 01 -> zero
	je	zero_st
	cmp	ax, 2		; 10 -> invalid number
	je	invalid_st
	push	edi		; 11 -> empty
	push	dword empty_st_format
	call	_printf
	add	esp, 8
	jmp	short cont_tag_loop
zero_st:
	fldz
	jmp	short print_real
valid_st:
	fld	tword [esi]
print_real:
	fstp	qword [ebp-116]
	push	dword [ebp-112]
	push	dword [ebp-116]
	push	edi
	push	dword valid_st_format
	call	_printf
	add	esp, 16
	jmp	short cont_tag_loop
invalid_st:
	push	edi
	push	dword invalid_st_format
	call	_printf
	add	esp, 8
cont_tag_loop:
	ror	bx, 2		; mov next tag into lowest bits
	inc	edi
	add	esi, 10         ; mov to next number on stack
	pop	ecx
	loop    tag_loop

	frstor	[ebp-108]       ; restore coprocessor state
	popf
	popa
	leave
	ret	4
```
```
dir
```
```
nasm -f win32 -o asm_io.o asm_io.asm
```
```
nasm -f win32 -o skel.o skel.asm
```
```
gcc -m32 -o skel.exe skel.o asm_io.o -nostartfiles
```
```
skel.exe
```
```
cd ..
```


# COMPILATION DE FIRST EN NASM AVEC CODE EN C 
```
mkdir first_c
```
```
cd first_c
```
```
notepad++ first.asm
```

```
%include "asm_io.inc"
;
; initialized data is put in the .data segment
;
segment .data
;
; These labels refer to strings used for output
;
prompt1 db    "Enter a number: ", 0       ; don't forget nul terminator
prompt2 db    "Enter another number: ", 0
outmsg1 db    "You entered ", 0
outmsg2 db    " and ", 0
outmsg3 db    ", the sum of these is ", 0


;
; uninitialized data is put in the .bss segment
;
segment .bss
;
; These labels refer to double words used to store the inputs
;
input1  resd 1
input2  resd 1

;
; code is put in the .text segment
;
segment .text
        global  _asm_main ; ajout de tiret bas pour windows
_asm_main:
        enter   0,0               ; setup routine
        pusha

        mov     eax, prompt1      ; print out prompt
        call    print_string

        call    read_int          ; read integer
        mov     [input1], eax     ; store into input1

        mov     eax, prompt2      ; print out prompt
        call    print_string

        call    read_int          ; read integer
        mov     [input2], eax     ; store into input2

        mov     eax, [input1]     ; eax = dword at input1
        add     eax, [input2]     ; eax += dword at input2
        mov     ebx, eax          ; ebx = eax
        dump_regs 1               ; dump out register values
        dump_mem 2, outmsg1, 1    ; dump out memory
;
; next print out result message as series of steps
;
        mov     eax, outmsg1
        call    print_string      ; print out first message
        mov     eax, [input1]     
        call    print_int         ; print out input1
        mov     eax, outmsg2
        call    print_string      ; print out second message
        mov     eax, [input2]
        call    print_int         ; print out input2
        mov     eax, outmsg3
        call    print_string      ; print out third message
        mov     eax, ebx
        call    print_int         ; print out sum (ebx)
        call    print_nl          ; print new-line

        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret
```
```
curl https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/asm_io.asm > asm_io.asm 
```
```
curl https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/asm_io.inc > asm_io.inc
```
```
curl https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/cdecl.h > cdecl.h
```
```
curl https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/driver.c > driver.c
```
```
dir
```
```
nasm -f win32 -o asm_io.o asm_io.asm
```
```
nasm -f win32  -o first.o first.asm
```
```
gcc -m32 -o first.exe driver.c first.o asm_io.o
```
```
first.exe
```
```
cd ..
```

# COMPILATION DE FIRST EN NASM
```
mkdir first
```
```
cd first
```
```
notepad++ first.asm
```
```
%include "asm_io.inc"
;
; initialized data is put in the .data segment
;
segment .data
;
; These labels refer to strings used for output
;
prompt1 db    "Enter a number: ", 0       ; don't forget nul terminator
prompt2 db    "Enter another number: ", 0
outmsg1 db    "You entered ", 0
outmsg2 db    " and ", 0
outmsg3 db    ", the sum of these is ", 0


;
; uninitialized data is put in the .bss segment
;
segment .bss
;
; These labels refer to double words used to store the inputs
;
input1  resd 1
input2  resd 1

;
; code is put in the .text segment
;
segment .text
        global  _start ; ajout de tiret bas pour windows  ET AVEC NO START FILES C'EST OBLIGATOIRE QUE LE POINT D'ENTREE EST START
_start:
; MODIFICATION WITHOUT C WRAPING
;        enter   0,0               ; setup routine
;        pusha

        mov     eax, prompt1      ; print out prompt
        call    print_string

        call    read_int          ; read integer
        mov     [input1], eax     ; store into input1

        mov     eax, prompt2      ; print out prompt
        call    print_string

        call    read_int          ; read integer
        mov     [input2], eax     ; store into input2

        mov     eax, [input1]     ; eax = dword at input1
        add     eax, [input2]     ; eax += dword at input2
        mov     ebx, eax          ; ebx = eax
        dump_regs 1               ; dump out register values
        dump_mem 2, outmsg1, 1    ; dump out memory
;
; next print out result message as series of steps
;
        mov     eax, outmsg1
        call    print_string      ; print out first message
        mov     eax, [input1]     
        call    print_int         ; print out input1
        mov     eax, outmsg2
        call    print_string      ; print out second message
        mov     eax, [input2]
        call    print_int         ; print out input2
        mov     eax, outmsg3
        call    print_string      ; print out third message
        mov     eax, ebx
        call    print_int         ; print out sum (ebx)
        call    print_nl          ; print new-line

; MODIFICATION WITHOUT C WRAPPIING ADDED
	; sys_exit (status = 0)
	;mov eax, 1          ; syscall number for sys_exit
	;xor ebx, ebx        ; exit code 0
	;int 0x80            ; call kernel
 ; Terminer proprement le programme
	mov eax, 0
	ret
; MODIFICATION WITHOUT C WRAPPING
;	 popa
;        mov     eax, 0            ; return back to C
;        leave                     
;        ret
```
```
curl https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/asm_io.asm > asm_io.asm
```
```
curl https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/linux/asm_io.inc > asm_io.inc
```
```
nasm -f win32  -o asm_io.o asm_io.asm
```
```
nasm -f win32 -o first.o first.asm
```
```
gcc -m32 -o first.exe first.o asm_io.o -nostartfiles
```
```
first.exe
```
```
cd ..
```

