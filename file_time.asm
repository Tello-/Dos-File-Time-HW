TITLE  Chapter 7, Dos_file_time (file_time.asm)

; Program:     Chapter 7, DOS_file_time
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

	call Prompt_Input
	call Print_Bin_Equivalent
	call ShowFileTime

	exit
main ENDP


;**********************************************************************
	Prompt_Input PROC USES edx
	;Description:	asks client for 4 digit hex and loads its into ax
	;Receives:		none
	;Returns:		ax containing hex value
;**********************************************************************
		mov edx, OFFSET prompt
		call WriteString
		call ReadHex
		ret
	Prompt_Input ENDP
;**********************************************************************


;**********************************************************************
	Print_Bin_Equivalent PROC USES ebx edx
	;Description:	Prints 16 bit Bin value for client given hex
	;Receives:		eax number to write
	;Returns:		nothing 
;**********************************************************************
		mov edx, OFFSET binary_result
		call WriteString
		mov ebx, 2
		call WriteBinB
		call Crlf
		ret
	Print_Bin_Equivalent ENDP
;**********************************************************************

;**********************************************************************
	Print_Zeroes PROC USES eax ecx
	;Description:	Prints Bin value for client given hex
	;Receives:		al number of zeroes to write
	;Returns:		nothing
;**********************************************************************
		movzx ecx, al 
		mov al, '0'
		L1:		
			call WriteChar
		loop L1
		ret
	Print_Zeroes ENDP
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
	ShowFileTime PROC USES eax edx
	;Description:	receives a binary file time value in the AX register and displays the time in hh:mm:ss format
	;Receives:		ax register with binary value
	;Returns:		None
;**********************************************************************
		mov edx, OFFSET file_time_result
		call WriteString


		;:::::::::: Attain Hours ::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::		
		call Extract_Hour ; loads dl with binary value of target bit segment of hours
		push eax ; preserve bit segment for more register use

		;*** Add Leading Zeroes if needed *****
		.IF dl < 10
			mov eax, 01h
			call Print_Zeroes
		.ENDIF
		;***************************************
		
		;*** Print binary value to console as Dec
		movzx eax, dl
		call WriteDec
		call Print_Colon
		;****************************************
		pop eax ; restore eax with bit segment for next extraction
		;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;::::::::::::End of Attaining Hours:::::::::::::::::::::::::::::::::::::::::::::::::
		
		

		;:::::::::: Attain Minutes::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		call Extract_Minute ; loads dl with binary value of minutes shifted all the way left
		push eax ; preserve bit segment for more register use

		;*** Add Leading Zeroes if needed *****
		.IF dl < 10
			mov eax, 01h
			call Print_Zeroes
		.ENDIF
		;***************************************
		
		;*** Print binary value to console as Dec
		movzx eax, dl
		call WriteDec
		call Print_Colon
		;****************************************
		pop eax ; restore eax with bit segment for next extraction
		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;::::::::::::End of Attaining Minutes:::::::::::::::::::::::::::::::::::::::::::::::


		;:::::::::: Attain Seconds::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		call Extract_Second ; loads dl with binary value of minutes shifted all the way left
		push eax ; preserve bit segment for more register use

		;*** Add Leading Zeroes if needed *****
		.IF dl < 10
			mov eax, 01h
			call Print_Zeroes
		.ENDIF
		;***************************************
		
		;*** Print binary value to console as Dec
		movzx eax, dl
		call WriteDec
		;****************************************
		pop eax ; restore eax with bit segment for next extraction
		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
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




 