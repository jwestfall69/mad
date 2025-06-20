	include "global/include/screen.inc"
	include "cpu/6309/include/dsub.inc"

	include "machine.inc"

	global print_input_list

	section code

; params:
;  y = address of start of INPUT_ENTRY struct list
print_input_list:
		WATCHDOG
		ldb	, y+
		beq	.list_end

		lda	#(SCREEN_START_X + 5)
		RSUB	screen_seek_xy

		lda	[, y++]
		coma
		RSUB	print_bits_byte
		bra	print_input_list

	.list_end:
		rts
