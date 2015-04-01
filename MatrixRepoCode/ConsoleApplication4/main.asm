; Description: Matrix Rain
; 
; Revision date: 2/13/2015

INCLUDE Irvine32.inc
INCLUDE Macros.inc
.data

numRainX dword 0		;storage for increments of 4 for pointer of the last position in x array wanted
numRainY dword 0		;storage for increments of 4 for position of the last position in the y array wanted
numRaining dword 0		;for increments of 1 for pointer to the last position in rainArray 
question byte "How many pieces will fall (under 15)?",0						;number asked to enter that will rain(all at once unless there's a duplicate number, then for now I will see if that really hurts it)
rainArray  byte '0','0','0','0','0','0','0','0','0','0','0','0','0','0','0'
xArray dword 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	;and rain character x and y coordinate arrays of 15, initialized to 0 (First level initial idea) 
yArray dword 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
rain byte '0'			;Random int (0 to 9)
y dword 0				;Y for coordinate
titleStr byte "Matrix Rain",0				;Title
beginX byte 39 
deathMessage byte "You were hit!...",0

replay byte "Play Again? (Y/N)",0
response byte 0; Response to yes or no for replay


.code

main PROC
	
	INVOKE SetConsoleTitle, ADDR titleStr	;calls the title

	mov eax,green + (black * 16);Green Text, black background
	call SetTextColor    ;Sets the color
	XOR eax,eax          ;clear eax
	
	mov edx,offset question		;how many pieces will fall?
	call WriteString			;write it
	xor edx,edx

	call ReadDec
	cmp eax,0					
	jle  EndLoop				;if num inputted is equal to 0, end

	mov ecx,eax
	push esi
	mov esi,offset rainArray		
	mov numRaining,eax			;copy number wanted to make for pieces into numRaining
	add esi,numRaining			;add pointer and num wanted to increment accordingly later in newNum
	mov numRaining,esi			;copy into numRaining

	mov esi,offset xArray
	mov ebx,4
	mul ebx					;for each increment needed of 4
	jc  EndLoop 
	add eax,esi				;add multiple of 4 and pointer for array size wanted
	mov numRainX,eax			;save in numRainX(basically just did a LengthOf for dword arrays)
	
	mov eax,ecx				;copy number inputted into eax
	mov esi,offset yArray
	mov ebx,4
	mul ebx					;for each increment needed of 4
	jc  EndLoop 
	add eax,esi				;add multiple of 4 and pointer for array size wanted
	mov numRainY,eax			;save in numRainX(basically just did a LengthOf for dword arrays)	
	pop esi

	xor eax,eax
	xor ecx,ecx
	xor ebx,ebx				;start with clear registers
	call clrscr
	call StartPosition
	call newNum
	call populateX
	KeyLoop:;Die to break the loop
		call checkY
		call print
		call fall ;call fall proc
		
		call ReadKey       ; looks for keyboard input
		jz KeyLoop

		call RightIf
		call LeftIf
		
		
		jmp KeyLoop
	EndLoop:
	exit
main ENDP

populateX PROC uses eax ebx ecx;proc for popualating starting X position array for falling char Proc by kilian
	push esi
	mov esi,offset xArray		;at beginning of array
	mov ebx,offset yArray		;same
	mov ecx,offset rainArray		;same
L1:
	mov eax,80           ;Maybe need to use GetMax later to check size of console window, for now does between randomly 0 and 79
	call RandomRange     ;Getting the number
	mov [esi],eax		 ;move the number into it's spot in array 
	push eax
	xor eax,eax		 ;reset all y's to 0
	mov [ebx],eax
	pop eax
	mGotoxy al,[ebx]         ;Moves cursor to 0,X coordinate
	mov al,[ecx]          ;Move rain into al
	call WriteChar        ;Writes it
	xor eax,eax 
	add esi,4			  ;point to next array spots
	add ebx,4
	inc bl
	cmp esi,numRainX
	ja  EndLoop		  ;if about to be greater than number wanted, stop
	cmp ebx,numRainY
	ja  EndLoop		  ;if about to be greater than number wanted, stop
	cmp ebx,numRaining
	ja  EndLoop		  ;if about to be greater than number wanted, stop
	jmp L1			  ;else, keep moving through array
Endloop:
	pop esi
	ret
populateX ENDP ;end populateX proc

;---------------------------------------------------------------------------------------------------------------------

checkY PROC uses eax;proc to check y-coordinate Proc by Kilian
	push esi
	mov esi,offset yArray;put in beginning pointer to array
L1:
	mov eax,[esi]
	cmp eax,24d ;see if rain hits the ground
	je  _there
	jmp _endif1
_there:
	call Death
	call newNum ;make new pieces of rain
	call populateX ;make new starting X-coordinates
_endif1:
	add esi,4				;look at next spot
	cmp esi,numRainY
	ja EndLoop			;if the next spot's number is greater than the number wanted to rain, end
	jmp L1				;if not, keep going through array
EndLoop:
	pop esi
	ret
checkY ENDP ;end checkY proc

;---------------------------------------------------------------------------------------------------------------------

fall PROC uses eax;proc for moving pieces down. Proc by Kilian	
		push esi
		mov eax,50	; delay time ms
		call Delay		;So we can see change speed
		mov esi,offset yArray;put the beginning pointer of array into esi
L1: 
		mov ebx,[esi]		;copy contents into ebx
		inc ebx			;increment y coordinate
		mov [esi],ebx
		add esi,4			;moves to next position of array
		cmp esi,numRainY
		ja EndLoop		;if about to be past number wanted, end
		jmp L1
EndLoop:
		pop esi 
	ret
fall ENDP;End move proc

;---------------------------------------------------------------------------------------------------------------------

newNum PROC;Make a new number and put into rain Proc by Kilian
		push esi
		call Randomize	      ;Makes RandomRange random based on time of day
		mov esi,offset rainArray		;make pointer to array
L1:
	     mov al,10		      ;Between 0 or 9 inclusive (changed this because I watched the matrix the other day ;p)
	     call RandomRange     ;Get the number
		cmp al,0			 ;compare al and 0  
	     jne L2               ;If not equal go to L2             
		mov rain,'0'				 ;if al equals 0, put 0(ASCII) in rain			
		jmp EndLoop
L2:  	
		cmp al, 5			;If number is greater or below jump accordingly	  
		ja  above
		jb  below 
		mov rain,'5'        ;If neither move 5 into rain and end
		jmp EndLoop
above:
		cmp al,7
		ja  eight
		jb  six
		mov rain,'7'		;If neither it's 7
		jmp EndLoop
six:
		mov rain,'6'		;if less than 7, must be 6
		jmp EndLoop
eight:
		mov rain,'8'        ;if greater, 8
		jmp EndLoop
below:
		cmp al,3
		ja  four
		jb  either
		mov rain,'3'		;If neither it's 3
		jmp EndLoop
either:
		cmp al,2			;if less than 3, could be 2 or 1 
		je  two 
		mov rain,'1'		;if not equal to 2, is 1
		jmp EndLoop
two:
		mov rain,'2'
		jmp EndLoop
four:
		mov rain,'4'        ;if greater, 4
EndLoop:
		mov al,rain
		mov [esi],al		;copy character into it's position
		inc esi
		cmp esi,numRaining	;see if number wanted to rain is the next spot
		ja  EndLoop
		jmp L1
		xor eax,eax         ;clear eax
	ret
	newNum ENDP;End NewNum proc

;------------------------------------------------------------------------------------

RightIf PROC USES edx;John Proc
	               cmp ah , 4Dh
	               je Then1
                       jmp endright        ; Jmp to end of proc
			Then1: 
				inc beginX       ; Increments X coordinate value	
				if5: cmp beginX, 79; check if X goes past 79
					jg then5
					jmp end5
					then5: 
						mov beginX, 79
						mov dh, 23
					end5:
				
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
				 dec beginX      ; Decrements X to move to the left
				 if6: cmp beginX, 0; check if X goes under 0
					jl then6
					jmp end6
					then6: 
						mov beginX, 0
					end6:	
                     
				 
				 
				 call ReadKeyFlush ;Flushes keyboard input buffer and clears internal counter for faster response time
			endleft:
			ret
 LeftIf ENDP

 ;------------------------------------------------------------------------------------------------------------------------

 
 StartPosition PROC USES edx;John Proc
	;Player Starting Point
	mov dh , 23d; column 23
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


;******* proc to make it easier to reprint the rain;Kilian Proc

print PROC uses ebx eax ecx 
		call clrscr
		push esi
		mov esi,offset xArray
		mov ebx,offset yArray
		mov eax,offset rainArray
L1:
		push eax			;save rainArray position
		mov al,[esi]	     ;copy x Coordinate into al
		mov cl,[ebx]		;copy y coordinate into cl
		mGotoxy al,cl        ;Moves cursor to the position of rain
		pop eax
		mov al,[eax]         ;Moves rain to eax to write
		call WriteChar      ;Rewrite rain
		inc eax			;increment all pointers to arrays
		add esi,4
		add ebx,4

		cmp eax,numRaining	;compare each to see if they're past their mark	
		ja  EndLoop
		cmp ebx,numRainY
		ja EndLoop
		cmp esi,numRainX
	     ja EndLoop
		jmp L1
EndLoop:

		mov dh,23d  ;move cursor to character's current position ********* Added to this version by Kilian edited by John
		mov dl , beginX
		call Gotoxy
		mov al,'X'          ;move X into al                              *********
		call WriteChar      ;print it					**********
		call Crlf
		pop esi
		xor al,al           ;clear al
		ret
print	ENDP

;----------------------------------------------------------------------------------------------------------------------

Death Proc Uses edx eax ; Added by John Descrpition: Checks where the nummber is and if it is above then X char.

	mov esi,offset xArray
	If4:
checkAll:
		mov al , beginX ; Moves the Character's X coordinate into eax for cmp
		mov ebx,[esi]	
		cmp al , bl	;moves rain's x coordinate into ebx
		je then4
		jmp yes
		then4:
			call Clrscr
			mov dh, 12
			mov dl, 33
			call Gotoxy; Sets cursor to print kill message
			mov edx, offset deathmessage
			call WriteString; Displays deathmessage
			call Crlf
			XOR eax,eax; clears eax for the yes/no loop

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
			 Or response, 00100000B; bitmask for lowercase conversion
			 cmp response, 'y'; Yes reponse
			 je yes

		      mov dh, 24
			 mov dl, 0
			 call Gotoxy
			
			 exit; Exits if al is not 'y'
			
yes:
		mov response,0
		add esi,4 
		cmp esi,numRainX
		ja EndLoop
		jmp checkAll
EndLoop:
		ret
Death ENDP

END main