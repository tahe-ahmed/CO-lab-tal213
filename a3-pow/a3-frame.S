# *********************************************************************************
# * Program name: pow                                                             *
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
.global my_pow


my_main:
    pushq   %rbp                # store the caller's base pointer
	movq    %rsp, %rbp          # initialize the base pointer

    subq $16, %rsp 

    leaq -8(%rbp), %rsi                     
    leaq formatstr(%rip), %rdi
    movq $0, %rax
    call scanf

    leaq -16(%rbp), %rsi                     
    leaq formatstr(%rip), %rdi
    movq $0, %rax
    call scanf
          
    movq -8(%rbp), %rdi
    movq -16(%rbp), %rsi
    call    my_pow

    leaq mystring(%rip), %rdi   
    movq %rax, %rsi         
    movq $0, %rax                                     
    call printf

    # clear the stack and return
    mov   $0, %rdi            
	call  exit    

my_pow:
    pushq   %rbp                # store the caller's base pointer
	movq    %rsp, %rbp          # initialize the base pointer


    subq $32, %rsp 

    movq %rdi, -16(%rbp)
    movq %rsi, -24(%rbp)


    cmpq $0, %rsi                         
	jle  return1
    
	movq -24(%rbp), %r8           
    movq -16(%rbp), %rax
    movq -16(%rbp), %rcx
loop1:
	cmpq $1, %r8                           
	je  endLoop   
    dec %r8
    mul %rcx
    jmp loop1

return1:
    movq $1, %rax

endLoop:
   
    movq %rbp, %rsp
    popq %rbp
    ret
