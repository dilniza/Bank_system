org 100h
include "emu8086.inc"

;jump here to start again
continue:

;options are given
lea dx, options
mov ah, 9
int 21h

lea dx, account
mov ah, 9
int 21h

lea dx, login
mov ah, 9
int 21h
  
lea dx, money
mov ah, 9
int 21h  
 
lea dx, exit
mov ah, 9
int 21h

;input option
call input_option

;compare it with options
cmp al, 31h
je account_jump

cmp al, 32h
je login_jump

cmp al, 33h
je money_jump

cmp al, 34h
je exit_jump

;1st opt, 31h
account_jump:
    lea dx, outputName
    mov ah, 9
    int 21h 
    
    mov ah, 0ah
    lea dx, inputName       ; to store input in var
    int 21h
    
    lea dx, outputSurname
    mov ah, 9
    int 21h
    
    mov ah, 0ah
    lea dx, inputSurname
    int 21h
       
    lea dx, outputCountry
    mov ah, 9
    int 21h
    
    mov ah, 0ah   
    lea dx, inputCountry
    int 21h
    
    lea dx, outputPhoneNum
    mov ah, 9
    int 21h
    
    mov ah, 0ah      
    lea dx, inputPhoneNum
    int 21h

call wantContinue

;2nd opt, 32h    
login_jump:
    lea dx, enterName
    mov ah, 9
    int 21h
    
    mov ah, 0ah
    lea dx, enteredName
    int 21h
      
      
    lea dx, enterPhone
    mov ah, 9
    int 21h
    
    mov ah, 0ah 
    lea dx, enteredPhone
    int 21h
    
call wantContinue

;3rd opt, 33h
money_jump:
    call emptySpaceFunc
    
    PRINT "Total amount: "
    lea dx, dollar
    mov ah, 9
    int 21h
    
    call emptySpaceFunc
    
    Printn "Do you want to take a loan?"
    
    call emptySpaceFunc  
    
    mov dx, offset yesOption
    mov ah, 9
    int 21h
    
    mov dx, offset noOption
    mov ah, 9
    int 21h
    
    call emptySpaceFunc
     
    call input_option
        
    cmp al, 59h
    je yesAnswer_money
    cmp al, 79h
    je yesAnswer_money
    
    cmp al, 4Eh 
    je noAnswer_money 
    cmp al, 6Eh
    je noAnswer_money  
    
    jne exit_jump  
        
    yesAnswer_money:  
    
    mov bl, dollar
    sub bl, 30h
    inc bl  
    
    mov stringDollar[0], bl  
    
    call dollarFuncNum
    
    ;increment + hex to dec
    mov si, 1
    mov cx, 2
    mov bh, 0
    lupHexDec1:
    cmp si, 0
    je zeroDegree1
    cmp si, 1
    je oneDegree1
    jne notEqual1
    
    zeroDegree1:
    mov al, [dollar+si]
    mov bl, 1
    mul bl
    add bh, al
    oneDegree1:
    mov al, [dollar+si]
    mov bl, 16
    mul bl
    add bh, al
    
    dec si
    loop lupHexDec1
    
    notEqual1: 
     
    call dollarFuncString
    
    jmp stop_money
    
    noAnswer_money:     
    
    mov bl, dollar
    sub bl, 30h
    dec bl
    
    mov stringDollar[0], bl
    
    call dollarFuncNum
    
    ;increment + hex to dec
    mov si, 1
    mov cx, 2
    mov bh, 0
    lupHexDec2:
    cmp si, 0
    je zeroDegree2
    cmp si, 1
    je oneDegree2
    jne notEqual2
    
    zeroDegree2:
    mov al, [dollar+si]
    mov bl, 1
    mul bl
    add bh, al
    oneDegree2:
    mov al, [dollar+si]
    mov bl, 16
    mul bl
    add bh, al
    
    dec si
    loop lupHexDec2
    
    notEqual2:
    
    stop_money:
    
    mov stringDollar, bh
 
   call dollarFuncString
 
    call printDollar
        
call wantContinue

;4th opt, 34h
exit_jump:
    call emptySpaceFunc
    
    PRINTN "You quitted. Good Bye!" 
mov ah, 4ch
  
ret  ;END RET

;function
input_option proc
    mov ah, 1
    int 21h 
ret
input_option endp

;function
wantContinue proc
    mov dx, offset wantToContinue
    mov ah, 9
    int 21h
    mov dx, offset emptySpace
    mov ah, 9
    int 21h
    PRINT "Press Y to Continue. Press any key to quit"
    
    call input_option     
    
    cmp al, 79h
    je yesAnswer
    
    cmp al, 59h
    je yesAnswer
    jne noAnswer     
    
    yesAnswer:
    jmp continue
     
    noAnswer: 
    jmp exit_jump
     
ret
wantContinue endp    

;emptySpace function
emptySpaceFunc proc    
    lea dx, emptySpace
    mov ah, 9
    int 21h
ret
emptySpaceFunc endp

;dollar function NUM
dollarFuncNum proc   
     
    mov si, 2
    mov al, dollar
    mov bl, 10h
    mov ah, 0
    
    lupDollar2:
    div bl      
    mov numDollar[si], ah        
    mov ah, 0
     
    cmp al, 0h
    je stop_lup 
    dec si
    loop lupDollar2
     
    stop_lup:
    
ret
dollarFuncNum endp    

;dollar function STRING
dollarFuncString proc  
    mov si, 0
    mov cx, 3
    lupDollar1:
    mov bl, numDollar[si]
    add bl, 30h
    mov stringDollar[si], bl
    inc si 
    loop lupDollar1
ret
dollarFuncString endp

;print dollar function
printDollar proc
    PRINT "Total amount: "
    lea dx, stringDollar[0]
    mov ah, 9
    int 21h 
ret
printDollar endp

;options vars
options db 13, 10, "Choose an Option: $"
account db 13, 10, "1-Create a New Account $"
login db 13, 10, "2-Login $"
money db 13, 10, "3-Total Money $"
exit db 13, 10, "4-Exit program $"

;1st option vars for output
outputName db 13, 10, "Name: $"
outputSurname db 13, 10, "Surname: $"
outputCountry db 13, 10, "Country of residence: $"
outputPhoneNum db 13, 10, "Phone Number: $"

;1st option vars for input
inputName db 21, ?, 21 dup("$")
inputSurname db 21, ?, 21 dup("$")
inputCountry db 21, ?, 21 dup("$")
inputPhoneNum db 21, ?, 21 dup("$")

;2nd option vars
enterName db 13, 10, "Your Name: $"
enterPhone db 13, 10, "Your Phone Number: $"
enteredPhone db 21, ?, 21 dup("$")
enteredName db 21, ?, 21 dup("$")  

;2nd option vars to cmp
yourPhoneNumber db "887778877 $"
yourName db "Dilnoza $"  

;3rd option var
dollar db "100 $"
numDollar db 21, ?, 21 dup("$")
stringDollar db 21, ?, 21 dup("$")

;continue function
wantToContinue db 13, 10, "Do You Want To Continue? $"

;empty
emptySpace db 13, 10, "$"   

;options yes/no
yesOption db 13, 10, "For Yes - Press Y key $"
noOption db 13, 10, "For No - Press N key $"
end