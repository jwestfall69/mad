	; struct input {
	;   byte y
	;   word input_address
	; }
	macro INPUT_ENTRY
		dfb \1
		dfw \2
	endm

	macro INPUT_LIST_END
		dfb $0
	endm
