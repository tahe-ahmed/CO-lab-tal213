# *********************************************************************************
# * Program name: Hello World                                                     *
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
    exit: jmp _exit
#endif

.data
mystring : .asciz "Tahe Ahmed, Num: %d, Assignment %d\n"

.text
# your strings here

.global my_main                 # make my_main accessible globally
formatstr:  .asciz "%c\n"       # format string for number printing

my_main:
	# IMPLEMENT ME    
    pushq  %rbp                 # store the caller's base pointer
    movq   %rsp, %rbp           # initialize the base pointer

    leaq mystring(%rip), %rdi   # first argument the string from data (load address of mystring  into rdi)
    movq $3454243, %rsi         # second argument the student number
    movq $1, %rdx               # third argument the assignment number
	movq $0, %rax               # no vector arguments                        
    call printf              
end:
	mov     $0, %rdi            # load program exit code
	call    exit                # exit the program

