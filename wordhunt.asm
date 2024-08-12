[org 0x0100]

jmp start

;words to find
l1: db 'tree', 0
l2: db 'tide', 0

l3: db 'hide', 0
l4: db 'meow', 0

;for input
string: db 'demo', 0 
overwrite: db '****', 0

;to print on game screen
exit_msg: db 'EXITED!', 0
score_msg: db 'Score :', 0
live_msg: db 'Lives: ', 0
game_Title: db 'WORD HUNT', 0
esc_msg: db 'Press ESC to Exit', 0
input_msg: db 'Enter your Word: ', 0
level_msg: db 'Level: ', 0
loading_msg: db 'Loading...', 0
loading_msg2: db 'Next Level', 0

found: db 'found!    ', 0
not_found: db 'not found!', 0

main_Title: db 'Press Any Key to Start! ', 0

;score and lives count
score: dw 0
lives: dw 3
level: dw 1
runs: dw 2

;Main screen rectangle
message: db ' '
length: dw 1

left: dw 20
right: dw 59
top: dw 7
bottom: dw 15

;letters for grid
p1: db 't         i          d         e', 0
p2: db 't         r          s         t', 0
p3: db 'l         u          e         s', 0
p4: db 'j         u          n         e', 0

;letters for grid
q1: db 'y         w          f         e', 0
q2: db 'h         i          d         e', 0
q3: db 'l         u          j         s', 0
q4: db 'm         e          o         w', 0


;MAIN
start:
	 call clrscr
	 
	 call main_Screen
	 call main_rect
	 
	 mov ah, 0
	 int 0x16
	 
	 ; Level 1
	 call clrscr
	 
	 call print_Words1
	 call print_GRID
	 call scoreBoard
	 call game_Heading
	 call print_lives
	 call print_level
	 call game_screen
	 
	 call input
	 
	 ; Level 2
	 call clrscr
	 
	 
fin:
	 mov ax, 0x4c00
	 int 0x21


;take input
input:
	 push ax
	 push cx
	 push dx
	 push di

	 mov dx, 1
	 
	again:	 
		 mov ah, 01h
		 xor di, di

		 int 21h
		 cmp al, 27
		 je exit3 
		 
		 mov [string + di], al
		 inc di
		 
		 int 21h
		 cmp al, 27
		 je exit3 
		 
		 mov [string + di], al
		 inc di
		 
		 int 21h
		 cmp al, 27
		 je exit3 
		 
		 mov [string + di], al
		 inc di
		 
		 int 21h
		 cmp al, 27
		 je exit3 
		 
		 mov [string + di], al
		 
		 ;wait for key press
		 mov ah, 0
		 int 0x16
		
		
		 push ds ; push segment of first string 
		 mov ax,  l1
		 push ax ; push offset of first string 
		 
		 push ds ; push segment of first string 
		 mov ax,  l2
		 push ax ; push offset of first string 
		 
		 push ds ; push segment of first string 
		 mov ax,  l3
		 push ax ; push offset of first string 
		 
		 push ds ; push segment of first string 
		 mov ax,  l4
		 push ax ; push offset of first string 
		 
		 push ds ; push segment of second string 
		 mov ax, string 
		 push ax ; push offset of second string 
		 
		 call strcmp 
		 
		 mov ax, [lives]
		 cmp ax, 0
		 je exit3
		 
		 mov ax, [runs]
		 cmp ax, 0
		 jne again
		 
		 mov ax, 2
		 cmp ax, dx 
		 je exit3
		 
	next_level:
	 inc dx
	 
	 mov ax, 2
	 mov [runs], ax	 
			 
	 mov ax, [level]
	 inc ax
	 mov [level], ax
	
	 call delay
	 call clrscr
	 call loading_screen
	 call delay
	 call clrscr
	 
	 call print_Words2
	 call print_GRID
	 call scoreBoard
	 call game_Heading
	 call print_lives
	 call print_level
	 call game_screen
	 
	 jmp again
	
	
	exit3:
		 mov ax, 3 
		 push ax ; push x position 
		 mov ax, 7 
		 push ax ; push y position 
		 mov ax, 0x02 ; blue on black attribute 
		 push ax ; push attribute 
		 mov ax, exit_msg
		 push ax ; push address of message 
		 
		 call printstr
		 
		 int 20h
		 
		 pop di
		 pop dx
		 pop cx
		 pop ax
		 ret


;search for string
strcmp: 
	 push bp 
	 mov bp,sp 
	 push cx 
	 push si 
	 push di 
	 push es 
	 push ds 
	 
	 next1:
		 lds si, [bp+4] ; point ds:si to first string 
		 les di, [bp+20] ; point es:di to second string 
		 
		 push ds ; push segment of first string 
		 push si ; push offset of first string 
		 call strlen ; calculate string length 
		 mov cx, ax ; save length in cx 
		 
		 push es ; push segment of second string 
		 push di ; push offset of second string 
		 call strlen ; calculate string length
		 
		 cmp cx, ax ; compare length of both strings 
		 jne next2 ; return 0 if they are unequal 

		 repe cmpsb ; compare both strings 
		 jcxz es1 ; are they successfully compared

	 next2:
		 lds si, [bp+4] ; point ds:si to first string 
		 les di, [bp+16] ; point es:di to second string 
		 
		 push ds ; push segment of first string 
		 push si ; push offset of first string 
		 call strlen ; calculate string length 
		 mov cx, ax ; save length in cx 
		 
		 push es ; push segment of second string 
		 push di ; push offset of second string 
		 call strlen ; calculate string length
		 
		 cmp cx, ax ; compare length of both strings 
		 jne next3 ; return 0 if they are unequal 
		 
		 repe cmpsb ; compare both strings 
		 jcxz es2 ; are they successfully compared	 

	 next3:
		 lds si, [bp+4] ; point ds:si to first string 
		 les di, [bp+12] ; point es:di to second string 
		 
		 push ds ; push segment of first string 
		 push si ; push offset of first string 
		 call strlen ; calculate string length 
		 mov cx, ax ; save length in cx 
		 
		 push es ; push segment of second string 
		 push di ; push offset of second string 
		 call strlen ; calculate string length
		 
		 cmp cx, ax ; compare length of both strings 
		 jne next4 ; return 0 if they are unequal 
		 
		 repe cmpsb ; compare both strings 
		 jcxz es3 ; are they successfully compared

	 next4:
		 lds si, [bp+4] ; point ds:si to first string 
		 les di, [bp+8] ; point es:di to second string 
		 
		 push ds ; push segment of first string 
		 push si ; push offset of first string 
		 call strlen ; calculate string length 
		 mov cx, ax ; save length in cx 
		 
		 push es ; push segment of second string 
		 push di ; push offset of second string 
		 call strlen ; calculate string length
		 
		 cmp cx, ax ; compare length of both strings 
		 jne exitfalse ; return 0 if they are unequal 
		 
		 repe cmpsb ; compare both strings 
		 jcxz es4 ; are they successfully compared
	 
	exitfalse:
		 mov ax, 3 
		 push ax ; push x position 
		 mov ax, 6 
		 push ax ; push y position 
		 mov ax, 2 ; blue on black attribute 
		 push ax ; push attribute 
		 mov ax, not_found 
		 push ax ; push address of message 
		 
		 call printstr 
		 
		 mov ax, [lives]
		 dec ax
		 mov [lives], ax
		 
		 call print_lives
		 
		 jmp exit2
		 
	es1:
		 mov ax, [overwrite]
		 mov [l1], ax
		 call printAns1
		 jmp exitsimple
		 
	es2:
		 mov ax, [overwrite]
		 mov [l2], ax
		 call printAns2
		 jmp exitsimple
		 
	es3:
		 mov ax, [overwrite]
		 mov [l3], ax
		 call printAns3
		 jmp exitsimple
		 
	es4:
		 mov ax, [overwrite]
		 mov [l4], ax
		 call printAns4
		 jmp exitsimple
		

	exitsimple:
		 mov ax, [score]
		 add ax, 10
		 mov [score], ax
		 call scoreBoard
		 
		 mov ax, [runs]
		 dec ax
		 mov [runs], ax
		 
		 mov ax, 3 
		 push ax ; push x position 
		 mov ax, 6 
		 push ax ; push y position 
		 mov ax, 2 ; blue on black attribute 
		 push ax ; push attribute 
		 mov ax, found 
		 push ax ; push address of message
		 
		 call printstr 
	
	exit2:
	 pop ds 
	 pop es 
	 pop di 
	 pop si 
	 pop cx 
	 pop bp 
	 ret 10 


main_Screen:
	 push es 
	 push ax 
	 push cx 
	 push di 
	 
	 mov ax, 0xb800 
	 mov es, ax ; point es to video base 
	 
	 xor di, di ; point di to top left column 
	 
	 mov ax, 0x2020 ; space char in normal attribute 
	 mov cx, 2000 ; number of screen locations 
	 
	 cld ; auto increment mode 
	 rep stosw ; clear the whole screen 
	 
	 mov ax, 35 
	 push ax ; push x position 
	 mov ax, 10 
	 push ax ; push y position 
	 mov ax, 0x20 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, game_Title
	 push ax ; push address of message 
	 
	 call printstr
	 
	 mov ax, 28 
	 push ax ; push x position 
	 mov ax, 12 
	 push ax ; push y position 
	 mov ax, 0xA0 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, main_Title
	 push ax ; push address of message 
	 call printstr
	 
	 pop di  
	 pop cx 
	 pop ax 
	 pop es 
	 ret 
	 

;print score
scoreBoard:
     mov ax, 3 
	 push ax ; push x position 
	 mov ax, 4 
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, score_msg 
	 push ax ; push address of message 
	 
	 call printstr 
	 
     mov ax, 12 
	 push ax ; push x position 
	 mov ax, 4 
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, [score]
	 push ax ; push address of message 
	 
	 call printnum  
	 
	 ret


;print Game Title
game_Heading:
     mov ax, 3 
	 push ax ; push x position 
	 mov ax, 2 
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, game_Title
	 push ax ; push address of message 
	 
	 call printstr 
 
	 ret
	 

; print message for user	 
game_screen:
	 mov ax, 0 
	 push ax ; push x position 
	 mov ax, 20 
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, input_msg
	 push ax ; push address of message 
	 
	 call printstr

	 mov ax, 60 
	 push ax ; push x position 
	 mov ax, 0 
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, esc_msg
	 push ax ; push address of message 
	 
	 call printstr	 
	 
	 mov ax, 25 
	 push ax ; push x position 
	 mov ax, 2 
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, live_msg
	 push ax ; push address of message 
	 
	 call printstr
 
	 ret
	 
	 
print_lives:
	 mov ax, 32 
	 push ax ; push x position 
	 mov ax, 2 
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, [lives]
	 push ax ; push address of message 
	 
	 call printnum
	 
	 ret
	 

print_level:
	 mov ax, 72 
	 push ax ; push x position 
	 mov ax, 24 
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, level_msg
	 push ax ; push address of message 
	 
	 call printstr

	 mov ax, 79 
	 push ax ; push x position 
	 mov ax, 24 
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, [level]
	 push ax ; push address of message 
	 
	 call printnum
	 
	 ret

	 
;print Words in grid
print_Words1:
     mov ax, 30 
	 push ax ; push x position 
	 mov ax, 5  
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, p1 
	 push ax ; push address of message 
	 
	 call printstr 
	 
     mov ax, 30 
	 push ax ; push x position 
	 mov ax, 10  
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, p2 
	 push ax ; push address of message 
	 
	 call printstr 

     mov ax, 30 
	 push ax ; push x position 
	 mov ax, 15  
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, p3 
	 push ax ; push address of message 
	 
	 call printstr 
	 
     mov ax, 30 
	 push ax ; push x position 
	 mov ax, 20  
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, p4 
	 push ax ; push address of message 
	 
	 call printstr 
	 
	 ret
	 

print_Words2:
     mov ax, 30 
	 push ax ; push x position 
	 mov ax, 5  
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, q1 
	 push ax ; push address of message 
	 
	 call printstr 
	 
     mov ax, 30 
	 push ax ; push x position 
	 mov ax, 10  
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, q2 
	 push ax ; push address of message 
	 
	 call printstr 

     mov ax, 30 
	 push ax ; push x position 
	 mov ax, 15  
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, q3 
	 push ax ; push address of message 
	 
	 call printstr 
	 
     mov ax, 30 
	 push ax ; push x position 
	 mov ax, 20  
	 push ax ; push y position 
	 mov ax, 2 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, q4 
	 push ax ; push address of message 
	 
	 call printstr 
	 
	 ret
	 
	 
loading_screen:
	 push es 
	 push ax 
	 push cx 
	 push di 
	 
	 mov ax, 0xb800 
	 mov es, ax ; point es to video base 
	 
	 xor di, di ; point di to top left column 
	 
	 mov ax, 0x2020 ; space char in normal attribute 
	 mov cx, 2000 ; number of screen locations 
	 
	 cld ; auto increment mode 
	 rep stosw ; clear the whole screen 
	 
	 mov ax, 35 
	 push ax ; push x position 
	 mov ax, 10 
	 push ax ; push y position 
	 mov ax, 0x20 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, loading_msg
	 push ax ; push address of message 
	 
	 call printstr
	 
	 mov ax, 35 
	 push ax ; push x position 
	 mov ax, 12 
	 push ax ; push y position 
	 mov ax, 0x20 ; blue on black attribute 
	 push ax ; push attribute 
	 mov ax, loading_msg2
	 push ax ; push address of message 
	 
	 call printstr
	 
	 pop di  
	 pop cx 
	 pop ax 
	 pop es 
	 ret 
	 
	 
strlen:    
	 push bp
 	 mov bp, sp
	 push es
	 push cx
	 push di

	 les di, [bp + 4]
	 mov cx, 0xffff
	 xor al, al
	 repne scasb
	 mov ax, 0xffff
	 sub ax, cx
	 dec ax

	 pop di
	 pop cx
	 pop es
	 pop bp
	 ret 4
	 
	 
printstr: 
	 push bp 
	 mov bp, sp 
	 push es 
	 push ax 
	 push cx 
	 push si 
	 push di 
	 push ds ; push segment of string 
	 
	 mov ax, [bp+4] 
	 push ax ; push offset of string 
	 call strlen ; calculate string length  
	 cmp ax, 0 ; is the string empty 
	 jz exit ; no printing if string is empty
	 mov cx, ax ; save length in cx 
	 
	 mov ax, 0xb800 
	 mov es, ax ; point es to video base 
	 
	 mov al, 80 ; load al with columns per row 
	 mul byte [bp+8] ; multiply with y position 
	 add ax, [bp+10] ; add x position 
	 shl ax, 1 ; turn into byte offset 
	 mov di,ax ; point di to required location 
	 
	 mov si, [bp+4] ; point si to string 
	 mov ah, [bp+6] ; load attribute in ah 
	 
	 cld ; auto increment mode 
	 
	nextchar: 
		 lodsb ; load next char in al 
		 stosw ; print char/attribute pair 
		 loop nextchar ; repeat for the whole string 
	 
	exit: 
		 pop di 
		 pop si 
		 pop cx 
		 pop ax 
		 pop es 
		 pop bp 
		 ret 8  
	 
	 
;clear screen
clrscr: 
	 push es 
	 push ax 
	 push cx 
	 push di 
	 
	 mov ax, 0xb800 
	 mov es, ax ; point es to video base 
	 
	 xor di, di ; point di to top left column 
	 
	 mov ax, 0x0720 ; space char in normal attribute 
	 mov cx, 2000 ; number of screen locations 
	 
	 cld ; auto increment mode 
	 rep stosw ; clear the whole screen 
	 
	 pop di  
	 pop cx 
	 pop ax 
	 pop es 
	 ret
	 

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
	 mov es, ax ; point es to video base 
	 
	 mov ax, [bp+4] ; load number in ax 
	 mov bx, 10 ; use base 10 for division 
	 mov cx, 0 ; initialize count of digits 
	 
	nextdigit: 
		 mov dx, 0 ; zero upper half of dividend 
		 div bx ; divide by 10 
		 add dl, 0x30 ; convert digit into ascii value 
		 push dx ; save ascii value on stack 
		 inc cx ; increment count of values 
		 cmp ax, 0 ; is the quotient zero 
		 jnz nextdigit ; if no divide it again 
		 
		 mov al, 80 ; load al with columns per row 
		 mul byte [bp+8] ; multiply with y position 
		 add ax, [bp+10] ; add x position 
		 shl ax, 1 ; turn into byte offset 
		 mov di, ax ; point di to required location  
 
	nextpos: 
		 pop dx ; remove a digit from the stack 
		 mov dh, [bp+6] ; use normal attribute 
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
	 ret 8 
	 
	 
print_mainScreen_rect:
	 
	 
; Print GRID	
print_GRID:
	  push bp
	  mov bp, sp
	  push es
	  push ax
	  push bx
	  push cx
	  push dx
	  push si
	  push di
	  
	  mov ax, 0xb800
	  mov es, ax
	  
	 ; vertical left 
	  mov bl, 3 ;y
	  mov dx, 25 ;x
	  mov cx, 21
	  
	line1:  
	  mov al, 80
	  mul bl
	  add ax, dx
	  shl ax, 1
	  mov di, ax
	  
	  mov al, 0x20
	  mov ah, 0x70

	  mov [es:di], ax
	  inc bl
	  
	  loop line1
	  
	  
	 ; vertical right
	  mov bl, 3 ;y
	  mov dx, 56 ;x
	  mov cx, 21
	  
	line2: 
	  mov al, 80
	  mul bl
	  add ax, dx
	  shl ax, 1
	  mov di, ax
	  
	  mov al, 0x20
	  mov ah, 0x70

	  mov [es:di], ax
	  inc bl
	  
	  loop line2
	  
	  
	  ; horizontal up 
	  mov bl, 3 ;y
	  mov dx, 26 ;x
	  mov cx, 40
	  
	line3: 
	  mov al, 80
	  mul bl
	  add ax, dx
	  shl ax, 1
	  mov di, ax
	  
	  mov al, 0x20
	  mov ah, 0x70

	  mov [es:di], ax
	  inc dx
	  
	  loop line3
	  
	  
	  ; horizontal down
	  mov bl, 23 ;y
	  mov dx, 26 ;x
	  mov cx, 40
	    
	line4:  
	  mov al, 80
	  mul bl
	  add ax, dx
	  shl ax, 1
	  mov di, ax
	  
	  mov al, 0x20
	  mov ah, 0x70

	  mov [es:di], ax
	  inc dx
	  
	  loop line4
	  
	  
	  ; vertical  inside left	  
	  mov bl, 4 ;y
	  mov dx, 35 ;x
	  mov cx, 19
	  
	line5:  
	  mov al, 80
	  mul bl
	  add ax, dx
	  shl ax, 1
	  mov di, ax
	  
	  mov al, 0x20
	  mov ah, 0x70

	  mov [es:di], ax
	  inc bl
	  
	  loop line5
	  
	  
	  ; vertical inside right
	  mov bl, 4 ;y
	  mov dx, 46 ;x
	  mov cx, 19
	  
	line6: 
	  mov al, 80
	  mul bl
	  add ax, dx
	  shl ax, 1
	  mov di, ax
	  
	  mov al, 0x20
	  mov ah, 0x70

	  mov [es:di], ax
	  inc bl
	  
	  loop line6
	  
	  
	  ; horizontal inside up
	  mov bl, 13 ;y
	  mov dx, 26 ;x
	  mov cx, 40
	  
	line7:
	  mov al, 80
	  mul bl
	  add ax, dx
	  shl ax, 1
	  mov di, ax
	  
	  mov al, 0x20
	  mov ah, 0x70

	  mov [es:di], ax
	  inc dx
	  
	  loop line7
	  
	  
	  ; horizontal inside down
	  mov bl, 18 ;y
	  mov dx, 26 ;x
	  mov cx, 40
	  
	line8: 
	  mov al, 80
	  mul bl
	  add ax, dx
	  shl ax, 1
	  mov di, ax
	  
	  mov al, 0x20
	  mov ah, 0x70

	  mov [es:di], ax
	  inc dx
	  
	  loop line8 
	  
	  
	  ; horizontal up 
	  mov bl, 8 ;y
	  mov dx, 26 ;x
	  mov cx, 40
	  
	line9: 
	  mov al, 80
	  mul bl
	  add ax, dx
	  shl ax, 1
	  mov di, ax
	  
	  mov al, 0x20
	  mov ah, 0x70

	  mov [es:di], ax
	  inc dx
	  
	  loop line9
	  
	 ; vertical right
	  mov bl, 3 ;y
	  mov dx, 65 ;x
	  mov cx, 21
	  
	line10: 
	  mov al, 80
	  mul bl
	  add ax, dx
	  shl ax, 1
	  mov di, ax
	  
	  mov al, 0x20
	  mov ah, 0x70

	  mov [es:di], ax
	  inc bl
	  
	  loop line10	  
	  
	  ;exit
	  pop di
	  pop si
	  pop dx
	  pop cx
	  pop bx
	  pop ax
	  pop es
	  pop bp
	  
	  ret 
	  

rectHor:    push bp
            mov bp, sp
            push es
            push ax
            push cx
            push si
            push di
            push dx

            mov ax, 0xb800
            mov es, ax
            mov al, 80
            mul byte [bp+10]
            add ax, [bp+12]
            shl ax, 1
            mov di, ax
            mov si, [bp+6]
            mov cx, [bp+4]
            mov ah, [bp+8]
            mov dx, [bp+14]

nextHor:    mov al, [si]
            mov [es:di], ax
            add di,2
            add si,1
            loop nextHor

            mov si, [bp+6]
            mov cx, [bp+4]
            sub dx,1
            cmp dx,0
            jne nextHor

            pop dx
            pop di
            pop si
            pop cx
            pop ax
            pop es
            pop bp
            ret 12

rectVer:    push bp
            mov bp, sp
            push es
            push ax
            push cx
            push si
            push di
            push dx

            mov ax, 0xb800
            mov es, ax
            mov al, 80
            mul byte [bp+10]
            add ax, [bp+12]
            shl ax, 1
            mov di, ax
            mov si, [bp+6]
            mov cx, [bp+4]
            mov ah, [bp+8]
            mov dx, [bp+14]

nextVer:    mov al, [si]
            mov [es:di], ax
            add di,2
            add si,1
            loop nextVer

            add di, 158
            mov si, [bp+6]
            mov cx, [bp+4]
            sub dx, 1
            cmp dx,0
            jne nextVer

            pop dx
            pop di
            pop si
            pop cx
            pop ax
            pop es
            pop bp
            ret 12


main_rect:
	 mov ax, [right]
	 mov bx, [left]
	 sub ax, bx
	 push ax
	 mov ax, [left]
	 push ax
	 mov ax, [top]
	 push ax
	 mov ax, 0x07
	 push ax
	 mov ax, message
	 push ax
	 push word [length]
	 call rectHor

	 mov ax, [bottom]
	 mov bx, [top]
	 sub ax, bx
	 push ax
	 mov ax, [left]
	 push ax
	 mov ax, [top]
 	 push ax
	 mov ax, 0x07
 	 push ax
	 mov ax, message
	 push ax
	 push word [length]
	 call rectVer

	 mov ax, [bottom]
	 mov bx, [top]
	 sub ax, bx
	 push ax
	 mov ax, [right]
	 sub ax,1
	 push ax
	 mov ax, [top]
	 push ax
	 mov ax, 0x07
	 push ax
	 mov ax, message
	 push ax
	 push word [length]
	 call rectVer

	 mov ax, [right]
	 mov bx, [left]
	 sub ax, bx
	 push ax
	 mov ax, [left]
	 push ax
	 mov ax, [bottom]
	 push ax
 	 mov ax, 0x07
	 push ax
	 mov ax, message
	 push ax
	 push word [length]
	 call rectHor	
	
	 ret
	 
delay:
	push cx
	mov cx, 0x60
	
	delay_loop1:
		push cx
		mov cx, 0xFFFF
	
		delay_loop2:
			loop delay_loop2
			
			pop cx
		
	loop delay_loop1
	
	pop cx
	ret


printAns1:	push es
			push ax
			push di
			mov ax, 0xb800
			mov es, ax
			mov di, 860
			mov word [es:di], 0x8474
			add di, 820
			mov word [es:di], 0x8472
			add di, 822
			mov word [es:di], 0x8465
			add di, 820
			mov word [es:di], 0x8465
			pop di
			pop ax
			pop es
			ret


printAns2:	push es
			push ax
			push di
			mov ax, 0xb800
			mov es, ax
			mov di, 860
			mov word [es:di], 0x8474
			add di, 20
			mov word [es:di], 0x8469
			add di, 22
			mov word [es:di], 0x8464
			add di, 20
			mov word [es:di], 0x8465
			pop di
			pop ax
			pop es
			ret


printAns3:	push es
			push ax
			push di
			mov ax, 0xb800
			mov es, ax
			mov di, 1660
			mov word [es:di], 0x8468
			add di, 20
			mov word [es:di], 0x8469
			add di, 22
			mov word [es:di], 0x8464
			add di, 20
			mov word [es:di], 0x8465
			pop di
			pop ax
			pop es
			ret


printAns4:	push es
			push ax
			push di
			mov ax, 0xb800
			mov es, ax
			mov di, 3260
			mov word [es:di], 0x846D
			add di, 20
			mov word [es:di], 0x8465
			add di, 22
			mov word [es:di], 0x846F
			add di, 20
			mov word [es:di], 0x8477
			pop di
			pop ax
			pop es
			ret		