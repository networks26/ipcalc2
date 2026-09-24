/* x86-64 GNU assembler, System V ABI.
 * libc does the boring string work for us:
 *   sscanf() parses a.b.c.d
 *   strtol() parses the prefix
 *   printf() prints the answers
 *
 * The networking calculation itself is the student task.
 */

.section .rodata
scan_ip:        .string "%u.%u.%u.%u"
usage_msg:      .string "usage: ./ipcalc2 IP PREFIX"
invalid_ip:     .string "invalid IPv4 address"
invalid_prefix: .string "prefix must be between 1 and 30"
fmt_ipv4:       .string "%s%u.%u.%u.%u\n"
fmt_hosts:      .string "Usable hosts: %u\n"
label_ip:       .string "IP: "
label_mask:     .string "Netmask: "
label_network:  .string "Network: "
label_bcast:    .string "Broadcast: "
label_first:    .string "First usable: "
label_last:     .string "Last usable: "

.text

/* print_ipv4_line(label, value)
 *   rdi = label
 *   esi = 32-bit IPv4 value
 */
.type print_ipv4_line, @function
print_ipv4_line:
    pushq %rbp
    movq %rsp, %rbp

    movl %esi, %r10d
    movq %rdi, %rsi
    leaq fmt_ipv4(%rip), %rdi

    movl %r10d, %edx
    shrl $24, %edx

    movl %r10d, %ecx
    shrl $16, %ecx
    andl $255, %ecx

    movl %r10d, %r8d
    shrl $8, %r8d
    andl $255, %r8d

    movl %r10d, %r9d
    andl $255, %r9d

    xorl %eax, %eax
    call printf@PLT

    popq %rbp
    ret
.size print_ipv4_line, .-print_ipv4_line

.globl main
.type main, @function
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $64, %rsp

    cmpl $3, %edi
    jne .Lusage
    movq %rsi, -8(%rbp)          /* argv */

    /* sscanf(argv[1], "%u.%u.%u.%u", &a, &b, &c, &d) */
    movq -8(%rbp), %rax
    movq 8(%rax), %rdi
    leaq scan_ip(%rip), %rsi
    leaq -12(%rbp), %rdx
    leaq -16(%rbp), %rcx
    leaq -20(%rbp), %r8
    leaq -24(%rbp), %r9
    xorl %eax, %eax
    call __isoc99_sscanf@PLT
    cmpl $4, %eax
    jne .Lbad_ip

    cmpl $255, -12(%rbp)
    ja .Lbad_ip
    cmpl $255, -16(%rbp)
    ja .Lbad_ip
    cmpl $255, -20(%rbp)
    ja .Lbad_ip
    cmpl $255, -24(%rbp)
    ja .Lbad_ip

    /* Pack the four octets into one 32-bit integer: ip. */
    movl -12(%rbp), %eax
    shll $24, %eax
    movl -16(%rbp), %edx
    shll $16, %edx
    orl %edx, %eax
    movl -20(%rbp), %edx
    shll $8, %edx
    orl %edx, %eax
    orl -24(%rbp), %eax
    movl %eax, -28(%rbp)         /* ip */

    /* prefix = strtol(argv[2], NULL, 10) */
    movq -8(%rbp), %rax
    movq 16(%rax), %rdi
    xorl %esi, %esi
    movl $10, %edx
    call strtol@PLT
    movl %eax, -32(%rbp)         /* prefix */

    cmpl $1, -32(%rbp)
    jl .Lbad_prefix
    cmpl $30, -32(%rbp)
    jg .Lbad_prefix

    /* Parsing is finished.
     *
     *   -28(%rbp) = ip
     *   -32(%rbp) = prefix
     *
     * Fill in the calculations below.  Keep the results in:
     *   -36 mask, -40 network, -44 broadcast,
     *   -48 first, -52 last, -56 hosts
     */

    movl $0, -36(%rbp)           /* TODO: mask */
    movl $0, -40(%rbp)           /* TODO: network */
    movl $0, -44(%rbp)           /* TODO: broadcast */
    movl $0, -48(%rbp)           /* TODO: first */
    movl $0, -52(%rbp)           /* TODO: last */
    movl $0, -56(%rbp)           /* TODO: hosts */

    leaq label_ip(%rip), %rdi
    movl -28(%rbp), %esi
    call print_ipv4_line

    leaq label_mask(%rip), %rdi
    movl -36(%rbp), %esi
    call print_ipv4_line

    leaq label_network(%rip), %rdi
    movl -40(%rbp), %esi
    call print_ipv4_line

    leaq label_bcast(%rip), %rdi
    movl -44(%rbp), %esi
    call print_ipv4_line

    leaq label_first(%rip), %rdi
    movl -48(%rbp), %esi
    call print_ipv4_line

    leaq label_last(%rip), %rdi
    movl -52(%rbp), %esi
    call print_ipv4_line

    leaq fmt_hosts(%rip), %rdi
    movl -56(%rbp), %esi
    xorl %eax, %eax
    call printf@PLT

    xorl %eax, %eax
    leave
    ret

.Lusage:
    leaq usage_msg(%rip), %rdi
    call puts@PLT
    movl $2, %eax
    leave
    ret

.Lbad_ip:
    leaq invalid_ip(%rip), %rdi
    call puts@PLT
    movl $2, %eax
    leave
    ret

.Lbad_prefix:
    leaq invalid_prefix(%rip), %rdi
    call puts@PLT
    movl $2, %eax
    leave
    ret
.size main, .-main

.section .note.GNU-stack,"",@progbits
