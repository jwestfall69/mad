	include "cpu/6309/include/psub.inc"

	include "machine.inc"

	global print_input_list

	section code

; params:
;  y = address of start of INPUT_ENTRY struct list
print_input_list:
		WATCHDOG
		ldb	, y+
		beq	.list_end

		lda	#$6
		PSUB	screen_seek_xy

		lda	[, y++]
		coma
		PSUB	print_bits_byte
		bra	print_input_list

	.list_end:
		rts
