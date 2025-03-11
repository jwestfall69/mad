	; struct input {
	;   byte y
	;   byte io#
	; }
	macro INPUT_ENTRY
		dc.b \1
		dc.b \2
	endm

	macro INPUT_LIST_END
		dc.b $0
	endm
