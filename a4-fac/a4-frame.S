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
    pushq %rbp                # store the caller's base pointer
    movq %rsp, %rbp          # initialize the base pointer

    call inout
        
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
    
    leaq -8(%rbp), %rsi                    
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

    push %rdi           # push the params to the stack 

    cmpq $0, %rdi       # if the argument i s zero return 1 
    je return1

    cmpq $1, %rdi       # if the argument is 1 return the base case
    je base_case
    
    dec %rdi
    call factorial
    pop %r8
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

