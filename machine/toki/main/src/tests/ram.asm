	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global auto_ram_tests_dsub
	global manual_ram_tests

	section code

auto_ram_tests_dsub:
		lea	d_mt_data, a0
		bra	memory_tests_handler_dsub

manual_ram_tests:

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		moveq	#0, d6		; passes, memory tests don't touch it

		INTS_DISABLE
		DSUB_MODE_PSUB

	.loop_next_pass:

		PSUB	auto_ram_tests
		tst.b	d0
		bne	.test_failed

		addq.l	#1, d6

		SCREEN_UPDATE

		btst	#INPUT_B1_BIT, REG_INPUT
		beq	.test_pause

		btst	#INPUT_B2_BIT, REG_INPUT
		beq	.test_exit
		bra	.loop_next_pass

	.test_pause:
		PSUB	screen_init

		lea	d_screen_xys_list, a0
		PSUB	print_xy_string_list

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		move.l	d6, d0
		PSUB	print_hex_long

		moveq	#INPUT_B1_BIT, d0
		PSUB	wait_button_release

		bra	.loop_next_pass

	.test_failed:
		PSUB	error_handler
		STALL

	.test_exit:
		DSUB_MODE_RSUB
		INTS_ENABLE
		clr.b	r_menu_cursor
		bra	main_menu

	section data
	align 1

d_mt_data:
	MT_PARAMS RAM, MT_NULL_ADDRESS_LIST, RAM_SIZE, RAM_ADDRESS_LINES, RAM_MASK, RAM_BASE_EC, MT_FLAG_NONE

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "RAM TEST"
	XY_STRING SCREEN_START_X, SCREEN_PASSES_Y, "PASSES"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PAUSE"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

d_str_ram_test:		STRING "RAM TEST"
