# *********************************************************************************
# * Program name: fibonacci                                                       *
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
    malloc: jmp _malloc
    calloc: jmp _calloc
    realloc: jmp _realloc
    free: jmp _free
    exit: jmp _exit
#endif

.data
mystring: .asciz "%ld\n"

.text
# your strings here
formatstr: .asciz "%ld"

.global my_main
.global fibonacci


my_main:
        # IMPLEMENT ME
    pushq %rbp                # store the caller's base pointer
    movq %rsp, %rbp          # initialize the base pointer

    subq $16, %rsp 
    
    leaq -8(%rbp), %rsi                     
    leaq formatstr(%rip), %rdi
    movq $0, %rax
    call scanf
        
    movq -8(%rbp), %rdi
    call fibonacci

    leaq mystring(%rip), %rdi   
    movq %rax, %rsi         
    movq $0, %rax                                    
    call printf
        
    # clear the stack and return
    mov   $0, %rdi            
	call  exit 

fibonacci:
    # IMPLEMENT ME

    pushq %rbp                # store the caller's base pointer
    movq %rsp, %rbp          # initialize the base pointer

    subq $16, %rsp


    # fibonacci sequence is 1 1 2 3 5 8 ....
    # array to store the sequence
    # loop until the nth
    # first two terms are 1 1  
    # third term is (3-1) + (3 -2)

    cmpq $1, %rdi
    je return_zero

    cmpq $2, %rdi
    je return_one

    cmpq $3, %rdi
    je return_one

    movq $1, -8(%rbp)  # %rdx           # a = 1
    movq $1, -16(%rbp) # %rcx           # b = 1

    subq $2, %rdi
    movq $1, %r9

           

iter:
    movq $0, %r8 
    add -8(%rbp) , %r8       # r8 = rdx + rcx
    add -16(%rbp), %r8

    movq -16(%rbp), %rdx

    movq %rdx, -8(%rbp) 
    movq %r8, -16(%rbp)

   

    incq %r9
    cmpq %rdi, %r9
    jl iter

  
    movq -16(%rbp), %rax

    movq %rbp, %rsp
    popq %rbp
    ret



return_one:
    movq $1, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

return_zero:
    movq $0, %rax
    movq %rbp, %rsp
    popq %rbp
    ret
