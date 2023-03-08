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
        
        # output incremented number
    leaq mystring(%rip), %rdi   
    movq %rax, %rsi         
    movq $0, %rax                                    
    call printf 

    movq %rbp, %rsp
    popq %rbp

    # clear the stack and return
    mov   $0, %rdi            
	call  exit 

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

    
    movq %rbp, %rsp
    popq %rbp
    ret

factorial:

    pushq %rbp               
    movq %rsp, %rbp        
 
    subq $16, %rsp 

    movq %rdi, -8(%rbp)
    

    cmpq $0, %rdi
    je return1

    cmpq $1, %rdi
    je base_case
    
    dec %rdi
    call factorial
    movq -8(%rbp), %r8
    mul %r8

     movq %rbp, %rsp
    popq %rbp
    ret

base_case:
    movq $1, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

return1:
    movq $1, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

