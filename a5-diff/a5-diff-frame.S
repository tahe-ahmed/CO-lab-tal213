# *********************************************************************************
# * Program name: diff                                                            *
# * Description : Line-by-line diff                                               *
# *********************************************************************************

#ifdef MACOS
    .global _diff
    _diff: jmp diff
    fgets: jmp _fgets
    fread: jmp _fread
    fprintf: jmp _fprintf
    fscanf: jmp _fscanf
    printf: jmp _printf
    strcasecmp: jmp _strcasecmp
    strcmp: jmp _strcmp
    strcpy: jmp _strcpy
    strlen: jmp _strlen
    strncasecmp: jmp _strncasecmp
    strncmp: jmp _strncmp 
    strncpy: jmp _strncpy
    strnlen: jmp _strnlen
    malloc: jmp _malloc
    exit: jmp _exit
#endif



.text

changestring: 
            .ascii "%dc%d\n"
		    .ascii "< %s"
		    .ascii "---\n"
		    .asciz "> %s"

.global diff

# ************************************************************************
# * Subroutine: diff
# * Description: A simplified line-by-line implementation of diff
# * Specification: int diff(FILE *a, FILE *b, bool i_flag, bool B_flag);         
# ************************************************************************
diff:
    pushq   %rbp                # store the caller's base pointer
	movq    %rsp, %rbp          # initialize the base pointer

    subq $2064, %rsp
    movq %rdi, -8(%rbp)            # *file1
    movq %rsi, -16(%rbp)           # *file2
    movq %rdx, -48(%rbp)            # i argu
    movq %rcx, -56(%rbp)            # B argu

    movq $1000, %rdi
    call malloc
    
    movq %rax, -24(%rbp)            # buffer 1

    movq $1000, %rdi
    call malloc

    movq %rax, -32(%rbp)            # buffer 2

    movq $0, -40(%rbp)              # counter for loop
iter:
    movq -24(%rbp), %rdi            # get a line from file 1
    movq $1000, %rsi
    movq -8(%rbp), %rdx
    call fgets

    cmpq $0, %rax                   # check end of file line
    je done
    
    cmpq $1, -56(%rbp)              # check ignoe blank line argument
    je B_argu
    jmp not_ignore_blank


################# handling B argument ignore blank line
B_argu:
    movq -24(%rbp), %rdi
    call strlen

    cmpq $1, %rax
    je ignore_blank
    jmp not_ignore_blank

ignore_blank:
    incq -40(%rbp)
    jmp iter

not_ignore_blank:

    movq -32(%rbp), %rdi            # get a line from file 2
    movq $100, %rsi
    movq -16(%rbp), %rdx
    call fgets

    cmpq $0, %rax                   # check end of file line
    je done



    cmpq $1, -48(%rbp)              # check for ignore case argument
    je ignore_case

    jmp not_ignore_case

################# handling i argument ignore case
ignore_case:
    movq -24(%rbp), %rdi
    movq -32(%rbp),  %rsi
    call strcasecmp

    incq -40(%rbp)

    cmpq $0, %rax
    jne not_same
    
    jmp iter

not_ignore_case:
    movq -24(%rbp), %rdi
    movq -32(%rbp),  %rsi
    call strcmp

    incq -40(%rbp)

    cmpq $0, %rax
    jne not_same
    
    jmp iter

not_same:

    movq -24(%rbp), %rdi
    call strlen

    movq %rax, -64(%rbp)        # -64(%rbp) holds the length of line characters
   
    movq -24(%rbp), %r9

    // sub $1, %rax
    // movq ( %r9, %rax), %r8
    // movq %r8, -72(%rbp)             # -72(%rbp) holds the last character length - 1

    // cmpq $10, %r8
    // je remove_newline

    // add $1, %rax
    // movq ( %r9, %rax), %r8
    // movq %r8, -72(%rbp)             # -72(%rbp) holds the last character length - 1

    // cmpq $10, %r8
    // je remove_newline

    sub $0, %rax
    movq ( %r9, %rax), %r8
    movq %r8, -72(%rbp)             # -72(%rbp) holds the last character length - 1


    // cmpq $10, %r8
    // je remove_newline

    cmpq $0, %r8
    je remove_newline

    jmp not_remove_newline

remove_newline:
    subq $1, %rax
    movq ( %r9, %rax), %r8

    cmpq $10, %r8
    je not_remove_newline

    add $1, %rax
    movq $10, ( %r9, %rax)

not_remove_newline:
    

    leaq changestring(%rip), %rdi   
    movq -40(%rbp), %rsi 
    movq -40(%rbp) , %rdx   
    movq -24(%rbp), %rcx
    movq -32(%rbp), %r8
    movq $0, %rax                                    
    call printf

    jmp iter


done:
    movq $1, %rax
    movq %rbp, %rsp
    popq %rbp
    ret



//  movq -24(%rbp), %rdi
//     call strlen

//     movq %rax, -64(%rbp)        # -64(%rbp) holds the length of line characters
   
//     movq -24(%rbp), %r9

//     sub $1, %rax
//     movq ( %r9, %rax), %r8
//     movq %r8, -72(%rbp)             # -72(%rbp) holds the last character length - 1

//     cmpq $10, %r8
//     je remove_newline

//     jmp not_remove_newline

// remove_newline:
//     movq $0, ( %r9, %rax)