%define maxRA 10
%define mm2 13
section .data
    msg03 : db "Length > 10, error ", 10
	msg01 : db "Entre com seu R.A.: "
	msg02 : db "Resultado           "
	msgln : equ $ - msg02
	
	fileDescriptor : dw 0

    fileNme0 : db ".ra"
    
section .bss
    fileNme : resb mm2
	raOR : resb maxRA
	raCF : resb maxRA
	sizeRA : resb 1

section .text
	global _start

_start:
	mov rax, 1
	mov rdi, 1
	lea rsi, [msg01]
	mov edx, msgln
	syscall

	mov rax, 0
	mov rdi, 1
	lea rsi, [raOR]
	mov edx, maxRA
	syscall
		
	mov [sizeRA], eax
	
	cmp eax, maxRA
	jl cont
	mov bl, [raOR+9]
	cmp bl, 0x0a
	jne brek 
	
cont:
	xor ecx, ecx
	
	mov r11d, eax
    dec r11d
	
lco:
	mov r15w, [raOR+1*ecx]
	mov [fileNme+1*ecx], r15w
	inc ecx
	cmp ecx, r11d
	jl lco
	
	xor edx, edx
L9:
	mov r12w, [fileNme0+1*edx]
	mov [fileNme+1*ecx], r12w
    inc edx
    inc ecx
    cmp edx, 0x3
    jl L9

L8:
	xor r13, r13
	xor r15, r15
	xor r12, r12
	xor r11, r11
	xor rcx, rcx
	xor rdx, rdx
	xor rax, rax
	xor rbx, rbx
	
L0:
	mov bl, [raOR+ecx]
	cmp bl, 10
	je LOut
	
	add bl, cl
	inc bl
	
	cmp bl, 0x39
	jle L1
	sub bl, 10
	
L1:
	mov [raCF + ecx], bl
	inc ecx
	jmp L0
	
	LOut:
	mov byte [raCF + ecx], 10 
	
	mov rax, 1
	mov rdi, 1
	lea rsi, [msg02]
	mov edx, msgln
	syscall
	
	mov rax, 1
	mov rdi, 1
	lea rsi, [raCF]
	mov edx, [sizeRA]
	syscall
	
	xor r14, r14
	
gra:
	;open file
    mov rax, 2          
    lea rdi, [fileNme]
    mov rsi, 102o       
    mov rdx, 644o    
    syscall
	
    mov [fileDescriptor], rax

    ;write
    mov rax, 1         
    mov rdi, [fileDescriptor] 
    lea rsi, [raCF]
    mov rdx, [sizeRA]
    syscall
    
    ;close
    mov rax, 3  
    mov rdi, [fileDescriptor]
    syscall
    
    jmp _fim
    
brek:
    mov rax, 1
	mov rdi, 1
	lea rsi, [msg03]
	mov edx, msgln
	syscall
	

_fim:
	mov rax, 60
	mov rdi, 0
	syscall
