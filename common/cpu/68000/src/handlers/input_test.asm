	include "cpu/68000/include/common.inc"

	global input_test_handler

	section code

INPUT_X_OFFSET		equ SCREEN_START_X + 5
INPUT_Y_OFFSET		equ SCREEN_START_Y + 3

; params:
;  a0 = INPUT_TEST_ENTRY list
;  a1 = loop callback
input_test_handler:
		move.l	a0, r_input_list
		move.l	a1, r_loop_cb

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

	.loop_input_test:
		WATCHDOG

		move.l	r_input_list, a0
		jsr	print_input_list

		move.l	r_loop_cb, a0
		jsr	(a0)

		; avoid input_update because it calls delay
		; which causes problems with vbp counters
		move.b	REG_INPUT, d0
		not.b	d0

		cmp.b	#(INPUT_B2|INPUT_RIGHT), d0
		bne	.loop_input_test
		rts

; params:
;  a0 = INPUT_TEST_ENTRY list
print_input_list:

		moveq	#INPUT_Y_OFFSET, d3

	.loop_next_entry:
		move.l	(a0), d0
		beq	.list_end

		move.b	d3, d1
		moveq	#INPUT_X_OFFSET, d0
		RSUB	screen_seek_xy

		move.l	(a0)+, a1
		move.b	(a1), d0

		not.b	d0

		RSUB	print_bits_byte

		addq.b	#$1, d3
		bra	.loop_next_entry


	.list_end:
		rts

	section data
	align 1

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 5), (SCREEN_START_Y + 2), "76543210"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "EXIT  HOLD R B2"
	XY_STRING_LIST_END


	section bss
	align 1

r_input_list:		dcb.l 1
r_loop_cb:		dcb.l 1
