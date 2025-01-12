.section .data
// we will need to take the filename as a command line argument
filename:	
	.asciz "content.txt"
filename_size = . - filename
// we will make this just the newline chars and prepend the filename so it can be used as a header
message:
	.asciz "Welcome to Meow! The rubbish version of Cat I wrote in x86 asm\n\n"
message_size = . - message

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
	
	// write a header message to stdout
	mov rax, 1
	mov rdi, 1
	lea rsi, [message]
	mov rdx, message_size
	syscall

	// print the filename
	mov rax, 1
	mov rdi, 1
	lea rsi, [filename]
	mov rdx, filename_size
	syscall
	
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
