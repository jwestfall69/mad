	; struct input {
	;   byte y
	;   long input_address
	; }
	macro INPUT_ENTRY
		dc.w \1
		dc.l \2
	endm

	macro INPUT_LIST_END
		dc.w $0
	endm
