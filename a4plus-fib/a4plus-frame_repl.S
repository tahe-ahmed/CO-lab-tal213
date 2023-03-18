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

    movq $1, %rdi
    movq $0, %rsi
    call calloc

    movq %rax, %rdx
    movq %rax, -24(%rbp)
  
  # current Max
    movq $1, -16(%rbp)

reprompt:

    leaq -8(%rbp), %rsi                     # -8(%rbp) hold input
    leaq formatstr(%rip), %rdi
    movq $0, %rax
    call scanf
    

    cmpq $0, -8(%rbp)
    je end  
    
    cmpq $0, -8(%rbp)
    jl reprompt
   
    
    movq -8(%rbp), %rdi             # n
    movq -16(%rbp), %rsi            # curr_max
    movq -24(%rbp), %rdx                 # uint64_t *addr
    call fibonacci
        
    #update current_max
    movq -8(%rbp), %r8
    movq -16(%rbp), %r9
    cmpq %r8, %r9
    jl update_max
    jmp else

update_max:
    movq %r8, -16(%rbp)
else:
    // movq -8(%rbp), -16(%rbp)

    movq %rax, -24(%rbp)
    movq -8(%rbp), %rbx 
    sub $1, %rbx


    leaq mystring(%rip), %rdi   
    movq (%rax, %rbx, 8), %rsi    
    movq $0, %rax                                    
    call printf

    // movq -24(%rbp), %rax

    cmpq $0, -8(%rbp)
    jg reprompt

end:
    // movq %rdx, %rdi
    // call free
   
    # clear the stack and return
    mov   $0, %rdi            
	call  exit 


fibonacci:
    pushq %rbp                # store the caller's base pointer
    movq %rsp, %rbp          # initialize the base pointer

    sub $32, %rsp

    movq %rdi, -8(%rbp)
    movq %rsi, -16(%rbp)
    movq %rdx, -24(%rbp)

  

    cmpq %rsi, %rdi     # check if current_max >= n
    jle fetch_memory

    cmpq %rsi, %rdi      # check if current_max < n
    jg extend_size


extend_size:

    movq $8, %rax
    mul %rdi
     
    movq %rdx, %rdi     # *ptr
    movq %rax, %rsi     # size
    call realloc

    
    movq %rax, %rdx     # put the new point if it is new to %rdx


    # first three element in the sequence
    movq $0, %rbx 
    movq $0, (%rdx, %rbx, 8)

    movq $1, %rbx 
    movq $1, (%rdx, %rbx, 8)

    movq $2, %rbx 
    movq $1, (%rdx, %rbx, 8)

    movq $3, %rbx 
    movq $2, (%rdx, %rbx, 8)

    // add $8, %rdx
    
    movq $2, %r9
    movq $2, %rcx
    

// iter:
//     movq $0, %r8

//     sub $1, %r9   # 2 - 1 = 1
//     movq %r9, %rbx 
//     add  (%rdx, %rbx, 8), %r8

//     sub $1, %r9   #  2 - 2 = 0
//     movq %r9, %rbx 
//     add  (%rdx, %rbx, 8), %r8


//     movq %rcx, %rbx 
//     movq %r8, (%rdx, %rbx, 8)

//     incq %rcx
//     movq %rcx, %r9
//     cmpq  -8(%rbp), %rcx
//     jle iter

    movq %rdx, %rax
    movq %rbp, %rsp
    popq %rbp

    ret


 
    // movq %rdx, %rax    # return the pointer to the first value of an array in memory
    // movq -8(%rbp), %rbx
   


fetch_memory:

    movq %rdx,%rax
    movq %rbp, %rsp
    popq %rbp

    ret