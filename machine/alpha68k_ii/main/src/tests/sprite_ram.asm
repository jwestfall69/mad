	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"

	global auto_sprite_ram_tests
	global manual_sprite_ram_tests

	section code

; sprite ram tests needs some work to properly test the ram.  It consists
; of 3x 8bit ram chips, where the upper byte in every long is not connected.
;  xxxx 2222 1111 0000
; Its going to require custom tests/errors to support it, where we would have
; an upper, middle and lower error codes.  For not its just checking the lower
; byte, which covers 2 of the 3 ram chips.
auto_sprite_ram_tests:
		lea	d_mt_data, a0
		DSUB	memory_tests_handler
		rts

manual_sprite_ram_tests:

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		move.l	d6, d0
		RSUB	print_hex_long

		jsr	auto_sprite_ram_tests
		tst.b	d0
		bne	.test_failed

		addq.l	#1, d6

		btst	#INPUT_B2_BIT, REG_INPUT
		beq	.test_exit
		bra	.loop_next_pass

	.test_failed:
		RSUB	error_handler
		STALL

	.test_exit:
		rts

	section data
	align 1

d_mt_data:
	MT_PARAMS SPRITE_RAM, MT_NULL_ADDRESS_LIST, SPRITE_RAM_SIZE, SPRITE_RAM_ADDRESS_LINES, SPRITE_RAM_MASK, SPRITE_RAM_BASE_EC, MT_FLAG_LOWER_ONLY

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_PASSES_Y, "PASSES"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
