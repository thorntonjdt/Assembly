TITLE The Great Accumulator     (Project03.asm)

; Author: Jake Thornton
; Class: CS271-001
; Course / Project ID  : Project 03
; Description: This program will take a series of user inputted negative numbers and display the sum, average, and amount of numbers entered

INCLUDE Irvine32.inc

LOWER_LIMIT equ -100

.data

intro1		BYTE	"THE GREAT ACCUMULATOR by Jake Thornton", 0
ec1			BYTE	"**EC: Number the lines during user input.", 0
prompt1		BYTE	"What is your name? ", 0
name1		DWORD	?, 0
intro2		BYTE	"Hello, ", 0
instructions1	BYTE	"Please enter numbers in [-100, -1]", 0
instructions2	BYTE	"I will find the total sum of every number entered, enter a non-negative number when you wish to stop.", 0
prompt2			BYTE	"Enter number ", 0
prompt3			BYTE	": ", 0
invalid1		BYTE	"You must enter a number greater than -100!", 0
results1		BYTE	"You entered ", 0
results2		BYTE	" valid numbers with a sum of ", 0
sum1			DWORD	?
results3		BYTE	" and an average of ", 0
results4		BYTE	"You did not enter any numbers!", 0
goodbye1		BYTE	"See ya later ", 0

.code
main PROC

;Display title and author (intro1)
mov edx, OFFSET intro1
call WriteString
call CrLf
mov edx, OFFSET ec1
call WriteString
call CrLf
call CrLf

;Get the user's name and greet the user (intro2, name1, intro3)
mov edx, OFFSET prompt1
call WriteString
mov edx, OFFSET name1
mov ecx, 32
call ReadString
call CrLf
mov edx, OFFSET intro2
call WriteString
mov edx, OFFSET name1
call WriteString
call CrLf

;Display instructions for the user(instructions1)
mov edx, OFFSET instructions1
call WriteString
call CrLf
mov edx, OFFSET instructions2
call WriteString
call CrLf

;Prompt user for number between -100 and -1 until a non-negative number is entered.
mov ecx, 1		;stores amount of numbers entered (starts at 1 for line count)
mov sum1, 0     ;stores sum of numbers entered
jmp again

;if number is invalid the number won't be counted and loop will start again with an invalid input message
invalid:
	mov edx, OFFSET invalid1
	call WriteString
	call CrLf

again:
	mov edx, OFFSET prompt2
	call WriteString
	mov eax, ecx
	call WriteDec
	mov edx, OFFSET prompt3
	call WriteString
	call ReadInt
	cmp eax, -1
	jg display
	cmp eax, LOWER_LIMIT
	jl invalid
	add sum1, eax
	inc ecx
	jmp again

;Display number of negative numbers entered and their sum
display:
	dec ecx						;removes 1 from counter since it is initialized at 1 and not 0
	cmp ecx, 0
	je empty
	call CrLf
	mov edx, OFFSET results1
	call WriteString
	mov eax, ecx
	call WriteDec
	mov edx, OFFSET results2
	call WriteString
	mov eax, sum1
	call WriteInt

;Calculate and display average
mov edx, OFFSET results3
call WriteString
cdq
mov eax, sum1
idiv ecx
call WriteInt
call CrLf
call CrLf
jmp goodbye

empty:
	mov edx, OFFSET results4
	call WriteString
	call CrLf

;Parting message with users name
goodbye:
	mov edx, OFFSET goodbye1
	call WriteString
	mov edx, OFFSET name1
	call WriteString
	call CrLf

	exit	; exit to operating system
main ENDP

END main
