TITLE Project 5     (Project05.asm)

; Author: Jake Thornton
; Class: CS271-001
; Assignment: 5
; Description: Displays and sorts a list of numbers of a user inputted size and displays the median.

INCLUDE Irvine32.inc

; (insert constant definitions here)
MIN equ 10
MAX equ 200
LO equ 100
HI equ 999
.data

out1		BYTE	"THE RANDOM INTEGER SORTER   by Jake Thornton", 0
out2		BYTE	"This program will display a list of random integers for you and then sort them into descending order!", 0
out3		BYTE	"How many integers do you want to be sorted? Please enter a number between 10 and 200.", 0
request		DWORD	?
invalid1	BYTE	"You must enter a number between 10 and 200.", 0
list		DWORD	MAX DUP(0)
space1		BYTE	"   ", 0
title1		BYTE	"Unsorted List:", 0
title2		BYTE	"Sorted List:", 0
median1		BYTE	"The median is ", 0

.code
main PROC
	call Randomize
	call intro
	push OFFSET request
	call getData
	push OFFSET list
	push request
	call fillArray
	push OFFSET title1
	push OFFSET list
	push request
	call displayList
	push OFFSET list
	push request
	call sortList
	mov edx, OFFSET median1
	call WriteString
	push OFFSET list
	push request
	call displayMedian
	push OFFSET title2
	push OFFSET list
	push request
	call displayList
	exit	; exit to operating system
main ENDP

;Displays the introductions for the program
intro PROC
	mov edx, OFFSET out1
	call WriteString
	call CrLf
	call CrLf
	mov edx, OFFSET out2
	call WriteString
	call CrLf
	mov edx, OFFSET out3
	call WriteString
	call CrLf
	ret
intro ENDP

;Recieves and validates user input for how many integers they want
getData PROC
	push ebp
	mov ebp, esp
	mov ebx, [ebp+8]
	;get an integer for number of values to be displayed
input:
	call ReadInt
	cmp eax, 10
	jl invalid
	cmp eax, 200
	jg invalid
	jmp valid

;if invalid ask user to reinput integer
invalid:
	mov edx, OFFSET invalid1
	call WriteString
	call CrLf
	jmp input

;if valid return to main
valid:
	mov [ebx], eax
	call CrLf
	pop ebp
	ret 4
getData ENDP

;Fills array with random numbers until the amount requested by user has been added
fillArray PROC
	push ebp
	mov ebp, esp
	mov edi, [ebp+12]
	mov ecx, [ebp+8]
;Uses RandomRange to seed a random number then puts number in array, loops until array is filled
fill:
	mov eax, HI
	sub eax, LO
	inc eax
	call RandomRange
	add eax, LO
	mov [edi], eax
	add edi, 4
	loop fill

	pop ebp
	ret 8
fillArray ENDP

;Sorts the array in descending order
sortList PROC
	push ebp
	mov ebp, esp
	mov edi, [ebp+12]
	mov ecx, [ebp+8]
	dec ecx
	mov edx, ecx
;selection sort so outer keeps track of how many times the array needs to be passed through
outer:
	push edi
	push ecx
;sorts through entire array once, swapping values
inner:
	mov eax, [edi]
	mov ebx, [edi+4]
	cmp eax, ebx
	jl switch
next:
	add edi, 4
	loop inner
	pop ecx
	pop edi
	loop outer
	jmp endBlock

;switches numbers if they are out of order
switch:
	mov [edi], ebx
	mov [edi+4], eax
	jmp next

endBlock:
	pop ebp
	ret 8
sortList ENDP

;Calculates and displays the median of the array
displayMedian PROC
	push ebp
	mov ebp, esp
	mov edi, [ebp+12]
	mov eax, [ebp+8]
	mov ebx, 2
	cdq
	div ebx
	cmp edx, 0			;checks if there are an even amount of numbers
	jne odd
	dec eax
	mov ebx, 4
	mul ebx				;multiply by 4 to get byte address for array
	mov ebx, eax
	add ebx, 4
	mov eax, [edi+eax]	;finding the average of the two medians
	mov ebx, [edi+ebx]
	add eax, ebx
	mov ebx, 2
	div ebx
	jmp display

;only one median
odd:
	mov ebx, 4
	mul ebx
	mov eax, [edi+eax]
display:
	call WriteDec
	call CrLf
	call CrLf
	pop ebp
	ret 8
displayMedian ENDP

;Outputs array to screen and displays the list title
displayList PROC
	push ebp
	mov ebp, esp
	mov edx, [ebp+16]
	call WriteString
	call CrLf
	mov esi, [ebp+12]
	mov ecx, [ebp+8]
	mov ebx, 1
more:
	mov eax, [esi]
	call WriteDec
	mov edx, OFFSET space1
	call WriteString
	cmp ebx, 10				;checks if there are 10 numbers in the row yet
	jne sameLine
	call CrLf				;if there is, new line and ebx set to zero
	mov ebx, 0
sameLine:
	inc ebx
	add esi, 4
	loop more
endMore:
	call CrLf
	pop ebp
	ret 8
displayList ENDP

END main
