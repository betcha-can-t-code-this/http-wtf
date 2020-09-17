.section .data
sock_fd:
	.quad 0
bytes_read:
	.long 0

.section .bss
.comm rbuf, 1024

.section .text
.globl _start
_start:
	# call syscall(__NR_socket = 0x29, 2, 1, 0)
	xorq	%rdi, %rdi
	addq	$0x29, %rdi
	xorq	%rsi, %rsi
	incq	%rsi
	incq	%rsi
	xorq	%rdx, %rdx
	incq	%rdx
	xorq	%rcx, %rcx
	call	syscall

	# store current socket
	# descriptor to 'sock_fd'
	movq	%rax, sock_fd

	# call syscall(__NR_connect = 0x2a, fd, (struct sockaddr *)&sock_param, (1 << 4))
	xorq	%rbx, %rbx
	pushq	%rbx
	addw	$0x697a, %bx
	pushw	%bx
	xorq	%rbx, %rbx
	incq	%rbx
	incq	%rbx
	pushw	%bx
	xorq	%rbx, %rbx
	leaq	(%rsp), %rdx
	xorq	%rdi, %rdi
	addq	$0x2a, %rdi
	xorq	%rsi, %rsi
	addq	sock_fd, %rsi
	xorq	%rcx, %rcx
	addq	$0x10, %rcx
	call	syscall

read_until_eof:
	# call bzero(rbuf, 0x400)
	xorq	%rdi, %rdi
	leaq	rbuf, %rdi
	xorq	%rsi, %rsi
	addq	$0x400, %rsi
	call	bzero

	# call syscall(__NR_read = 0x0, fd, buf, sizeof(buf))
	xorq	%rdi, %rdi
	xorq	%rsi, %rsi
	addq	sock_fd, %rsi
	xorq	%rdx, %rdx
	movq	$rbuf, %rdx
	xorq	%rcx, %rcx
	addq	$0x400, %rcx
	call	syscall

	# move how many bytes length to 'bytes_read'
	movq	%rax, bytes_read
	xorq	%rax, %rax
	cmpq	%rax, bytes_read

	# whether 'bytes_read' < 0, jump to 'done'
	jle	done

	# call syscall(__NR_write = 0x1, fd = 1, buf, 'bytes_read')
	xorq	%rdi, %rdi
	incq	%rdi
	xorq	%rsi, %rsi
	incq	%rsi
	xorq	%rdx, %rdx
	movq	$rbuf, %rdx
	xorq	%rcx, %rcx
	addq	bytes_read, %rcx
	call	syscall

	# repeat the socket read process.
	jmp	read_until_eof

done:
	# call syscall(__NR_close = 0x3, sock_fd)
	xorq	%rdi, %rdi
	incq	%rdi
	incq	%rdi
	incq	%rdi
	xorq	%rsi, %rsi
	addq	sock_fd, %rsi
	call	syscall

	# call syscall(__NR_exit = 0x3c, 0)
	xorq	%rdi, %rdi
	addq	$0x3c, %rdi
	xorq	%rsi, %rsi
	call	syscall
