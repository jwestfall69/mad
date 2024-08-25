	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"

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
		lea	MT_DATA, a0
		DSUB	memory_tests_handler
		rts

manual_sprite_ram_tests:

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

		SEEK_XY	12, 10
		move.l	d6, d0
		RSUB	print_hex_long

		jsr	auto_sprite_ram_tests
		tst.b	d0
		bne	.test_failed

		btst	#INPUT_B2_BIT, REG_INPUT
		beq	.test_exit

		addq.l	#1, d6

		bra	.loop_next_pass

	.test_failed:
		RSUB	error_handler
		STALL

	.test_exit:
		rts

	section data

	align 2

MT_DATA:
	MT_PARAMS SPRITE_RAM_START, MT_NULL_ADDRESS_LIST, SPRITE_RAM_SIZE, SPRITE_RAM_ADDRESS_LINES, SPRITE_RAM_MASK, MT_TEST_LOWER_ONLY, SPRITE_RAM_BASE_EC

SCREEN_XYS_LIST:
	XY_STRING 3,  4, "SPRITE RAM TEST"
	XY_STRING 3, 10, "PASSES"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
