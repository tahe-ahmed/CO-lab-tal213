# *********************************************************************************
# * Program name: factorial                                                       *
# * Description :                                                                 *
# *********************************************************************************

#ifndef MACOS
.ifndef CODEGRADE
    .global main
    main: jmp my_main
.endif
#else
    .global _main
    _main: jmp my_main
    printf: jmp _printf
    scanf: jmp _scanf
    exit: jmp _exit
#endif

.data
mystring : .asciz "%ld\n"

.text
# your strings here
formatstr: .asciz "%ld"

.global my_main
.global factorial


my_main:
        # IMPLEMENT ME
    pushq %rbp                # store the caller's base pointer
    movq %rsp, %rbp          # initialize the base pointer

    call inout
        
    movq %rbp, %rsp
    popq %rbp

    movq $60, %rax
    movq $0, %rdi
    syscall

inout:
    pushq %rbp                # store the caller's base pointer
    movq %rsp, %rbp          # initialize the base pointer
    subq $16, %rsp 
    # read input and increment it using my_increment
    
    leaq -8(%rbp), %rsi                     # -8(%rbp) hold input
    leaq formatstr(%rip), %rdi
    movq $0, %rax
    call scanf
        
    movq -8(%rbp), %rdi
    call factorial

    # output incremented number
    leaq mystring(%rip), %rdi   # first argument the string from data (load address of mystring  into rdi)
    movq %rax, %rsi         # second argument the student number
    movq $0, %rax               # no vector arguments                        
    call printf 

    movq %rbp, %rsp
    popq %rbp
    ret

factorial:
        # IMPLEMENT ME
// pushq %rbp
    // movq %rsp, %rbp
    
    // movq $8, %rsp

    // movq %rdi, %rax
    cmpq $1, %rdi
    je base_case


    // subq $1, %rax
    // movq %rax, %rdi 
    movq %rdi, %rbx
    mul %rbx
    dec %rdi
    call factorial
    // cmpq $0, -8(%rbp)
    // subq $1, -8(%rbp)
    // movq -8(%rbp), %rdi
    // jg factorial

    // movq $1, %rax

base_case:
    // movq %rbp, %rsp
    // popq %rbp
    ret
        # IMPLEMENT ME