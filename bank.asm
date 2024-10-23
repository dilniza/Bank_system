data segment
    pkey db "Press any key...$"
    options db 13, 10, "Choose an Option: $"
    account db 13, 10, "1-Create a New Account $"
    login db 13, 10, "2-Login $"
    money db 13, 10, "3-Total Money $"
    exit db 13, 10, "4-Exit program $"
    outputName db 13, 10, "Name: $"
    outputSurname db 13, 10, "Surname: $"
    inputName db 20 dup('$')
    inputSurname db 20 dup('$')
    inputBuffer db 10 dup('$')
    dollar db "100 $"
    totalMoney db "Total amount: $"
    error db "Invalid input. Please enter a valid number.$"
    loan_amount_prompt db "Enter loan amount: $"
    yesOption db 13, 10, "For Yes - Press Y key $"
    noOption db 13, 10, "For No - Press N key $"
    emptySpace db 13, 10, '$'
    loanAmount db ?
ends

code segment
assume cs:code, ds:data

clearScreen proc
    mov ah, 00h
    mov al, 03h
    int 10h
    ret
clearScreen endp

getStringInput proc
    push ax
    push dx
    lea dx, inputBuffer
    mov ah, 0ah
    int 21h
    pop dx
    pop ax
    ret
getStringInput endp

displayAndInput proc
    push ax
    push dx
    mov ah, 09h
    int 21h
    mov ah, 01h
    int 21h
    pop dx
    pop ax
    ret
displayAndInput endp

printString proc
    push dx
    mov ah, 09h
    int 21h
    pop dx
    ret
printString endp

start:
    mov ax, @data
    mov ds, ax

mainLoop:
    call clearScreen
    lea dx, options
    call printString
    lea dx, account
    call printString
    lea dx, login
    call printString
    lea dx, money
    call printString
    lea dx, exit
    call printString
    call displayAndInput
    cmp al, '1'
    je account_creation
    cmp al, '2'
    je login_process
    cmp al, '3'
    je money_process
    cmp al, '4'
    je exit_program
    jmp mainLoop

account_creation:
    call clearScreen
    lea dx, outputName
    call printString
    call getStringInput
    ; Save the input to inputName
    lea si, inputBuffer + 2
    lea di, inputName
    mov cx, 20
copyName:
    lodsb
    stosb
    loop copyName
    lea dx, outputSurname
    call printString
    call getStringInput
    ; Save the input to inputSurname
    lea si, inputBuffer + 2
    lea di, inputSurname
    mov cx, 20
copySurname:
    lodsb
    stosb
    loop copySurname
    jmp mainLoop

login_process:
    call clearScreen
    lea dx, outputName
    call printString
    call getStringInput
    lea si, inputBuffer + 2
    lea di, inputName
    mov cx, 20
checkName:
    lodsb
    cmpsb
    loop checkName
    lea dx, outputSurname
    call printString
    call getStringInput
    lea si, inputBuffer + 2
    lea di, inputSurname
    mov cx, 20
checkSurname:
    lodsb
    cmpsb
    loop checkSurname
    jmp mainLoop

money_process:
    call clearScreen
    call displayCurrentBalance
    call getLoanDecision
    jmp mainLoop

exit_program:
    mov ah, 4ch
    int 21h

displayCurrentBalance proc
    lea dx, totalMoney
    call printString
    lea dx, dollar
    call printString
    ret
displayCurrentBalance endp

getLoanDecision proc
    push ax
    push dx
    call displayLoanPrompt
    call displayAndInput
    cmp al, 'y'
    je take_loan
    cmp al, 'Y'
    je take_loan
    cmp al, 'n'
    je no_loan
    cmp al, 'N'
    je no_loan
    jmp getLoanDecision

take_loan:
    call getLoanAmount
    inc loanAmount

no_loan:
    pop dx
    pop ax
    ret
getLoanDecision endp

getLoanAmount proc
    push ax
    push dx
    push bx
    call getStringInput
    mov ah, 0
    mov al, 0
    mov bl, [inputBuffer+2]
    sub bl, 48
    mov loanAmount, bl
    pop bx
    pop dx
    pop ax
    ret
getLoanAmount endp

displayLoanPrompt proc
    push ax
    push dx
    lea dx, loan_amount_prompt
    call printString
    pop dx
    pop ax
    ret
displayLoanPrompt endp

code ends
end start
