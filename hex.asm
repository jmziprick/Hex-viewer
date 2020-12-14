section .bss
	buffLen equ 1 ;bytes
	buff: resb buffLen

section .data
	hex: db '0123456789ABCDEF'

	hexStr: db '00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00',10
	hexStrLen equ $-hexStr

	newLine: db 10

section .text
	global _start

_start:
	nop
	mov esi,0
	mov edi,0

GetInput:
	mov eax,3
	mov ebx,0
	mov ecx,buff
	mov edx,buffLen
	int 80h
	cmp eax,0
	je FinalPrint 

Process:
;mask high nybble
;this will become the 2nd hex char
	mov ax,word[buff]
	and al,0x0f
	mov bh,byte[hex+eax]
	
	
	mov byte[hexStr+1+esi],bh

;low nybble
;this will become the 1st hex char
	mov ax,word[buff]
	shr al,4
	mov bh,byte[hex+eax]


	mov byte[hexStr+esi],bh	
	
	cmp edi,16
	ja Print
;jump back to begining
	inc edi
	add esi,3	
	jmp GetInput

Print:
	mov eax,4
	mov ebx,1
	mov ecx,hexStr
	mov edx,hexStrLen
	int 80h

	mov esi,0
	mov edi,0
	jmp GetInput

FinalPrint:	
	mov eax,4
	mov ebx,1
	mov ecx,hexStr
	mov edx,hexStrLen
	int 80h

End:
;quit
	mov eax,1
	mov ebx,0
	int 80h
