	include "cpu/68000/include/common.inc"

	global ram_find
	global ram_find_none

	section code
; Ideally you should do ram_find_none first, make note of all the
; ram chips that aren't being written to.  Then use of ram_find
; to identify which ram chip starts getting written to for a given
; address.


; This is to help track down what ram chip is assoicated with a given
; address.  This is done by writing to the passed address over and
; over, with the expectation you use a logic probe to see what ram
; chip is being writing to.
; params:
;  a0 = address to write to
ram_find:
		move.l	a0, a1

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list
		jsr	print_b2_return_to_menu

		SEEK_XY (SCREEN_START_X + 11), (SCREEN_START_Y + 3)
		move.l	a1, d0
		RSUB	print_hex_3_bytes

	.loop_write:
		WATCHDOG

		move.b	#$55, (a1)

		GET_INPUT

		btst	#INPUT_B2_BIT, d0
		beq	.loop_write
		rts


; This loops and doesn't write to any ram so is possible to
; verify a ram chip isn't being written to by something other
; then the CPU. 
ram_find_none:
		lea	d_screen_xys_list_none, a0
		RSUB	print_xy_string_list
		jsr	print_b2_return_to_menu

	.loop_none:
		WATCHDOG

		GET_INPUT

		btst	#INPUT_B2_BIT, d0
		beq	.loop_none
		rts


	section data
	align 1

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "REPEATEDLY WRITING 55"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "TO ADDRESS"
	XY_STRING_LIST_END

d_screen_xys_list_none:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "NOT WRITTING TO ANY"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "MEMORY"
	XY_STRING_LIST_END
