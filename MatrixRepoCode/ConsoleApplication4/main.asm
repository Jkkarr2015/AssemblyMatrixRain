

; Description: Matrix Rain
; 
; Revision date: 2/13/2015

INCLUDE Irvine32.inc
INCLUDE Macros.inc
.data

randPos dword ?		;Random int for 1 and 0 X position
rain byte '0'			;Random int (0 or 1)
y byte 0				;Y for coordinate
titleStr byte "Matrix Rain",0				;Title
beginX byte 39 


.code

main PROC

	INVOKE SetConsoleTitle, ADDR titleStr	;calls the title

	mov eax,green + (black * 16);Green Text, black background
	call SetTextColor    ;Sets the color
	XOR eax,eax          ;clear eax
	call clrscr
	call StartPosition
	call newNum
	call startX
	KeyLoop:
		cmp al, 8h       ; Loop check to break out of loop back space breaks loop//Moved to top from the previous version By killian
		je EndLoop
		call checkY
		call fall ;call fall proc
		mov eax, 50        ; Allows for OS to time slice
		call Delay         ; need to read key presses without losing any
		call ReadKey       ; looks for keyboard input
		jz KeyLoop

		call RightIf
		call LeftIf
		
		jmp KeyLoop
	EndLoop:
	exit
main ENDP

startX PROC ;proc for starting x position for falling char Proc by kilian

	mov eax,80           ;Maybe need to use GetMax later to check size of console window, for now does between randomly 0 and 79
	call RandomRange     ;Getting the number
	mov y,0              ;resets the y
	mGotoxy al,y         ;Moves cursor to 0,randPos
	mov randPos,eax      ;eax into randPos
	mov al,rain          ;Move rain into eax 
	call WriteChar        ;Writes it
	mov rain,al          ;Moves it back 
	ret
startX ENDP ;end startX proc

;---------------------------------------------------------------------------------------------------------------------

checkY PROC ;proc to check y-coordinate Proc by Kilian
	cmp y,24d ;see if rain hits the ground
	je  _there
	jmp _endif1
_there:
	call newNum ;make new piece of rain
	call startX ;make new starting X-coord
_endif1:
	ret
checkY ENDP ;end checkY proc

;---------------------------------------------------------------------------------------------------------------------

fall PROC ;proc for moving pieces downProc by Kilian	
		mov eax,50 		; delay time ms
		call Delay		;So we can see change speed 
		inc y			;increment y coordinate 
	        call print
	ret
fall ENDP;End move proc

;---------------------------------------------------------------------------------------------------------------------

newNum PROC	;Make a new number and put into rain Porc by Kilian
		call Randomize	      ;Makes RandomRange random based on time of day 
	        mov al,2		      ;Between 0 or 1
	        call RandomRange     ;Get the number
		cmp al,0			 ;compare al and 0  
	        jne L2               ;If not equal go to L2             
L1:		mov rain,'0'				 ;if al equals 0, put 0(ASCII) in rain
		XOR eax,eax          ;clears eax
		jmp ENDLOOP
L2:  	        mov rain,'1'	 ;else al equals 1, move 1(ASCII) into rain
		XOR eax,eax          ;Clears eax
ENDLOOP:
	ret
	newNum ENDP;End NewNum proc

;------------------------------------------------------------------------------------

RightIf PROC USES edx;John Proc
	               cmp ah , 4Dh
	               je Then1
                       jmp endright        ; Jmp to end of proc
			Then1: 
				
				call print   ;reprints the rain **************
				inc beginX       ; Increments X coordinate value
				call print
				call ReadKeyFlush;
	endright:
	ret
 RightIf ENDP

 ;---------------------------------------------------------------------------------------------------------------------
 
 LeftIf PROC USES edx;John Proc
	cmp ah, 4Bh
	 je Then2
			 jmp endleft        ; Jmp to end of loop if user put in value that is not 3 or left arrow
			 Then2:
				 
				 call print  ;reprints everything ***************
				 dec beginX      ; Decrements X to move to the left
				 call print
				 call ReadKeyFlush ;Flushes keyboard input buffer and clears internal counter for faster response time
			endleft:
			ret
 LeftIf ENDP

 ;------------------------------------------------------------------------------------------------------------------------

 
 StartPosition PROC USES edx;John Proc
	;Player Starting Point
	mov dh , 24d; column 24
	mov dl,beginX ; row 39
	call Gotoxy; places cursor in the middle of the bottom part of the console window
	mov al,'X'; Copies player character to the AL register to be printed
	call WriteChar; Prints player to screen console
	call crlf
	;Player Starting point
	Xor al, al
	ret
 StartPosition ENDP

;------------------------------------------------------------------------------------------------------------------------


;******* proc to make it easier to reprint the rain;Killian Proc

print PROC
		call clrscr
		mov eax,randPos	    ;move x Coordinate into eax
		mGotoxy al,y        ;Moves cursor to the position of rain
		mov randPos,eax     ;Move x Coordinate back to eax
		mov al,rain         ;Moves rain to eax to write
		call WriteChar      ;Rewrite rain
		mGotoxy beginX,24d  ;move cursor to character's current position ********* Added to this version by Killian
		mov al,'X'          ;move X into al                              *********
		call WriteChar      ;print it					**********
		call Crlf
		xor al,al           ;clear al
		ret
print		ENDP

END main
