TITLE  Chapter 7, Dos_file_time (file_time.asm)

; Program:     Chapter 7, DOS_file_time , (Refined after crtique)
; Description: Program to display file time format
; Student:     Josh Lollis
; Date:        03/20/2020
; Class:       CSCI 241
; Instructor:  Mr. Ding

; ::::: Symbolic Constants Used in Extraction Procs ::::::
; ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
hour_offset = 11
minute_offset_left = 5
minute_offset_right = 10
second_offset_left = 11
second_offset_right = 10
; ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; ::::::::::::::::::::::::::::::::::::::::::::::::::::::::

INCLUDE Irvine32.inc
.data
prompt BYTE "Please enter 16-bit hexadecimal (4-digit, e.g., 1207):", 0
binary_result BYTE "Your equivalent binary is: ", 0
file_time_result BYTE "Your DOS file time is: ", 0

.code
main PROC

; Prompt for input::::::::::::::::::::::
	mov edx, OFFSET prompt
	call WriteString
	call ReadHex
; ::::::::::::::::::::::::::::::::::::::

; Write Binary Equivalent:::::::::::::::
	mov edx, OFFSET binary_result
	call WriteString
	mov ebx, 2
	call WriteBinB
	call Crlf
; :::::::::::::::::::::::::::::::::::::

	call ShowFileTime

	exit
main ENDP


;**********************************************************************
	Print_With_Zero_Pad PROC USES eax ecx edx
	;Description:	Checks if a zero is needed to pad time format
	;Receives:		none
	;Returns:		nothing
;**********************************************************************
		cmp dl, 10
		jae next
		movzx ecx, al 
		mov al, '0'
		call WriteChar
		next:
			movzx eax, dl
			call WriteDec
		ret
	Print_With_Zero_Pad ENDP
;**********************************************************************		
		

;**********************************************************************
	Print_Colon PROC USES eax
	;Description:	Prints a ':'
	;Receives:		none
	;Returns:		nothing
;**********************************************************************
		mov al, ':'
		call WriteChar
		ret
	Print_Colon ENDP
;**********************************************************************


;**********************************************************************
	ShowFileTime PROC USES edx
	;Description:	receives a binary file time value in the AX register and displays the time in hh:mm:ss format
	;Receives:		ax register with binary value
	;Returns:		None
;**********************************************************************
		mov edx, OFFSET file_time_result
		call WriteString

		;:::::::::: Attain Hours ::::::::::::::::::::::::::::::::::::::::::::::::::::::		
		call Extract_Hour ; loads dl with binary value of target bit segment of hours
		call Print_With_Zero_Pad
		call Print_Colon		
		;::::::::::::End of Attaining Hours:::::::::::::::::::::::::::::::::::::::::::::::::		
		

		;:::::::::: Attain Minutes::::::::::::::::::::::::::::::::::::::::::::::::::::::::::		
		call Extract_Minute ; loads dl with binary value of target bit segment of minutes
		call Print_With_Zero_Pad
		call Print_Colon		
		;::::::::::::End of Attaining Minutes:::::::::::::::::::::::::::::::::::::::::::::::


		;:::::::::: Attain Seconds::::::::::::::::::::::::::::::::::::::::::::::::::::::::::		
		call Extract_Second ; loads dl with binary value of target bit segment of seconds
		call Print_With_Zero_Pad		
		;::::::::::::End of Attaining Seconds::::::::::::::::::::::::::::::::::::::::::::::::		
		
		call Crlf
		ret
	ShowFileTime ENDP
;**********************************************************************



;**********************************************************************
	Extract_Hour PROC USES eax
	;Description:	receives a binary file time value in the AX register and parses out the hours value
	;Receives:		ax register with binary time value
	;Returns:		dl register with binary hour value
;**********************************************************************		
		movzx edx, ax
		shr dx, hour_offset
		ret
	Extract_Hour ENDP
;**********************************************************************

;**********************************************************************
	Extract_Minute PROC USES eax
	;Description:	receives a binary file time value in the AX register and parses out the min value
	;Receives:		ax register with binary time value
	;Returns:		dl register with binary minute value
;**********************************************************************		
		movzx edx, ax
		shl dx, minute_offset_left
		shr dx, minute_offset_right
		ret
	Extract_Minute ENDP
;**********************************************************************

;**********************************************************************
	Extract_Second PROC USES eax
	;Description:	receives a binary file time value in the AX register and parses out the seconds value
	;Receives:		ax register with binary time value
	;Returns:		dl register with binary second value
;**********************************************************************		
		movzx edx, ax
		shl dx, second_offset_left
		shr dx, second_offset_right 
		ret
	Extract_Second ENDP
;**********************************************************************

END main




 