	include "cpu/68000/include/dsub.inc"

	global print_input_list

	section code

; params:
;  a0 = address of start of INPUT_ENTRY struct list
print_input_list:
		move.w	(a0)+, d1
		beq	.list_end

		and.l	#$ff, d1
		moveq	#6, d0
		RSUB	screen_seek_xy

		move.l	(a0)+, a1
		move.b	(a1), d0

		; should this not.b a param option?
		not.b	d0

		RSUB	print_bits_byte
		bra	print_input_list

	.list_end:
		rts
