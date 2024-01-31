;--------------------------------------------------------------------------------------------------;
;--------------------------------------------------------------------------------------------------;
;-------------------------------------------SNAKE GAME---------------------------------------------;
;--------------------------------------------------------------------------------------------------;
;--------------------------------------------------------------------------------------------------;

[org 0x0100]
jmp start


strDead  	: db '----------GAME OVER----------',0
snkDead  	: db 'Your Snake Died!',0
strName  	: db '------------------------SNAKE GAME------------------------', 0
StrSnke  	: db '...............',0
TeamName 	: db 'TeamName: Goal Diggers', 0
GrpMemstr	: db 'Group Members', 0
Name1	 	: db 'M.Affan Bukhari  (21F-9122)', 0
Name2	 	: db 'M.Sameer Rajpoot (21F-9083)', 0
PressMenu	: db 'Press Any key to go to Menu', 0 
PressGame	: db 'Press Any key to go to Game', 0 
Menu     	: db '----------Main Menu----------',0
Inst	 	: db 'Instructions:',0
Ins1	 	: db '* Press left arrow for left movement of snake',0
Ins2 	 	: db '* Press right arrow for right movement of snake',0
Ins3	 	: db '* Press up arrow for up movement of snake',0
Ins4	 	: db '* Press down arrow for down movement of snake',0
Note	 	: db 'Note:',0
Note1	 	: db '* If your snake touches food, its length will be increased by 1',0
Note2	 	: db '* If your snake touches boundary , Game will be over',0
Note3	 	: db '* If your snake touches itself , Game will be over',0
ScoreStr	: db 'Score : ',0
;snake		: db 01,0xf9,0xf9,0xf9,0xf9,0xf9
Isup		: db 0
Isdown		: db 0
Isleft		: db 0
Isright		: db 0
;foodcount	: db 0
Score		: db 0
count		: dd 0
Touched  	: db 0
storeLoc 	: dw 336
SnakeLoc	: dw 0
Border		: db '#'
SnakeLen	: dw 8

;--------------------------------------------------------------------------------------------------;
;---------------------------------Clearing screen Subroutine---------------------------------------;
;--------------------------------------------------------------------------------------------------;

    clearscreen:

push es
push ax
push di
push cx

mov ax, 0xb800	         ;video memory address
mov es, ax 		         ;point es to video base
xor di, di
mov ax, 0x4720 	         ;space char in normal attribute
mov cx, 2000 	         ;number of screen locations
cld 			         ;auto increment mode
rep stosw 		         ;clear the whole screen

pop cx
pop di
pop ax
pop es

ret

;--------------------------------------------------------------------------------------------------;
;-------------------------------------Introductory Display-----------------------------------------;
;--------------------------------------------------------------------------------------------------;

    DisplayIntro:


push ax
push cx
push ds

         ;Making border for the introductary display
call MakeBorder

;Displaying Game name
push ds 					; push segment of string
mov ax, strName
push ax 					; push offset of string
call strlenn 				; calculate string length

mov cx,ax
mov ax, strName
push ax 					; push offset of string
mov ax,980
push ax
push cx 					; push length of string
call printName				; call the printstr subroutine

                ;Displaying Snake
push ds
mov ax, StrSnke
push ax
call strlenn

mov cx,ax
mov ax, 0xb800				;video memory address
mov es, ax 					;point es to video base
mov di,1342
mov ax, 0x02f9 				;body of snake attribute
cld 						;auto increment mode
rep stosw 					;clear the whole screen
mov di,1372
mov ax,0x0201 				;Snake face attribute
mov [es:di],ax


                ;Displaying Team Name
push ds
mov ax, TeamName
push ax
call strlenn

mov cx,ax
mov ax, TeamName
push ax
mov ax,1656
push ax
push cx
call printName

           ;Displaying Group Members string
push ds
mov ax, GrpMemstr
push ax
call strlenn

mov cx,ax
mov ax, GrpMemstr
push ax
mov ax,1984
push ax
push cx
call printName

       ;Displaying Name and roll number of member 1
push ds
mov ax, Name1
push ax
call strlenn

mov cx,ax
mov ax, Name1
push ax
mov ax,2292
push ax
push cx
call printName

        ;Displaying Name and roll number of member 2
push ds
mov ax, Name2
push ax
call strlenn

mov cx,ax
mov ax, Name2
push ax
mov ax,2452
push ax
push cx
call printName

        ;Displaying string of going to menu instruction 
push ds
mov ax, PressMenu
push ax
call strlenn

mov cx,ax
mov ax, PressMenu
push ax
mov ax,2932
push ax
push cx
call printName		    ; call the printstr subroutine

pop ds
pop cx
pop ax

ret


;--------------------------------------------------------------------------------------------------;
;----------------------------------------Game Menu Display-----------------------------------------;
;--------------------------------------------------------------------------------------------------;
    
    DisplayMenu:

push ax
push cx
push ds

           ;Making border for the introductary display
call MakeBorder

            ;Displaying Game name
push ds 					; push segment of string
mov ax, Menu
push ax 					; push offset of string
call strlenn 				; calculate string length

mov cx,ax
mov ax, Menu
push ax 					; push offset of string
mov ax,690
push ax
push cx 					; push length of string
call printName				; call the printstr subroutine


        ;Displaying string instructions
push ds 
mov ax, Inst
push ax 
call strlenn

mov cx,ax
mov ax, Inst
push ax 	
mov ax,962
push ax
push cx
call printName				


        ;Displaying All instructions

push ds 					
mov ax, Ins1            ;Inst-1
push ax 					
call strlenn 				

mov cx,ax
mov ax, Ins1
push ax
mov ax,1288
push ax
push cx
call printName		

push ds 					
mov ax, Ins2            ;Inst-2
push ax 					
call strlenn 				

mov cx,ax
mov ax, Ins2
push ax
mov ax,1448
push ax
push cx
call printName		

push ds 					
mov ax, Ins3            ;Inst-3
push ax 					
call strlenn 				

mov cx,ax
mov ax, Ins3
push ax
mov ax,1608
push ax
push cx
call printName		

push ds 					
mov ax, Ins4
push ax 					
call strlenn 				

mov cx,ax
mov ax, Ins4            ;Inst-4
push ax
mov ax,1768
push ax
push cx
call printName				

            ;Displaying string Note
push ds 
mov ax, Note
push ax 
call strlenn

mov cx,ax
mov ax, Note
push ax 	
mov ax,2082
push ax
push cx
call printName

                ;Displaying All Notes

push ds 					
mov ax, Note1               ;Note-1
push ax 					
call strlenn 				

mov cx,ax
mov ax, Note1
push ax
mov ax,2408
push ax
push cx
call printName		

push ds 					
mov ax, Note2               ;Note-2
push ax 					
call strlenn 				

mov cx,ax
mov ax, Note2
push ax
mov ax,2568
push ax
push cx
call printName		

push ds 					
mov ax, Note3               ;Note-3
push ax 					
call strlenn 				

mov cx,ax
mov ax, Note3
push ax
mov ax,2728
push ax
push cx
call printName	

                ;Displaying string of going to menu instruction 
push ds 			
mov ax, PressGame
push ax 			
call strlenn 		

mov cx,ax
mov ax, PressGame
push ax 			
mov ax,3252
push ax
push cx 			
call printName		


pop ds
pop cx
pop ax

ret

;--------------------------------------------------------------------------------------------------;
;----------------------------------Printing score Subroutine---------------------------------------;
;--------------------------------------------------------------------------------------------------;

    printnum: 

push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push di

mov ax, 0xb800
mov es, ax 			; point es to video base
mov ax, [bp+4] 		; load number in ax
mov bx, 10 			; use base 10 for division
mov cx, 0 			; initialize count of digits

nextdigit: 

mov dx, 0 			; zero upper half of dividend
div bx 				; divide by 10
add dl, 0x30 		; convert digit into ascii value
push dx 			; save ascii value on stack
inc cx 				; increment count of values

cmp ax, 0 			; is the quotient zero
jnz nextdigit 		; if no divide it again

mov di, 82 		; point di to top left column

nextpos: 

pop dx ; remove a digit from the stack
mov dh, 0x02 ; use normal attribute
mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextpos ; repeat for all digits on stack

pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp

ret 2

;--------------------------------------------------------------------------------------------------;
;----------------------------------------------Food check------------------------------------------;
;--------------------------------------------------------------------------------------------------;

    FoodCollision:

push ax
push es
push di


mov ax,[storeLoc]
cmp [Snakeloccs],ax
jne exitFoodColl

add byte[Score],5

mov ax,0xb800
mov es,ax
mov di, word[storeLoc]
mov ah,0x47
mov al,0x20
mov [es:di],ax

call printFood

add byte[SnakeLen],1

exitFoodColl:

pop di
pop es
pop ax

ret

;--------------------------------------------------------------------------------------------------;
;-------------------------------------------Score Display------------------------------------------;
;--------------------------------------------------------------------------------------------------;
    
    ScoreDisp:

push ax
push cx
push ds


;Displaying Score string
push ds 					; push segment of string
mov ax, ScoreStr
push ax 					; push offset of string
call strlenn 				; calculate string length

mov cx,ax
mov ax, ScoreStr
push ax 					; push offset of string
mov ax,66
push ax
push cx 					; push length of string

call printName				; call the printstr subroutine

mov ax,[Score]
push ax

call printnum				;Displaying score stores in global variable SCORE

pop ds
pop cx
pop ax

ret

;--------------------------------------------------------------------------------------------------;
;-----------------------------Random Number Generation Subroutine----------------------------------;
;--------------------------------------------------------------------------------------------------;

    randomNumber:

push ax
push dx

mov ah, 00h 	;interrupts to get system time
int 1AH 		;CX:DX now hold number of clock ticks since midnight

mov ax, dx
xor dx, dx
mov cx, [bp-2] 	;upper number
div cx 			;here dx contains the remainder of the division - from 0 to 9

add dx, 0 		;to ascii from &#39;0&#39; to &#39;9&#39;
mov bx,dx

pop dx
pop ax

ret

;--------------------------------------------------------------------------------------------------;
;-----------------Large loop for Delay making Subroutine(After each move)--------------------------;
;--------------------------------------------------------------------------------------------------;

    delay:

mov dword[count],200000

delayLoop:
dec dword[count]
cmp dword[count],0
jne delayLoop

ret

;--------------------------------------------------------------------------------------------------;
;-------------------------------Printing snake Subroutine------------------------------------------;
;--------------------------------------------------------------------------------------------------;

    printSnake:

push bp
    mov bp, sp
    push ax
    push bx
    push si
    push cx
    push dx

	mov cx,[SnakeLen]
    mov di, 1996
    mov ax, 0xb800
    mov es, ax
    mov bx, [bp + 4]
    mov ah, 0x07
	mov al, 01
    snake_next_part:
        mov [es:di], ax
        mov [bx], di
        inc si
        add bx, 2

        add di, 2
		mov al,0xf9
        loop snake_next_part

    pop dx
    pop cx
    pop si
    pop bx
    pop ax
    pop bp
    ret 2

;--------------------------------------------------------------------------------------------------;
;---------------------------Printing snake right Subroutine----------------------------------------;
;--------------------------------------------------------------------------------------------------;

    printSnakeRight:

push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
    ;snake_parts colision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [SnakeLen]
    add dx, 2
    check_right_colision:
        cmp dx, [bx]
        je no_right_movement
        add bx, 2
        loop check_right_colision

    right_movement:
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    add dx, 2
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x07
    mov al, 0x01
    mov [es:di], ax             ;snake head placed

    mov cx, [SnakeLen]            ;snake length
    mov di, [bx]
    mov ah, 0x07
    mov al, 0xf9
    mov [es:di],ax
    right_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        
        loop right_location_sort
    mov di, dx
    mov ax, 0x4720
    mov [es:di], ax

    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2
	
    no_right_movement:
	call isDead

;--------------------------------------------------------------------------------------------------;
;----------------------------Printing snake left Subroutine----------------------------------------;
;--------------------------------------------------------------------------------------------------;

    printSnakeLeft:

push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
    ;snake_parts colision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [SnakeLen]
    sub dx, 2
    check_left_colision:
        cmp dx, [bx]
        je no_left_movement
        add bx, 2
        loop check_left_colision
    left_movement:
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    sub dx, 2
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x07
    mov al, 0x01
    mov [es:di],ax             ;snake head placed

    mov cx, [SnakeLen]
    mov di, [bx]
    mov ah, 0x07
    mov al, 0xf9
    mov [es:di],ax
    left_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        
        loop left_location_sort
    mov di, dx
    mov ax, 0x4720
    mov [es:di], ax

    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2
	
	no_left_movement:
	call isDead

;--------------------------------------------------------------------------------------------------;
;------------------------------------Printing snake up Subroutine----------------------------------;
;--------------------------------------------------------------------------------------------------;

    printSnakeUp:

push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
     ;snake_parts colision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [SnakeLen]
    sub dx, 160
    check_up_colision:
        cmp dx, [bx]
        je no_up_movement
        add bx, 2
        loop check_up_colision
    upward_movement:
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    sub dx, 160
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x07
    mov al, 0x01
    mov [es:di],ax             ;snake head placed

    mov cx, [SnakeLen]
    mov di, [bx]
    mov ah, 0x07
    mov al, 0xf9
    mov [es:di],ax
    up_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        
        loop up_location_sort
    mov di, dx
    mov ax, 0x4720
    mov [es:di], ax

    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2
	
	no_up_movement:
	
	call isDead

;--------------------------------------------------------------------------------------------------;
;-----------------------------Printing snake down Subroutine---------------------------------------;
;--------------------------------------------------------------------------------------------------;

    printSnakeDown:

push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
     ;snake_parts colision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [SnakeLen]
    add dx, 160
    check_down_colision:
        cmp dx, [bx]
        je no_down_movement
        add bx, 2
        loop check_down_colision

    downward_movement:
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    add dx, 160
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x07
    mov al, 0x01
    mov [es:di], ax             ;snake head placed

    mov cx, [SnakeLen]            ;snake length
    mov di, [bx]
    mov ah, 0x07
    mov al, 0xf9
    mov [es:di],ax
    down_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        loop down_location_sort
    mov di, dx
    mov ax, 0x4720
    mov [es:di], ax

    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2
	
	no_down_movement:
    
	call isDead

;--------------------------------------------------------------------------------------------------;
;----------------------------------Subroutine to select movement-----------------------------------;
;--------------------------------------------------------------------------------------------------;

    MoveSnake:

; Get keystroke
    push ax
    push bx

    repeat:
    mov ah,0
    int 0x16
    ; AH = BIOS scan code
    cmp ah,0x48
    je up
    cmp ah,0x4B
    je left
    cmp ah,0x4D
    je right
    cmp ah,0x50
    je down
    cmp ah,1
    jne repeat      ; loop until Esc is pressed
    ;Escape check
    mov ah,0x4c
    je exit
    ;UpWard Movement
    up:
        mov bx, Snakeloccs
        push bx
        call printSnakeUp
		cmp word[Snakeloccs],160
		jl dead
		;add byte[foodcount],1
		call FoodCollision
        jmp exit
    down:
        mov bx, Snakeloccs
        push bx
        call printSnakeDown
		cmp word[Snakeloccs],3838
		jg dead
		;add byte[foodcount],1
		call FoodCollision
        jmp exit
    left:
        mov bx, Snakeloccs
        push bx
        call printSnakeLeft
		mov cx,23
		mov di,160
		loopL:
		cmp di,[Snakeloccs]
		je dead
		add di,160
		loop loopL
		;add byte[foodcount],1
		call FoodCollision
        jmp exit
    right:
        mov bx, Snakeloccs
        push bx
        call printSnakeRight
		mov cx,23
		mov di,158
		loopR:
		cmp di,[Snakeloccs]
		je dead
		add di,160
		loop loopR
		;add byte[foodcount],1
		call FoodCollision		
    exit:
        pop bx
        pop ax
        ret
		
	dead:
		call isDead
		
;--------------------------------------------------------------------------------------------------;
;--------------------------------Finding Length Subroutine-----------------------------------------;
;--------------------------------------------------------------------------------------------------;

    strlenn: 

push bp
mov bp,sp
push es
push cx
push di

les di, [bp+4] 		; point es:di to string
mov cx, 0xffff 		; load maximum number in cx
xor al, al 			; load a zero in al

repne scasb			; find zero in the string

mov ax, 0xffff 		; load maximum number in ax
sub ax, cx 			; find change in cx
dec ax 				; exclude null from length

pop di
pop cx
pop es
pop bp
ret 4

;--------------------------------------------------------------------------------------------------;
;------------------------------------Displaying GameOver-------------------------------------------;
;--------------------------------------------------------------------------------------------------;

    isDead:

push cx
push dx
push ax
push bx
push si
push di

call delay				;Delaying

call clearscreen

call MakeBorder

push ds
mov ax,strDead
push ax
call strlenn

mov cx,ax

mov ax, strDead 
push ax 
mov ax, 1810
push ax

push cx
call printName

push ds
mov ax,snkDead
push ax
call strlenn

mov cx,ax

mov ax, snkDead 
push ax 
mov ax, 1984
push ax

push cx
call printName



pop di
pop si
pop bx
pop ax
pop dx
pop cx

mov ah,0
int 0x16

mov ax, 0x4c00
int 0x21


;-------------------------------------------------------------------------------------------------------;
;------------------------------------------Displaying String--------------------------------------------;
;-------------------------------------------------------------------------------------------------------;

    printName:
    
push bp
mov  bp, sp
push es
push ax
push cx 
push si 
push di 

mov ax, 0xb800 
mov es, ax 
  
mov si, [bp + 8]
mov di, [bp + 6]
mov cx, [bp + 4]
mov ah, 0x02 

nextchar1: 
mov al, [si]
mov [es:di], ax 
add di, 2 
add si, 1 

loop nextchar1


pop di 
pop si 
pop cx 
pop ax 
pop es 
pop bp 

ret 6 


;--------------------------------------------------------------------------------------------------------;
;----------------------------------------Print food Subroutine-------------------------------------------;
;--------------------------------------------------------------------------------------------------------;


    printFood:

push ax
push bx
push di
push es

cmp word[storeLoc],0
je conttt

mov ax,0xb800
mov es,ax
mov di,word[storeLoc]
mov ax,0x4720
mov [es:di],ax			;printing space at last food place

conttt:
jl exitfood

CalculatePos:

mov bx,80
mov [bp-2],bx

randX:
call randomNumber		;Storing random number in bx for x pos
mov [bp-4],bx			;Storing x pos in local variable

cmp bx,2
jb randX
cmp bx,78
ja randX

mov bx,25
mov [bp-2],bx

randY:
call randomNumber		;Storing random number in bx for y pos
mov [bp-2],bx			;Storing y pos in local variable

cmp bx,2
jb randY
cmp bx,23
ja randY

call calculatePosition	;Calculating position by random x and y positions and store in di

mov word[storeLoc],di	;Saving location of food

exitfood:
mov di,word[storeLoc]
mov ax,0x0703			
mov word [es:di],ax		;Displaying food

jl exitfood2


exitfood2:

pop es
pop di
pop bx
pop ax

ret


;-----------------------------------------------------------------------------------------------------------;
;-----------------------------------Calculating position Subroutine-----------------------------------------;
;-----------------------------------------------------------------------------------------------------------;

    calculatePosition:

push cx
push dx

mov cx,[bp-2] ;y pos
mov ax,80
mul cx
add ax,[bp-4] ;x pos
shl ax,1

mov di,ax

pop dx
pop cx

ret


;-----------------------------------------------------------------------------------------------------------;
;--------------------------------------MakingBorder Subroutine----------------------------------------------;
;-----------------------------------------------------------------------------------------------------------;

    MakeBorder:

push es
push ax
push cx 
push di 

mov ax,0xb800 
mov es, ax

mov al,byte[Border]
mov ah,0x07

mov di,0
mov cx,80
L1:
mov [es:di],ax
add di,2
loop L1

mov di,3840
mov cx,80
L2:
mov [es:di],ax
add di,2
loop L2

mov di,160
mov cx,23
L3:
mov [es:di], ax 
add di, 158
mov [es:di], ax 
add di, 2
loop L3

pop di 
pop cx 
pop ax 
pop es 

ret


;-----------------------------------------------------------------------------------------------------------;
;---------------------------------Main Subroutine to play the Game------------------------------------------;
;-----------------------------------------------------------------------------------------------------------;

    SnakeGame:

;pushing all values
push bp
mov bp ,sp
sub sp,4
push di
push es
push ax
push bx
push dx

call printFood

;call draw_snake
mov bx, Snakeloccs
push bx
call printSnake

mov bx,ax
mov ax,160

mul cx
add word[SnakeLoc],ax

moving: 	;for next move

mov cx,word[SnakeLen]	;snake length

call MakeBorder
call ScoreDisp

mov bx,ax
mov ax,160

mul cx
add word[SnakeLoc],ax

cmp word[SnakeLoc],4000
jl conti

sub word[SnakeLoc],ax
mov ax,bx

mov byte[Touched],1

mov dx,2000


conti:

call MoveSnake
call MakeBorder
call ScoreDisp

dec dx
jnz conti


pop dx
pop bx
pop ax
pop es
pop di
mov sp, bp
pop bp

ret 4

;------------------------------------------------------------------------------------------------------------;
;------------------------------------------------START-------------------------------------------------------;
;------------------------------------------------------------------------------------------------------------;

    start:

call clearscreen

call DisplayIntro

mov ah, 0
int 0x16
	
call clearscreen

call DisplayMenu

mov ah, 0
int 0x16

call clearscreen ;previous output clearing

push 3
push 3


call SnakeGame

mov ah, 0
int 0x16

mov ax,0x4c00
int 0x21

Snakeloccs	: dw 0