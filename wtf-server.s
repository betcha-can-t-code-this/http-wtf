.section .rodata
response:
	.asciz "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nX-Powered-By: WTF\r\n\r\n{\"message\": \"The memes saved the world!!\"}\n"

.section .data
sock_fd:
	.long 0
accept_fd:
	.quad 0

.section .text
.globl _start
_start:
	# call syscall(__NR_socket = 0x29, 2, 1, 0)
	xorq	%rdi, %rdi
	addq	$0x29, %rdi
	xorq	%rsi, %rsi
	addq	$0x02, %rsi
	xorq	%rdx, %rdx
	incq	%rdx
	xorq	%rcx, %rcx
	call	syscall

	# save socket descriptor into %rsi
	movq	%rax, sock_fd

	# call syscall(__NR_setsockopt = 0x36, fd, SOL_SOCKET, SO_REUSEADDR, &{ val = 1 }, (1 << 3))
	xorq	%rdi, %rdi
	addq	$0x36, %rdi
	xorq	%rsi, %rsi
	addq	sock_fd, %rsi
	xorq	%rdx, %rdx
	incq	%rdx
	xorq	%rcx, %rcx
	incq	%rcx
	incq	%rcx
	xorq	%rbx, %rbx
	incq	%rbx
	pushq	%rbx
	xorq	%rbx, %rbx
	leaq	(%rsp), %r8
	xorq	%r9, %r9
	addq	$0x8, %r9
	call	syscall

	# call syscall(__NR_bind = 0x31, fd, (struct sockaddr *)&sockptr, (socklen_t)(1 << 4))
	xorq	%rbx, %rbx
	pushq	%rbx
	addw	$0x697a, %bx
	pushw	%bx
	xorq	%rbx, %rbx
	incq	%rbx
	incq	%rbx
	pushw	%bx
	xorq	%rbx, %rbx
	xorq	%rdi, %rdi
	addq	$0x31, %rdi
	xorq	%rsi, %rsi
	addq	sock_fd, %rsi
	xorq	%rdx, %rdx
	leaq	(%rsp), %rdx
	xorq	%rcx, %rcx
	addq	$0x10, %rcx
	call	syscall

.L0:
	# call syscall(__NR_listen = 0x32, fd, 0)
	xorq	%rdi, %rdi
	addq	$0x32, %rdi
	xorq	%rsi, %rsi
	addq	sock_fd, %rsi
	xorq	%rdx, %rdx
	call	syscall

	# call syscall(__NR_accept = 0x2b, sock_fd, NULL, NULL)
	xorq	%rdi, %rdi
	addq	$0x2b, %rdi
	xorq	%rsi, %rsi
	addq	sock_fd, %rsi
	xorq	%rbx, %rbx
	pushq	%rbx
	leaq	(%rsp), %rdx
	leaq	(%rsp), %rcx
	call	syscall

	# whether connection has established, save
	# current connection descriptor state
	# into 'accept_fd'
	movq	%rax, accept_fd

	# call syscall(__NR_write = 1, fd, buf, strlen(buf))
	xorq	%rdi, %rdi
	incq	%rdi
	xorq	%rsi, %rsi
	addq	accept_fd, %rsi
	leaq	response, %rdx
	xorq	%rcx, %rcx
	addq	$0x71, %rcx
	call	syscall

	# call syscall(__NR_close = 3, accept_fd)
	xorq	%rdi, %rdi
	addq	$0x03, %rdi
	xorq	%rsi, %rsi
	addq	accept_fd, %rsi
	call	syscall

	# ...
	jmp	.L0
