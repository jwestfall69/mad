	include "cpu/6x09/include/common.inc"

	global input_test_handler

	section code

INPUT_X_OFFSET		equ SCREEN_START_X + 5
INPUT_Y_OFFSET		equ SCREEN_START_Y + 3

; params:
;  x = INPUT_TEST_ENTRY list
;  y = loop callback
input_test_handler:
		stx	(r_input_list)
		sty	(r_loop_cb)

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

	.loop_input_test:
		WATCHDOG

		ldy	(r_input_list)
		jsr	print_input_list

		jsr	[r_loop_cb]

		; avoid input_update because it calls delay
		; which causes problems with vbp counters
		lda	REG_INPUT
		coma

		anda	#(INPUT_B2|INPUT_RIGHT)
		cmpa	#(INPUT_B2|INPUT_RIGHT)
		bne	.loop_input_test
		rts

; params:
;  y = INPUT_TEST_ENTRY list
print_input_list:
		lda	#INPUT_Y_OFFSET
		sta	(r_print_line)

	.loop_next_entry:
		ldd	, y
		beq	.list_end

		lda	#INPUT_X_OFFSET
		ldb	(r_print_line)
		RSUB	screen_seek_xy

		lda	[, y++]
		coma
		pshs	y
		RSUB	print_bits_byte
		puls	y
		inc	(r_print_line)
		bra	.loop_next_entry

	.list_end:
		rts


d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 5), (SCREEN_START_Y + 2), "76543210"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "EXIT  HOLD R B2"
	XY_STRING_LIST_END


	section bss

r_input_list:		dcb.w 1
r_loop_cb:		dcb.w 1
r_print_line:		dcb.b 1
