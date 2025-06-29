	; start_addr, size, byte_value
	macro MEMORY_FILL8
		ldy	\1
		ldx	\2
		lda	\3
	.\@:
		sta	,y+
		dxjnz	.\@
	endm

	; start_addr, size, word_value
	macro MEMORY_FILL16
		ldy	\1
		ldx	\2
		ldd	\3
	.\@:
		std	,y++
		dxjnz	.\@
	endm

	; char, count
	; x should already be at video ram location
	macro CHAR_REPEAT
		lda	\1
		ldb	\2
	.\@:
		sta	,x+
		dbjnz	.\@
	endm
