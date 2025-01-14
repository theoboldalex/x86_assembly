/*
* Welcome to the source of Meow! The very basic clone of the *nix Cat command written in x86_64 Assembler
*
* This project was built purely for fun and learning. If you find something that could be improved, please PR.
*/
	
.section .data
	.equ SYS_OPEN, 2
	.equ SYS_READ, 0
	.equ SYS_WRITE, 1
	.equ SYS_CLOSE, 3
	.equ SYS_EXIT, 60
	.equ STDOUT, 1
	.equ EXIT_SUCCESS, 0
	.equ EXIT_FAILURE, 1
	
	filename: .asciz "content.txt"
	filename_size = . - filename

	error_message: .asciz "Sorry, the file provided could not be opened."
	error_message_size = . - error_message
	
	file_contents_len_b: .quad 0

.section .bss
	.lcomm buffer, 1024
	.lcomm fd, 8

.section .text
	.global _start
	.intel_syntax noprefix

_start:
	// if we have an argument to print, execute that block
	jz print
	
print:	
	mov rax, SYS_OPEN
	lea rdi, [filename]
	mov rsi, 0
	mov rdx, 0
	syscall
	mov [fd], rax
	
	// jump to error if file cannot be opened
	cmp rax, 0
	jl error

	mov rax, SYS_READ
	mov rdi, [fd]
	lea rsi, [buffer]
	mov rdx, 1024
	syscall
	mov [file_contents_len_b], rax
	
	mov rax, SYS_WRITE
	mov rdi, STDOUT
	lea rsi, [buffer]
	mov rdx, [file_contents_len_b]
	syscall
	
	mov rax, SYS_CLOSE
	mov rdi, [fd]
	syscall
	
	jz success
	
success:
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall

error:
	mov rax, SYS_WRITE
	mov rdi, STDOUT
	lea rsi, [error_message]
	mov rdx, error_message_size
	syscall

	mov rax, SYS_EXIT
	mov rdi, EXIT_FAILURE
	syscall
