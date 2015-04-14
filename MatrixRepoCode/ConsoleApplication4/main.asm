

; Description: Matrix Rain
; 
; Revision date: 2/13/2015

INCLUDE Irvine32.inc
INCLUDE Macros.inc
.data

randPos dword ?		;Random int for 1 and 0 X position
yArray byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0				;Y for coordinate
xArray byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
rainArray byte '0','0','0','0','0','0','0','0','0','0','0','0','0','0','0'
titleStr byte "Matrix Rain",0				;Title
beginX byte 23 
deathMessage byte "You were hit!...",0
replay byte "Play Again? (Y/N)",0
response byte 0; Response to yes or no for replay


outHandle Handle 0

;BufferBounds COORD <46,25>
WindowRect Small_Rect <0,0,45,24>;Left, top, right, and bottom bounds for window size
.code

main PROC
	   INVOKE GetStdHandle,STD_OUTPUT_HANDLE
	   mov outHandle,eax

	   ;INVOKE SetConsoleScreenBufferSize,outHandle,BufferBounds			;Set console buffer size bounds to X:45 and Y:24 

	   INVOKE SetConsoleWindowInfo,outHandle,TRUE,ADDR WindowRect			;Set console window to coordinates of Size variable
	  
	   INVOKE SetConsoleTitle, ADDR titleStr	;calls the title

	   mov eax,green + (black * 16);Green Text, black background
	   call SetTextColor      ;Sets the color
	   XOR eax,eax            ;clear eax
	   call clrscr
	   call newNum
	   
	  
	   
	   push 5
	   push offset xArray
	   push 45
	   call FillArray
	   add esp,12
	 
	   
	   call StartPosition
KeyLoop:;Die to break the loop
	   call checkY
	   call fall             ;call fall proc
	   call ReadKey          ; looks for keyboard input
	   jz KeyLoop

	   call RightIf
	   call LeftIf
		
	   jmp KeyLoop
EndLoop:

	   exit
main ENDP


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

checkY PROC ;proc to check y-coordinate Proc by Kilian
		mov esi,0
CheckAll:
		cmp esi,14
		ja  EndCheck

		
		mov al,yArray[esi]

		cmp al,23d           ;see if rain hits the ground
	     je  _there
	     jmp _endif1
_there:
	     call Death
	     push 15
		push offset rainArray
		push 1
		call FillArray         ;make new piece of rain
	     add esp,12

		push 15
		push offset xArray
		push 45
		call FillArray         ;make new starting X-coord
		add esp,12
_endif1:
EndCheck:
		ret
checkY ENDP ;end checkY proc

;---------------------------------------------------------------------------------------------------------------------

fall PROC ;proc for moving pieces downProc by Kilian	
		mov eax,50 		 ; delay time ms
		call Delay		 ;So we can see change speed 
		mov esi,0
All:
		cmp esi,14
		ja  EndAll
		mov ebx,offset yArray
		mov al,[ebx+esi]
		inc al		 ;increment y coordinate
		mov [ebx+esi],al 
	     
		inc esi
		jmp All
EndAll:	     
	     call print
		ret
fall ENDP;End move proc

;---------------------------------------------------------------------------------------------------------------------

RightIf PROC USES edx;John Proc
	     cmp ah , 4Dh
	     je Then1
          jmp endright           ; Jmp to end of proc

Then1: 
		inc beginX             ; Increments X coordinate value	
	     call print
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
      
	     call print
	     call ReadKeyFlush       ;Flushes keyboard input buffer and clears internal counter for faster response time
endleft:
	 
	     ret
 LeftIf ENDP

 ;------------------------------------------------------------------------------------------------------------------------

 
 StartPosition PROC USES edx;John Proc
	     ;Player Starting Point
	     mov dh , 23d            ; column 24
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


;******* proc to make it easier to reprint the rain;Kilian Proc

print PROC 
		call clrscr
		
		mov esi,0
PrintAll:
		cmp esi,5
		ja  EndPrint
		
		mov dl,xArray[esi]

		mov dh,yArray[esi]
		call Gotoxy            ;Moves cursor to the position of rain
		
		
		mov al,rainArray[esi]
		call WriteChar          ;Rewrite rain
	     inc esi
		
		mov dh,23d              ;move cursor to character's current position ********* Added to this version by Killian edited by John
		mov dl , beginX
if5: 
		cmp beginX, 79          ; check if X goes past 79
		jg then5
		jmp end5

then5: 
		mov dl, 78d
		mov dh, 23d
end5:
		call Gotoxy
		mov al,'X'              ;move X into al                              *********
		call WriteChar          ;print it					**********
		call Crlf
		xor al,al               ;clear 
		jmp PrintAll
EndPrint:
		pop ebp
		ret
print		ENDP

;----------------------------------------------------------------------------------------------------------------------

newNum Proc
	mov ecx, 5
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
	ret
newNum endp

;--------------------------------------------------------------------------------------------------------------------------
Death Proc Uses edx eax ; Added by John Descrpition: Checks where the nummber is and if it is above then X char.
		mov esi,0
CheckAll:
If4:
		mov al , beginX         ; Moves the Character's X coordinate into eax for cmp
		cmp ah,14
		ja  EndCheck
		mov ebx,offset xArray
		mov ah,[ebx+esi]

		cmp al , ah
		je then4
		jmp yes
then4:
		call Clrscr
		mov dh, 12
		mov dl, 33
		call Gotoxy             ; Sets cursor to print kill message
		mov edx, offset deathmessage
		call WriteString        ; Displays deathmessage
		call Crlf
		XOR eax,eax             ; clears eax for the yes/no loop

loop1:
		cmp response , 0
		jne answer	
		mov dl,33
		mov dh,13
		call Gotoxy
		mov edx, offset replay
		call WriteString
		call Readchar
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
		inc esi
		jmp CheckAll
EndCheck:	
		ret
Death ENDP

END main

