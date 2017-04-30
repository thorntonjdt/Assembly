TITLE Program 6    (Project06.asm)

; Author: Jake Thornton
; Class: CS271-001
; Assignment: 6A
; Description: Takes 10 strings and converts them to their numeric value, then takes the numeric values
; and converts them back to a string. Then displays all 10 strings, their sum, and their average.


INCLUDE Irvine32.inc

MAX equ 100

getString MACRO string

	mov edx, OFFSET out7
	call WriteString
	mov eax, 11
	sub eax, ecx
	call WriteDec
	mov edx, OFFSET out8
	call WriteString
	mov eax, sum1
	call WriteDec
	call CrLf

	mov edx, OFFSET prompt1
	call WriteString
	xor edx, edx
	mov edx, string
	mov ecx, MAX
	call ReadString
	call CrLf
ENDM

displayString MACRO number
	mov edx, number
	call WriteString
	mov edx, OFFSET space1
	call WriteString
ENDM

.data

out1		BYTE	"PROGRAMMING ASSIGNMENT 6: Reading And Writing Values", 0
out2		BYTE	"Written by: Jake Thornton", 0
EC1			BYTE	"**EC: Number each line of user input and display a running subtotal of the user's numbers.", 0
out3		BYTE	"Give me 10 unsigned decimal integers (they must fit in a 32 bit register).", 0
out4		BYTE	"I will display a list of the integers, their sum, and their average", 0
prompt1		BYTE	"Please enter an unsigned number: ", 0
inString	BYTE MAX DUP(?)
outString	BYTE MAX DUP(?)
outString2	BYTE MAX DUP(?)
outNumeric	DWORD	0
error1		BYTE	"ERROR: You did not enter an unsigned number or your number was too big.", 0
sLength		DWORD	0
numArray	DWORD 10 DUP(?)
sum1		DWORD	0
space1		BYTE	", ", 0
out5		BYTE	"SUM: ", 0
out6		BYTE	"   AVERAGE: ", 0
out7		BYTE	"NUMBER ", 0
out8		BYTE	"   CURRENT SUM: ", 0

.code
main PROC
	mov edx, OFFSET out1		;Display title and introduction
	call WriteString
	call CrLf
	mov edx, OFFSET out2
	call WriteString
	call CrLf
	mov edx, OFFSET EC1
	call WriteString
	call CrLf
	call CrLf
	mov edx, OFFSET out3
	call WriteString
	call CrLf
	mov edx, OFFSET out4
	call WriteString
	call CrLf
	call CrLf

	mov ecx, 10
	mov edi, OFFSET numArray
input:
	push edi					;keep track of which number is being inputted
	push ecx
	push OFFSET sum1
	push OFFSET sLength
	push OFFSET inString
	call ReadVal
	pop ecx
	pop edi

	mov eax, outNumeric
	mov [edi], eax				;inputs number into array
	add sum1, eax				;adds to sum
	add edi, 4					;increments array
	loop input

	call CrLf
	mov ecx, 10
	mov edi, OFFSET numArray

output:
	mov eax, [edi]				;number to be converted to string
	push ecx
	push edi
	push OFFSET outString2
	push OFFSET outString
	push eax
	call WriteVal
	mov ecx, MAX
clearSt:						;clears string buffers
	mov outString[ecx], 0
	loop clearSt
	mov ecx, MAX
clearSt2:
	mov outString2[ecx], 0
	loop clearSt2
	pop edi
	pop ecx

	add edi, 4
	loop output

	mov edx, OFFSET out5			;displays sum and average
	call WriteString
	mov eax, sum1
	call WriteDec
	mov edx, OFFSET out6
	call WriteString
	mov ecx, 10
	mov eax, sum1
	xor edx, edx
	div ebx
	call WriteDec
	call CrLf

	exit	; exit to operating system
main ENDP

;Procedure to read in a user's string input and convert to a numeric value
;Recieves: String, String length
;Returns: numeric value, string length
;Preconditions: none
;Registers changed: eax, ebx, edx

ReadVal	PROC
	push ebp
	mov ebp, esp

start:
	getString [ebp+8]			;macro to get string from user
	mov [ebp+12], eax			;sets string length
	mov ecx, eax
	mov edx, 0					;resets edx
	mov esi, [ebp+8]
	cld

counter:
	lodsb						;checking string digit by digit
	cmp al, 48					;making sure it is a digit
	jb invalid
	cmp al, 57
	ja invalid
	sub al, 48
	mov ebx, eax				;setting each digit to the right value (ex 21, 2->20)
	mov eax, edx
	mov edx, 10
	mul edx
	add eax, ebx
	mov edx, eax
	mov eax, 0
	loop counter
	mov outNumeric, edx
	add [ebp+16], edx
	jmp endBlock

invalid:
	mov edx, OFFSET error1
	call WriteString
	call CrLf
	mov edx, 0
	jmp start

endBlock:
	pop ebp
	ret 12
ReadVal ENDP

;Procedure to convert the numeric values back to a string
;Recieves: a numeric value from array
;Returns: output string
;Preconditions: numeric value array is filled
;Registers changed: edx, ebx

WriteVal PROC
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]
	mov ebx, 10
	mov edi, [ebp+12]
	mov ecx, 0
again:
	mov edx, 0				;reversing back to a string by dividing a digit by their respective base
	div ebx
	add dl, 48
	mov [edi], dl
	inc edi
	inc ecx
	cmp eax, 0
	jne again

	mov esi, [ebp+12]
	add esi, ecx
	dec esi
	mov edi, [ebp+16]
reverse:					;reverse string to display properly
	std
	lodsb
	cld
	stosb
	loop reverse

	displayString [ebp+16]
	pop ebp
	ret 12
WriteVal ENDP

END main
