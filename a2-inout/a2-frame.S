# *********************************************************************************
# * Program name: inout                                                           *
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
mystring : .asciz "%d\n"

.text
# your strings here
formatstr: .asciz "%d"

.global my_main                         # make my_main accessible globally
.global my_increment                    # make my_increment accessible globally

my_main:
        # set up the stack frame
        pushq   %rbp                # store the caller's base pointer
        movq    %rsp, %rbp          # initialize the base pointer

        call    inout                

        # clear the stack and return

        movq %rbp, %rsp
        popq %rbp

        movq $60, %rax
        movq $0, %rdi
        syscall

inout:
        # read input and increment it using my_increment

        pushq %rbp                       # store the caller's base pointer
	movq %rsp, %rbp                  # initialize the base pointer

        subq $16, %rsp 
       
        leaq -8(%rbp), %rsi                     # -8(%rbp) hold input
        leaq formatstr(%rip), %rdi
        movq $0, %rax
        call scanf
          
        movq -8(%rbp), %rdi
        call my_increment

        # output incremented number
        leaq mystring(%rip), %rdi       # first argument the string from data (load address of mystring  into rdi)
        movq %rax , %rsi                 # second argument 
        movq $0, %rax                   # no vector arguments                        
        call printf 

        movq %rbp, %rsp
        popq %rbp
        ret

my_increment:
        # IMPLEMENT ME
        pushq   %rbp                
	movq    %rsp, %rbp          

        incq %rdi
        movq %rdi, %rax

        movq %rbp, %rsp
        popq %rbp
        ret
