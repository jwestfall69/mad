	; struct input {
	;   byte y
	;   word io# | mmio
	; }
	macro INPUT_ENTRY
		dc.b \1
		dc.w \2
	endm

	macro INPUT_LIST_END
		dc.b $0
	endm
