	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"
	include "global/include/screen.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"

	global auto_txt_ram_tests
	global manual_txt_ram_tests

	section code

; txt ram seems to have issues with the march test, in that
; it will randomly fail after passing a number of times.  This
; has been confirmed on multiple boards. For now we will just
; not do the march test.  I'm somewhat assuming there is a
; conflicted between the cpu accessing and the custom chip
; accessing the ram
auto_txt_ram_tests:

		lea	d_mt_data, a0
		DSUB	memory_tests_no_march_handler
		rts

manual_txt_ram_tests:

		; no point in printing out the SCREEN_XY_LIST
		; since it will be wiped out soon as testing
		; starts. Same with printing the number of
		; passes before each test

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

		jsr	auto_txt_ram_tests
		tst.b	d0
		bne	.test_failed

		addq.l	#1, d6

		btst	#INPUT_B2_BIT, REG_INPUT
		beq	.test_exit

		btst	#INPUT_B1_BIT, REG_INPUT
		beq	.test_pause
		bra	.loop_next_pass

	.test_failed:
		RSUB	error_handler
		STALL

	.test_pause:
		RSUB	screen_init

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		move.l	d6, d0
		RSUB	print_hex_long

		moveq	#INPUT_B1_BIT, d0
		RSUB	wait_button_release

		bra	.loop_next_pass

	.test_exit:
		rts

	section data
	align 2

d_mt_data:
	MT_PARAMS TXT_RAM_START, MT_NULL_ADDRESS_LIST, TXT_RAM_SIZE, TXT_RAM_ADDRESS_LINES, TXT_RAM_MASK, MT_TEST_BOTH, TXT_RAM_BASE_EC

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "TXT RAM TEST"
	XY_STRING SCREEN_START_X, SCREEN_PASSES_Y, "PASSES"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PAUSE"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
