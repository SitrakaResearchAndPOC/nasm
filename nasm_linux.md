# Installation des dependances
Installation VM (VMWARE 17Pro) </br> </br>
Installation Ubuntu, de votre choix : ubuntu 20.04 ou 22.04 ou  ubuntu 24.04 </br> </br>
Configuration reseaux </br> </br>

* Pour ubuntu 20.04 or 22.04
```
mkdir HELLO
```
```
cd HELLO
```
```
apt update
```
```
apt install nasm binutils gcc libc6-dev-i386 gcc-multilib git unzip
```
* Pour ubuntu 24.04
```
apt update
```
```
sudo dpkg --add-architecture i386
```
```
apt install nasm binutils gcc libc6-dev-i386 gcc-multilib git unzip
```
* Installation vscode
```
sudo apt install software-properties-common apt-transport-https curl
```
```
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
```
```
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
```
```
sudo apt install code
```

OU UTILISER UBUNTU PREINSTALLE (ASM qui est avec dgb-peda et metasploit, MYASM Juste pour compilation) </br>

* sans retour à la ligne

</br>
POUR L'EDITEUR DE TEXTE : NANO ou GEDIT SONT DES CHOIX</br> 
POUR NANO : TAPER CTRL+Y PUIS ENTREE POUR SAUVEGARDER </br>
POUR GEDIT : TAPER CTRL+S POUR SAUVEGARDER </br>  </br>

# HELLO WORLD : nasm

```
nano hello.asm
```
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
gcc -m32 hello.o -o hello.elf -nostartfiles
```
OR
```
ld -m elf_i386 hello.o -o hello.elf
```
```
chmod +x hello.elf
```
```
./hello.elf
```
* hello world avec saut à la ligne dans l'ethiquette _start
```
rm -rf hello.asm hello.elf *.o
```
```
nano hello.asm
```
```
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
```
exercice compilation !?
```
nasm -f elf hello.asm -o hello.o
```
```
gcc -m32 hello.o -o hello.elf -nostartfiles
```
OR
```
ld -m elf_i386 hello.o -o hello.elf
```
```
chmod +x hello.elf
```
```
./hello.elf
```

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
OR
```
ld -m elf_i386 mon_programme.o -o mon_programme.elf
```
```
chmod +x mon_programme.elf
```
```
./mon_programme.elf
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
nano cdecl.h
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
nano driver.c
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
nano skel.asm
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
        global  asm_main
asm_main:
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
nano asm_io.inc
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
nano asm_io.asm
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
ls
```
Compilation skel avec code C
```
nasm -f elf32 -d ELF_TYPE -o asm_io.o asm_io.asm
```
```
nasm -f elf32 -d ELF_TYPE -o skel.o skel.asm
```
```
gcc -m32 -o skel.elf driver.c skel.o asm_io.o
```
```
chmod +x skel.elf
```
```
./skel.elf
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
nano skel.asm
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
```
NEED asm_io.inc and asm_io.asm
```
nano asm_io.inc
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
nano asm_io.asm
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
ls
```
```
nasm -f elf32 -d ELF_TYPE -o asm_io.o asm_io.asm
```
```
nasm -f elf32 -d ELF_TYPE -o skel.o skel.asm
```
```
gcc -m32 -o skel.elf skel.o asm_io.o -nostartfiles
```
OR
```
ld -m elf_i386 -o skel.elf skel.o asm_io.o -lc -dynamic-linker /lib/ld-linux.so.2
```
```
./skel.elf
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
nano first.asm
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
        global  asm_main
asm_main:
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
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/win/asm_io.asm
```
```
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/win/asm_io.inc
```
```
https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/win/cdecl.h
```
```
https://raw.githubusercontent.com/SitrakaResearchAndPOC/nasm/refs/heads/main/win/driver.c
```
```
ls
```
```
nasm -f elf32 -d ELF_TYPE -o asm_io.o asm_io.asm
```
```
nasm -f elf32 -d ELF_TYPE -o first.o first.asm
```
```
gcc -m32 -o first.elf driver.c first.o asm_io.o
```
```
./first.elf
```
```
cd ..
```

# COMPILING FIRST IN NASM
```
mkdir first
```
```
cd first
```
```
nano first.asm
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
        global  asm_main
asm_main:
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
	mov eax, 1          ; syscall number for sys_exit
	xor ebx, ebx        ; exit code 0
	int 0x80            ; call kernel

; MODIFICATION WITHOUT C WRAPPING
;	 popa
;        mov     eax, 0            ; return back to C
;        leave                     
;        ret
```
```
nasm -f elf32 -d ELF_TYPE -o asm_io.o asm_io.asm
```
```
nasm -f elf32 -d ELF_TYPE -o first.o first.asm
```
```
gcc -m32 -o first.elf first.o asm_io.o -nostartfiles
```
OR
```
ld -m elf_i386 -o first.elf first.o asm_io.o -lc -dynamic-linker /lib/ld-linux.so.2
```
```
./first.elf
```
```
cd ..
```

