

; Description: Matrix Rain
; 
; Start date: 2/13/2015
;Revision date: 4/14/2015

INCLUDE Irvine32.inc
INCLUDE Macros.inc
.data

;Array Variables
yArray byte 30 DUP(0)				;Y coordinate array
xArray byte 30 DUP(?)                   ;X coordinate array
rainArray byte 30 DUP(?)                ;Char array for falling pieces


;Title Variable
titleStr byte "Matrix Rain",0				;Title on the title bar for the window

;X / Death Proc Variables
beginX byte 23                          ;Beginning X coordinate for player character
beginY byte 23						;Beginning Y coordinate for player character
deathMessage byte "You were hit!...",0  ;Message for being hit
replay byte "Play Again? (Y/N)",0       ;Question if player would like to try again
response byte 0; Response to yes or no for replay
count dword 0
items dword ?		;count for number of items wanted to fall

;Way for program to tell if it's in the secret level
S byte 0

;Level Names
Lvl1 byte "Level 1",0
Lvl2 byte "Level 2",0
Lvl3 byte "Level 3",0
Lvl4 byte "Level 4",0
Lvl5 byte "Level 5",0
Secret byte "Secret Level",0

;congratulations

Lvl1C byte "Congratulations! You've Completed Level 1!", 0
Lvl2C byte "Congratulations! You've Completed Level 2!", 0
Lvl3C byte "Congratulations! You've Completed Level 3!", 0
Lvl4C byte "Congratulations! You've Completed Level 4!", 0
Lvl5C byte "Congratulations! You've Completed The Game!!", 0
SecretCode byte "Press '*' at the title screen to get to the Secret Level"

Matrix byte "Matrix Rain",0
pressS byte "To start the game press S", 0 




;Window Sizing Variables
outHandle Handle 0            ;Allows us to change the window size
WindowRect Small_Rect <0,0,45,24>;Left, top, right, and bottom bounds for window size

.code

main PROC
	   ;Window Manipulation area
	   INVOKE GetStdHandle,STD_OUTPUT_HANDLE
	   mov outHandle,eax
	   INVOKE SetConsoleWindowInfo,outHandle,TRUE,ADDR WindowRect  ;Set console window to coordinates of Size variable
	   INVOKE SetConsoleTitle, ADDR titleStr	;calls the title
	   mov eax,green + (black * 16);Green Text, black background
	   call SetTextColor      ;Sets the color
	   XOR eax,eax            ;clear eax
	   ;End Window Manipulation area

Title1:
	   call clrscr ; Wipes screen for fresh start
	   xor eax,eax

	   ;Title Screen

	   mov dh, 12
	   mov dl, 18
	   call gotoxy
	   mov edx,offset Matrix
	   call WriteString


	    mov dh, 22
	   mov dl, 0
	   call gotoxy
	   mov edx,offset pressS
	   call WriteString

	   mov dh, 24
	   mov dl, 45
	   call gotoxy
	   
	   ;End Title Screen

StartGame:
	   mov S,0		;make sure all procs know they aren't in the secret level		   

	   call ReadKey
	   mov response, al
	   Or response, 00100000B ; bitmask for lowercase conversion
	   cmp response, '*'
	   je SecretLevelStart
	   cmp response, 's'
	   je Level1Start
	   jmp StartGame
	   
	   
Level1Start:  
	   mov response, 0
	   call clrscr
	   
	   mov dh, 12
	   mov dl, 20
	   call gotoxy
	   mov edx,offset Lvl1
	   call WriteString
	   mov eax,1500
	   call delay
	   call clrscr

	   ; Level 1 code area
	   push 5		;Push number of falling items
	   call newNum      ;fills 5 items in rainArray with either a char 1 or char 0 for printing purposes. 
	   add esp,4
	  
	   push 5
	   push offset xArray
	   push 47
	   call FillArray ; Populates the xArray with 5 X coordinates from 0 to 46
	   add esp,12
	  
	   call Startposition
	   
	   call Level1
	   ; End of Level 1 code area
	   call clrscr
	   
	   mov dh, 12
	   mov dl, 2
	   call gotoxy
	   mov edx,offset Lvl1C
	   call WriteString
	   mov eax,2000
	   call delay
	  
Level2Start:
	   call clrscr


	   call RefreshY
	   mov dh, 12
	   mov dl, 20
	   call gotoxy
	   mov edx,offset Lvl2
	   call WriteString
	   mov eax,1500
	   call delay
	   call clrscr

	   	   ; Level 2 code area
	   push 7		;Push number of falling items
	   call newNum      ;fills 7 items in rainArray with either a char 1 or char 0 for printing purposes. 
	   add esp,4
	  
	   push 7
	   push offset xArray
	   push 47
	   call FillArray ; Populates the xArray with 7 X coordinates from 0 to 46
	   add esp,12
	  
	   call Startposition
	   
	   call Level2

	   
	   call clrscr

	   mov dh, 12
	   mov dl, 2
	   call gotoxy
	   mov edx,offset Lvl2C
	   call WriteString
	   mov eax,2000
	   call delay
Level3Start:

	   call clrscr

	   call RefreshY
	   mov dh, 12
	   mov dl, 20
	   call gotoxy
	   mov edx,offset Lvl3
	   call WriteString
	   mov eax,1500
	   call delay
	   call clrscr

	   	   ; Level 3 code area
	   push 9		;Push number of falling items
	   call newNum      ;fills 9 items in rainArray with either a char 1 or char 0 for printing purposes. 
	   add esp,4
	  
	   push 9
	   push offset xArray
	   push 47
	   call FillArray ; Populates the xArray with 9 X coordinates from 0 to 46
	   add esp,12
	  
	   call Startposition
	   
	   call Level3

	   ; End of Level 3 code area
	   call clrscr

	   mov dh, 12
	   mov dl, 2
	   call gotoxy
	   mov edx,offset Lvl3C
	   call WriteString
	   mov eax,2000
	   call delay
Level4Start:
	   call clrscr

	   call RefreshY
	   mov dh, 12
	   mov dl, 20
	   call gotoxy
	   mov edx,offset Lvl4
	   call WriteString
	   mov eax,1500
	   call delay
	   call clrscr

	   	   ; Level 4 code area
	   push 12		;Push number of falling items
	   call newNum      ;fills 12 items in rainArray with either a char 1 or char 0 for printing purposes. 
	   add esp,4
	  
	   push 12
	   push offset xArray
	   push 47
	   call FillArray ; Populates the xArray with 12 X coordinates from 0 to 47
	   add esp,12
	  
	   call Startposition
	   
	   call Level4

	   ; End of Level 4 code area
	   call clrscr

	   mov dh, 12
	   mov dl, 2
	   call gotoxy
	   mov edx,offset Lvl4C
	   call WriteString
	   mov eax,2000
	   call delay
	   
Level5Start:
	   call clrscr

	   call RefreshY
	   mov dh, 12
	   mov dl, 20
	   call gotoxy
	   mov edx,offset Lvl5
	   call WriteString
	   mov eax,1000
	   call delay
	   call clrscr

	   	   ; Level 5 code area
	   push 15		;Push number of falling items
	   call newNum      ;fills 15 items in rainArray with either a char 1 or char 0 for printing purposes. 
	   add esp,4
	  
	   push 15
	   push offset xArray
	   push 47
	   call FillArray ; Populates the xArray with 15 X coordinates from 0 to 46
	   add esp,12
	  
	   call Startposition
	   
	   call Level5

	   ; End of Level 5 code area
	   
	   jmp EndSecretLevel		;only goes to secret level if password is entered at the beginning
SecretLevelStart:
	   call clrscr

	   mov S,1				;set S to 1 for check for secret level in other procs

	   call RefreshY
	   mov dh, 12
	   mov dl, 20
	   call gotoxy
	   mov edx,offset Secret
	   call WriteString
	   mov eax,1000
	   call delay
	   call clrscr

	   	   ; Secret level code area
	   push 30		;Push number of falling items
	   call newNum      ;fills 15 items in rainArray with either a char 1 or char 0 for printing purposes. 
	   add esp,4
	  
	   push 30
	   push offset xArray
	   push 47
	   call FillArray ; Populates the xArray with 15 X coordinates from 0 to 46
	   add esp,12
	  
	   call Startposition
	   
	   call SecretLevel

	   ; End of Secret level code area
EndSecretLevel:

	   call clrscr

	   mov dh, 12
	   mov dl, 0
	   call gotoxy
	   mov edx,offset Lvl5C
	   call WriteString
	   
	   call crlf
	   mov edx,offset SecretCode
	   call WriteString

	   mov dh, 11
	   mov dl, 24
	   call gotoxy
	   mov al, 1
	   call WriteChar
	   mov eax,2000
	   call delay
	   
	   mov dh , 24
	   mov dl, 0

	   call gotoxy
	   jmp Title1

EndGame:
	   exit
main ENDP

;---------------------------------------------------------------------------------------------------------------------

FillArray proc uses ecx       ; Parameters (Number of elements,Offset Array, Range for numbers) made by John K
	    push ebp             ; Pushing it to access parameters from stack
	    mov ebp, esp
	    call Randomize	       ;Makes RandomRange random based on time of day 
	    mov ecx, [ebp + 20]  ; Moves first parameter that will be the number for the counter

	    mov edi, [ebp + 16]  ; Offset of array put into edi
L1: 
	    cmp ecx ,0           ; Loop for setting entire array with random values
	    je endL1
	    mov eax,[ebp + 12]    ; Range Paramet put into eax
	    call RandomRange
	    cld                  ; Set direction to forward for the array intialization
	    stosb                ; Stores contents of eax into array
	    dec ecx              ; decrements counter
	    jmp L1
endL1:

	    pop ebp              ; restores Ebp
	    
	    ret
FillArray endp

;---------------------------------------------------------------------------------------------------------------------


Reset PROC uses eax ebx 
	mov yArray[esi],0

	mov al, 2
	call RandomRange		;make a random number 0 or 1

	cmp al, 0
	jne L2			   ;if the number is a 1, go to L2
	mov rainArray[esi], '0'; movs char zero into rain
	XOR eax,eax; Clears EAX
	jmp _End
L2:
	mov rainArray[esi], '1';movs char one into rain
	XOR eax,eax
_End:

	mov al,47
	call RandomRange 

	mov xArray[esi],al
	
	ret
Reset ENDP

;---------------------------------------------------------------------------------------------------------------------

fall PROC uses eax ;proc for moving pieces downProc by Kilian	
; Parameter (Int indexOfElement)


		push esi
		mov esi,ebx
All:
		mov al,beginY
		cmp yArray[esi],al
		je  _Reset
		jmp endDeath
_Reset:
		mov al, beginX
	     cmp xArray[esi], al 
		je Death
_Skip:
		cmp S,1
		je Skip
		dec items
Skip:
		call Reset
		jmp EndAll
EndReset:

Death:
		call Death
endDeath:

		inc yArray[esi]		 ;increment y coordinate

		cmp S,1
		je  Move
		jmp EndAll
Move:
		mov al,3
		call RandomRange
		cmp al,1
		jz  No
		je  One 	
		jg  Two
One:
		dec xArray[esi]
		jmp No
Two:
		inc xArray[esi]
		jmp No
No:
		cmp xArray[esi],0
		jl	MoveBack
		cmp xArray[esi],46
		jg	MoveFw
MoveBack:
		dec xArray[esi]
		jmp EndAll
MoveFw:
		inc xArray[esi]

		jmp EndAll
EndAll:	    
		pop esi
		
		ret
fall ENDP;End move proc

;---------------------------------------------------------------------------------------------------------------------

RightIf PROC USES edx;John Proc
		cmp ah , 4Dh
	     je Then1
          jmp endright           ; Jmp to end of proc

Then1: 
		cmp beginX , 46
		je outX
		inc beginX             ; Increments X coordinate value	
outX:
		

		call ReadKeyFlush 
	
endright:
	     
		ret
 RightIf ENDP

 ;---------------------------------------------------------------------------------------------------------------------
 
 LeftIf PROC USES edx;John Proc
		cmp ah, 4Bh
	     je Then2
	     jmp endleft             ; Jmp to end of loop if user put in value that is not 3 or left arrow
Then2:
	     dec beginX              ; Decrements X to move to the left
if6:      
          cmp beginX, 0           ; check if X goes under 0
	     jl then6
	     jmp end6

then6: 
	     mov beginX, 0
end6:

	     call ReadKeyFlush       ;Flushes keyboard input buffer and clears internal counter for faster response time
endleft:
	 
	     ret
 LeftIf ENDP

 ;------------------------------------------------------------------------------------------------------------------------

  UpIf PROC USES edx;John Proc
	     cmp ah, 48h
	     je Then2
	     jmp endUp             ; Jmp to end of loop if user put in value that is not 8 or up arrow
Then2:
	     inc beginY              ; Decrements X to move up
if6:      
          cmp beginY, 0           ; check if X goes under 0
	     jl then6
	     jmp end6

then6: 
	     mov beginY, 0
end6:

	     call ReadKeyFlush       ;Flushes keyboard input buffer and clears internal counter for faster response time
endUp:
	 
	     ret
 UpIf ENDP

 ;------------------------------------------------------------------------------------------------------------------------

  DownIf PROC USES edx;John Proc
	     cmp ah, 50h
	     je Then2
	     jmp endDown             ; Jmp to end of loop if user put in value that is not 4 or down arrow
Then2:
	     inc beginY              ; Decrements X to move down
if6:      
          cmp beginY,24            ; check if X goes under 0
	     jg then6
	     jmp end6

then6: 
	     mov beginY, 24
end6:

	     call ReadKeyFlush       ;Flushes keyboard input buffer and clears internal counter for faster response time
endDown:
	 
	     ret
 DownIf ENDP

 ;------------------------------------------------------------------------------------------------------------------------
 
 StartPosition PROC USES edx;John Proc

		;Player Starting Point
	     mov dh ,beginY            ; column 24
	     mov dl,beginX           ; row 39
	     call Gotoxy             ; places cursor in the middle of the bottom part of the console window
	     mov al,'X'              ; Copies player character to the AL register to be printed
	     call WriteChar          ; Prints player to screen console
	     call crlf
	     ;Player Starting point
	     Xor al, al
	     
		ret
 StartPosition ENDP

;------------------------------------------------------------------------------------------------------------------------


;******* proc to make it easier to reprint the rain;JOHN PROC

Level1 PROC 
		
		mov items,20		
		mov esi,0
		mov count, 0; intilize as zero to reset the print proc

PrintAll: 
				
          mov ecx, count
		mov ebx , 0
		cmp esi,4
		je four
		jmp end4

four:
      mov esi , 4
end4:

inLoop2:
		
		mov dl,xArray[ebx]

		mov dh,yArray[ebx]
		call Gotoxy            ;Moves cursor to the position of rain
		
		
		mov al,rainArray[ebx]
		call WriteChar          ;Rewrite rain

	

		call fall
	

		cmp items,0
		jz  EndPrint

		cmp ecx, 0
		jne decrease
		jmp endD
decrease:
		dec ecx
endD:
		inc ebx

		
	    


		cmp ebx, esi
		ja endinLoop
		jmp inLoop2

endinLoop:
		
		mov eax , 105
		call delay
		call clrscr
		
		mov dh,23d              ;move cursor to character's current position ********* Added to this version by Killian edited by John
		mov dl , beginX
		call Gotoxy
		mov al,'X'              ;move X into al                              *********
		call WriteChar          ;print it					**********
		call Crlf
		xor al,al               ;clear

		push ecx
		call ReadKey
		call Rightif
		call Leftif
		pop ecx

		cmp ecx, 0
		je  random
		mov ebx, 0
		jmp inLoop2
random:
		
		mov eax, 5
		call RandomRange
		mov ebx, eax

		cmp ebx , 0
		je Increase
		jmp PrintAll


Increase:
		cmp esi, 4
		je PrintAll
		inc count
		inc esi 
		jmp PrintAll
EndPrint:
		
		ret
Level1		ENDP

;------------------------------------------------------------------------------------------------


Level2 PROC 
		
		mov items,40		
		mov esi,0
		mov count, 0; intilize as zero to reset the print proc

PrintAll: 
				
          mov ecx, count
		mov ebx , 0
		cmp esi,6
		je four
		jmp end4

four:
      mov esi , 6
end4:

inLoop2:
		
		mov dl,xArray[ebx]

		mov dh,yArray[ebx]
		call Gotoxy            ;Moves cursor to the position of rain
		
		
		mov al,rainArray[ebx]
		call WriteChar          ;Rewrite rain

	

		call fall
	

		cmp items,0
		jz  EndPrint

		cmp ecx, 0
		jne decrease
		jmp endD
decrease:
		dec ecx
endD:
		inc ebx

		
	    


		cmp ebx, esi
		ja endinLoop
		jmp inLoop2

endinLoop:
		
		mov eax , 103
		call delay
		call clrscr
		
		mov dh,23d              ;move cursor to character's current position ********* Added to this version by Killian edited by John
		mov dl , beginX
		call Gotoxy
		mov al,'X'              ;move X into al                              *********
		call WriteChar          ;print it					**********
		call Crlf
		xor al,al               ;clear

		push ecx
		call ReadKey
		call Rightif
		call Leftif
		pop ecx

		cmp ecx, 0
		je  random
		mov ebx, 0
		jmp inLoop2
random:
		
		mov eax, 5
		call RandomRange
		mov ebx, eax

		cmp ebx , 0
		je Increase
		jmp PrintAll


Increase:
		cmp esi, 6
		je PrintAll
		inc count
		inc esi 
		jmp PrintAll
EndPrint:
		
		ret
Level2		ENDP

;-------------------------------------------------------------------------------------

Level3 PROC 
		
		mov items,60		
		mov esi,0
		mov count, 0; intilize as zero to reset the print proc

PrintAll: 
				
          mov ecx, count
		mov ebx , 0
		cmp esi,8
		je four
		jmp end4

four:
      mov esi , 8
end4:

inLoop2:
		
		mov dl,xArray[ebx]

		mov dh,yArray[ebx]
		call Gotoxy            ;Moves cursor to the position of rain
		
		
		mov al,rainArray[ebx]
		call WriteChar          ;Rewrite rain

	

		call fall
	

		cmp items,0
		jz  EndPrint

		cmp ecx, 0
		jne decrease
		jmp endD
decrease:
		dec ecx
endD:
		inc ebx

		

		cmp ebx, esi
		ja endinLoop
		jmp inLoop2

endinLoop:
		
		mov eax , 101
		call delay
		call clrscr
		
		mov dh,23d              ;move cursor to character's current position ********* Added to this version by Killian edited by John
		mov dl , beginX
		call Gotoxy
		mov al,'X'              ;move X into al                              *********
		call WriteChar          ;print it					**********
		call Crlf
		xor al,al               ;clear

		push ecx
		call ReadKey
		call Rightif
		call Leftif
		pop ecx

		cmp ecx, 0
		je  random
		mov ebx, 0
		jmp inLoop2
random:
		
		mov eax, 5
		call RandomRange
		mov ebx, eax

		cmp ebx , 0
		je Increase
		jmp PrintAll


Increase:
		cmp esi, 8
		je PrintAll
		inc count
		inc esi 
		jmp PrintAll
EndPrint:
		
		ret
Level3		ENDP

;----------------------------------------------------------------------------------------------

Level4 PROC 
		
		mov items,80		
		mov esi,0
		mov count, 0; intilize as zero to reset the print proc

PrintAll: 
				
          mov ecx, count
		mov ebx , 0
		cmp esi,11
		je four
		jmp end4

four:
      mov esi , 11
end4:

inLoop2:
		
		mov dl,xArray[ebx]

		mov dh,yArray[ebx]
		call Gotoxy            ;Moves cursor to the position of rain
		
		
		mov al,rainArray[ebx]
		call WriteChar          ;Rewrite rain

	

		call fall
	

		cmp items,0
		jz  EndPrint

		cmp ecx, 0
		jne decrease
		jmp endD
decrease:
		dec ecx
endD:
		inc ebx

		
		cmp ebx, esi
		ja endinLoop
		jmp inLoop2

endinLoop:
		
		mov eax , 99
		call delay
		call clrscr
		
		mov dh,23d              ;move cursor to character's current position ********* Added to this version by Killian edited by John
		mov dl , beginX
		call Gotoxy
		mov al,'X'              ;move X into al                              *********
		call WriteChar          ;print it					**********
		call Crlf
		xor al,al               ;clear

		push ecx
		call ReadKey
		call Rightif
		call Leftif
		pop ecx

		cmp ecx, 0
		je  random
		mov ebx, 0
		jmp inLoop2
random:
		
		mov eax, 5
		call RandomRange
		mov ebx, eax

		cmp ebx , 0
		je Increase
		jmp PrintAll


Increase:
		cmp esi, 11
		je PrintAll
		inc count
		inc esi 
		jmp PrintAll
EndPrint:
		
		ret
Level4		ENDP

;----------------------------------------------------------------------------------------------

Level5 PROC 
		
		mov items,100		
		mov esi,0
		mov count, 0; intilize as zero to reset the print proc

PrintAll: 
				
          mov ecx, count
		mov ebx , 0
		cmp esi,14
		je four
		jmp end4

four:
      mov esi , 14
end4:

inLoop2:
		
		mov dl,xArray[ebx]

		mov dh,yArray[ebx]
		call Gotoxy            ;Moves cursor to the position of rain
		
		
		mov al,rainArray[ebx]
		call WriteChar          ;Rewrite rain

	

		call fall
	

		cmp items,0
		jz  EndPrint

		cmp ecx, 0
		jne decrease
		jmp endD
decrease:
		dec ecx
endD:
		inc ebx

		
		cmp ebx, esi
		ja endinLoop
		jmp inLoop2

endinLoop:
		
		mov eax , 97
		call delay
		call clrscr
		
		mov dh,23d              ;move cursor to character's current position ********* Added to this version by Killian edited by John
		mov dl , beginX
		call Gotoxy
		mov al,'X'              ;move X into al                              *********
		call WriteChar          ;print it					**********
		call Crlf
		xor al,al               ;clear

		push ecx
		call ReadKey
		call Rightif
		call Leftif
		pop ecx

		cmp ecx, 0
		je  random
		mov ebx, 0
		jmp inLoop2
random:
		
		mov eax, 5
		call RandomRange
		mov ebx, eax

		cmp ebx , 0
		je Increase
		jmp PrintAll


Increase:
		cmp esi, 14
		je PrintAll
		inc count
		inc esi 
		jmp PrintAll
EndPrint:
		
		ret
Level5		ENDP


;----------------------------------------------------------------------------------------------------------------------


SecretLevel PROC 
				
		mov esi,0
		mov count, 0; intilize as zero to reset the print proc

PrintAll: 
				
          mov ecx, count
		mov ebx , 0
		cmp esi,29
		je four
		jmp end4

four:
      mov esi , 14
end4:

inLoop2:
		
		mov dl,xArray[ebx]

		mov dh,yArray[ebx]
		call Gotoxy            ;Moves cursor to the position of rain
		
		
		mov al,rainArray[ebx]
		call WriteChar          ;Rewrite rain

	

		call fall
	

		cmp ecx, 0
		jne decrease
		jmp endD
decrease:
		dec ecx
endD:
		inc ebx

		
		cmp ebx, esi
		ja endinLoop
		jmp inLoop2

endinLoop:
		
		mov eax , 97
		call delay
		call clrscr
		
		mov dh,23d              ;move cursor to character's current position ********* Added to this version by Kilian edited by John
		mov dl , beginX
		call Gotoxy
		mov al,'X'              ;move X into al                              *********
		call WriteChar          ;print it					**********
		call Crlf
		xor al,al               ;clear

		push ecx
		call ReadKey
		call Rightif
		call Leftif
		call UpIf
		call DownIf
		pop ecx

		cmp ecx, 0
		je  random
		mov ebx, 0
		jmp inLoop2
random:
		
		mov eax, 5
		call RandomRange
		mov ebx, eax

		cmp ebx , 0
		je Increase
		jmp PrintAll


Increase:
		cmp esi, 29
		je PrintAll
		inc count
		inc esi 
		jmp PrintAll
EndPrint:
		
		ret
SecretLevel		ENDP


;----------------------------------------------------------------------------------------------------------------------


newNum Proc
	push ebp
	mov ebp,esp
	mov ecx,[ebp+8]
	mov esi,0
L1:
	mov al, 2
	call RandomRange

	cmp ecx, 0
	je ENDL
	cmp al, 0
	jne L2
	mov rainArray[esi], '0'; Movs char zero into rain
	XOR eax,eax; Clears EAX
	inc esi
	dec ecx
	jmp L1
L2:
	mov rainArray[esi], '1'
	XOR eax,eax
	inc esi
	dec ecx
	jmp L1
ENDL:
	pop ebp
	ret
newNum endp

;--------------------------------------------------------------------------------------------------------------------------
Death Proc Uses edx eax ; Added by John Descrpition: Checks where the nummber is and if it is above the X char.
	
		call Clrscr
		mov dh, 12
		mov dl, 14
		call Gotoxy             ; Sets cursor to print kill message
		mov edx, offset deathmessage
		call WriteString        ; Displays deathmessage
		call Crlf
		XOR eax,eax             ; clears eax for the yes/no loop

loop1:
		cmp response , 0
		jne answer	
		mov dl,14
		mov dh,13
		call Gotoxy
		mov edx, offset replay
		call WriteString
		call Readchar
		mov S,0
		mov response, al
		jmp loop1

answer:
		Or response, 00100000B ; bitmask for lowercase conversion
		cmp response, 'y'      ; Yes reponse
		je yes

		mov dh, 24
	     mov dl, 0
		call Gotoxy
	
		exit                   ; Exits if al is not 'y'
		
yes:
	  
	   mov response,0
		   
	   call clrscr ; Wipes screen for fresh start
	   xor eax,eax

	   mov dh, 12
	   mov dl, 18
	   call gotoxy
	   mov edx,offset Matrix
	   call WriteString


	    mov dh, 22
	   mov dl, 0
	   call gotoxy
	   mov edx,offset pressS
	   call WriteString

	    mov dh, 24
	   mov dl, 45
	   call gotoxy
	   
StartGame:
	   mov S,0
	   call ReadKey
	   mov response, al
	   Or response, 00100000B ; bitmask for lowercase conversion
	   cmp response,  '*'
	   je SecretLevelStart
	   cmp response, 's'
	   je  SecretLevelStart
	   je Level1Start
	   jmp StartGame
	   
	   
Level1Start: 
	   mov response, 0 
	   call clrscr
	   
	   mov dh, 12
	   mov dl, 20
	   call gotoxy
	   mov edx,offset Lvl1
	   call WriteString
	   mov eax,1500
	   call delay
	   call clrscr

	   ; Level 1 code area
	   push 5		;Push number of falling items
	   call newNum      ;fills 5 items in rainArray with either a char 1 or char 0 for printing purposes. 
	   add esp,4
	  
	   push 5
	   push offset xArray
	   push 45
	   call FillArray ; Populates the xArray with 5 X coordinates from 0 to 44
	   add esp,12
	  
	   call Startposition
	   
	   call Level1
	   ; End of Level 1 code area
	   call clrscr
	   
	   mov dh, 12
	   mov dl, 2
	   call gotoxy
	   mov edx,offset Lvl1C
	   call WriteString
	   mov eax,2000
	   call delay
	  
Level2Start:
	   call clrscr


	   call RefreshY
	   mov dh, 12
	   mov dl, 20
	   call gotoxy
	   mov edx,offset Lvl2
	   call WriteString
	   mov eax,1500
	   call delay
	   call clrscr

	   	   ; Level 2 code area
	   push 7		;Push number of falling items
	   call newNum      ;fills 5 items in rainArray with either a char 1 or char 0 for printing purposes. 
	   add esp,4
	  
	   push 7
	   push offset xArray
	   push 45
	   call FillArray ; Populates the xArray with 5 X coordinates from 0 to 44
	   add esp,12
	  
	   call Startposition
	   
	   call Level2

	   
	   call clrscr

	   mov dh, 12
	   mov dl, 2
	   call gotoxy
	   mov edx,offset Lvl2C
	   call WriteString
	   mov eax,2000
	   call delay
Level3Start:

	   call clrscr

	   call RefreshY
	   mov dh, 12
	   mov dl, 20
	   call gotoxy
	   mov edx,offset Lvl3
	   call WriteString
	   mov eax,1500
	   call delay
	   call clrscr

	   	   ; Level 3 code area
	   push 9		;Push number of falling items
	   call newNum      ;fills 5 items in rainArray with either a char 1 or char 0 for printing purposes. 
	   add esp,4
	  
	   push 9
	   push offset xArray
	   push 45
	   call FillArray ; Populates the xArray with 5 X coordinates from 0 to 44
	   add esp,12
	  
	   call Startposition
	   
	   call Level3

	   ; End of Level 3 code area
	   call clrscr

	   mov dh, 12
	   mov dl, 2
	   call gotoxy
	   mov edx,offset Lvl3C
	   call WriteString
	   mov eax,2000
	   call delay
Level4Start:
	   call clrscr

	   call RefreshY
	   mov dh, 12
	   mov dl, 20
	   call gotoxy
	   mov edx,offset Lvl4
	   call WriteString
	   mov eax,1500
	   call delay
	   call clrscr

	   	   ; Level 4 code area
	   push 12		;Push number of falling items
	   call newNum      ;fills 5 items in rainArray with either a char 1 or char 0 for printing purposes. 
	   add esp,4
	  
	   push 12
	   push offset xArray
	   push 45
	   call FillArray ; Populates the xArray with 5 X coordinates from 0 to 44
	   add esp,12
	  
	   call Startposition
	   
	   call Level4

	   ; End of Level 4 code area
	   call clrscr

	   mov dh, 12
	   mov dl, 2
	   call gotoxy
	   mov edx,offset Lvl4C
	   call WriteString
	   mov eax,2000
	   call delay
	   
Level5Start:
	   call clrscr

	   call RefreshY
	   mov dh, 12
	   mov dl, 20
	   call gotoxy
	   mov edx,offset Lvl5
	   call WriteString
	   mov eax,1000
	   call delay
	   call clrscr

	   	   ; Level 5 code area
	   push 15		;Push number of falling items
	   call newNum      ;fills 5 items in rainArray with either a char 1 or char 0 for printing purposes. 
	   add esp,4
	  
	   push 15
	   push offset xArray
	   push 45
	   call FillArray ; Populates the xArray with 5 X coordinates from 0 to 44
	   add esp,12
	  
	   call Startposition
	   
	   call Level5

	   ; End of Level 5 code area
	   
	   jmp EndSecretLevel
SecretLevelStart:
	   call clrscr

	   mov S,1

	   call RefreshY
	   mov dh, 12
	   mov dl, 20
	   call gotoxy
	   mov edx,offset Secret
	   call WriteString
	   mov eax,1000
	   call delay
	   call clrscr

	   	   ; Secret level code area
	   push 30		;Push number of falling items
	   call newNum      ;fills 15 items in rainArray with either a char 1 or char 0 for printing purposes. 
	   add esp,4
	  
	   push 30
	   push offset xArray
	   push 47
	   call FillArray ; Populates the xArray with 15 X coordinates from 0 to 46
	   add esp,12
	  
	   call Startposition
	   
	   call SecretLevel

	   ; End of Secret level code area
EndSecretLevel:
	
	   call clrscr

	   mov dh, 12
	   mov dl, 0
	   call gotoxy
	   mov edx,offset Lvl5C
	   call WriteString
	   mov dh, 11
	   mov dl, 24
	   call gotoxy
	   mov al, 1
	   call WriteChar
	   mov eax,2000
	   call delay
	   call clrscr
	   jmp Yes

EndGame:
		exit
		
EndCheck:	
		ret
Death ENDP

;-------------------------------------------------------------------------------
RefreshY proc

	mov esi, 0
	cmp S,1
	je  SecretLoop
freshLoop:
	cmp esi, 14
	ja endFresh
	mov yArray[esi] , 0
	inc esi
	jmp freshLoop
endFresh:
	jmp endSecret

SecretLoop:
	cmp esi,29
	ja endSecret
	mov yArray[esi],0
	inc esi
	jmp SecretLoop
endSecret:

	ret
RefreshY endp



END main

