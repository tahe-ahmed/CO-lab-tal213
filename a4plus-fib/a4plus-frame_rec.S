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

    subq $32, %rsp 

    leaq -8(%rbp), %rsi                     # -8(%rbp) hold input
    leaq formatstr(%rip), %rdi
    movq $0, %rax
    call scanf

    movq -8(%rbp), %rdi
    call fibonacci

    movq %rax, -16(%rbp)
    leaq mystring(%rip), %rdi   
    movq -16(%rbp), %rsi    
    movq $0, %rax                                    
    call printf

    movq %rbp, %rsp
    popq %rbp  

    mov   $0, %rdi            
	call  exit 

    

fibonacci:
        
    pushq %rbp              # Save the frame pointer
    movq %rsp, %rbp         # Set up the new frame pointer
    subq $16, %rsp          # Allocate space on the stack for local variables

    movq %rdi, -8(%rbp)     # Save the function argument
    cmpq $1, -8(%rbp)       # Compare the argument with 1
    jle .L2                 # Jump to the return statement if n <= 1

    movq -8(%rbp), %rax     # Load n into the accumulator
    subq $1, %rax           # Compute n - 1
    movq %rax, %rdi         # Pass n - 1 as the argument to fib
    call fibonacci                # Recursively compute fib(n - 1)
    movq %rax, -16(%rbp)     # Save the result in a local variable

    movq -8(%rbp), %rax     # Load n into the accumulator
    subq $2, %rax           # Compute n - 2
    movq %rax, %rdi         # Pass n - 2 as the argument to fib
    call fibonacci               # Recursively compute fib(n - 2)
    add -16(%rbp), %rax     # Add the two results together
    jmp .L3                 # Jump to the return statement

.L2:
    movq -8(%rbp), %rax     # Load n into the accumulator
    jmp .L4                 # Jump to the return statement

.L3:
    movq %rbp, %rsp
    popq %rbp                   # Deallocate the stack frame
    ret                     # Return to the caller

.L4:
    movq %rbp, %rsp
    popq %rbp                  # Deallocate the stack frame
    // xorq %rax, %rax         # Set the return value to 0
    ret                     # Return to the caller
