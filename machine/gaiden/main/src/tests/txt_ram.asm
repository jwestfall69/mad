	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"

	global auto_txt_ram_tests
	global manual_txt_ram_tests

	section code

auto_txt_ram_tests:

		lea	MT_DATA, a0
		DSUB	memory_tests_handler
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

		btst	#INPUT_B2_BIT, REG_INPUT
		beq	.test_exit

		btst	#INPUT_B1_BIT, REG_INPUT
		beq	.test_pause

		addq.l	#1, d6

		bra	.loop_next_pass

	.test_failed:
		RSUB	error_handler
		STALL

	.test_pause:
		RSUB	screen_init

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		SEEK_XY	12, 10
		move.l	d6, d0
		RSUB	print_hex_long

	.loop_paused:
		WATCHDOG
		btst	#INPUT_B1_BIT, REG_INPUT
		beq	.loop_paused
		bra	.loop_next_pass

	.test_exit:
		rts

	section data

	align 2
MT_DATA:
	MT_PARAMS TXT_RAM_START, MT_NULL_ADDRESS_LIST, TXT_RAM_SIZE, TXT_RAM_ADDRESS_LINES, TXT_RAM_MASK, MT_TEST_BOTH, TXT_RAM_BASE_EC

SCREEN_XYS_LIST:
	XY_STRING 3,  4, "TXT RAM TEST"
	XY_STRING 3, 10, "PASSES"
	XY_STRING 3, 19, "B1 - PAUSE"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
