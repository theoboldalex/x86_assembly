.global _start
.intel_syntax noprefix

.section .data
filename:
	.asciz "content.txt"
message:
	.asciz "Welcome to Shat! The rubbish version of Cat I wrote in x86 asm\n\n"
message_size = . - message

.section .text
_start:
	// sys_open call
	mov rax, 2
	lea rdi, [filename]
	mov rsi, 0
	mov rdx, 0
	syscall

	cmp rax, 0
	jl error

	// store the file descriptor
	mov rdi, rax

	// read file into buffer

	
	// write a message to stdout
	mov rax, 1
	mov rdi, 1
	lea rsi, [message]
	mov rdx, message_size
	syscall

	// write file contents to stdout with sys_write call
	
	// exit syscall
	mov rax, 60
	mov rdi, 0
	syscall

error:
	mov rax, 60
	mov rdi, 1
	syscall
	
