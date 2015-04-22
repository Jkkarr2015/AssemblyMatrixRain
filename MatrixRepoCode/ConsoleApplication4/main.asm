

; Description: Matrix Rain
; 
; Start date: 2/13/2015
;Revision date: 4/14/2015

INCLUDE Irvine32.inc
INCLUDE Macros.inc
.data

;Array Variables
yArray byte 15 DUP(0)				;Y for coordinate
xArray byte 15 DUP(?)
rainArray byte 15 DUP(?)

;Title Variable
titleStr byte "Matrix Rain",0				;Title

;X / Death Proc Variables
beginX byte 23 
deathMessage byte "You were hit!...",0
replay byte "Play Again? (Y/N)",0
response byte 0; Response to yes or no for replay
count dword 0


;Window Sizing Variables
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
	   
	   push 5			;count
	   call newNum
	   add esp,4
	  
	   
	   push 5
	   push offset xArray
	   push 45
	   call FillArray
	   add esp,12
	 
	   
	   call Startposition
	   
	   
	   call print
	 

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


;----------------------------------------------------------------------------------------------------------------------

Reset PROC uses eax ebx 
	mov yArray[esi],0

	mov al, 2
	call RandomRange

	cmp al, 0
	jne L2
	mov rainArray[esi], '0'; Movs char zero into rain
	XOR eax,eax; Clears EAX
	jmp _End
L2:
	mov rainArray[esi], '1'
	XOR eax,eax
_End:

	mov al,45
	call RandomRange 

	mov xArray[esi],al
	
	ret
Reset ENDP

;---------------------------------------------------------------------------------------------------------------------

fall PROC uses eax ;proc for moving pieces downProc by Kilian	
; Parameter (Int indexOfElement)
		push esi
		mov esi,ebx
	    ;mov eax, 25
	    ;call delay
All:
		cmp yArray[esi],23
		je  _Reset
		jmp endDeath
_Reset:
		mov al, beginX
	     cmp xArray[esi], al 
		je Death
		call Reset
		jmp EndAll
EndReset:

Death:
		call Death
endDeath:
		
		inc yArray[esi]		 ;increment y coordinate
		
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
		inc beginX             ; Increments X coordinate value	
	     
		

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
print		ENDP




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
Death Proc Uses edx eax ; Added by John Descrpition: Checks where the nummber is and if it is above then X char.
	
		call Clrscr
		mov dh, 12
		mov dl, 23
		call Gotoxy             ; Sets cursor to print kill message
		mov edx, offset deathmessage
		call WriteString        ; Displays deathmessage
		call Crlf
		XOR eax,eax             ; clears eax for the yes/no loop

loop1:
		cmp response , 0
		jne answer	
		mov dl,23
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
		
EndCheck:	
		ret
Death ENDP

END main

