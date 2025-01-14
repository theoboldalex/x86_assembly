/*
* Welcome to the source of Meow! The very basic clone of the *nix Cat command written in x86_64 Assembler
*
* This project was built purely for fun and learning. If you find something that could be improved, please PR.
*/

.section .data
// we will need to take the filename as a command line argument
filename:	
	.asciz "content.txt"
filename_size = . - filename

break:
	.asciz "\n\n"
break_size = . - break
	
error_message:
	.asciz "Sorry, the file provided could not be opened."
error_message_size = . - error_message
	
len: .quad 0

.section .bss
	.lcomm buffer, 1024
	.lcomm fd, 8

.section .text
	.global _start
	.intel_syntax noprefix

_start:
	// sys_open: open the file (currently hard coded)
	mov rax, 2
	lea rdi, [filename]
	mov rsi, 0
	mov rdx, 0
	syscall
	mov [fd], rax
	
	// was the sys_open call successful, if not, handle error
	cmp rax, 0
	jl error

	// read file into buffer and get its length in bytes
	mov rax, 0
	mov rdi, [fd]
	lea rsi, [buffer]
	mov rdx, 1024
	syscall
	mov [len], rax
	
	// write file contents to stdout with sys_write call
	mov rax, 1
	mov rdi, 1
	lea rsi, [buffer]
	mov rdx, [len]
	syscall
	
	// close the file
	mov rax, 3
	mov rdi, [fd]
	syscall
	
	// exit syscall with success
	mov rax, 60
	mov rdi, 0
	syscall

error:
	// print the error message to stdout
	mov rax, 1
	mov rdi, 1
	lea rsi, [error_message]
	mov rdx, error_message_size
	syscall

	// call sys_exit with non-zero exit code
	mov rax, 60
	mov rdi, 1
	syscall
