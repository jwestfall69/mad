	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"
	include "global/include/screen.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global auto_work_ram_tests_dsub
	global manual_work_ram_tests

	section code

auto_work_ram_tests_dsub:

		; do to nesting depth issues we need to directly
		; branch to the handler and let it do the DSUB_RETURN
		lea	d_mt_data, a0
		bra	memory_tests_handler_dsub

manual_work_ram_tests:

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		moveq	#0, d6		; passes, memory tests don't touch it
		DSUB_MODE_PSUB

	.loop_next_pass:
		WATCHDOG

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		move.l	d6, d0
		PSUB	print_hex_long

		PSUB	auto_work_ram_tests
		tst.b	d0
		bne	.test_failed

		btst	#INPUT_B2_BIT, REG_INPUT
		beq	.test_exit

		addq.l	#1, d6

		bra	.loop_next_pass

	.test_failed:
		PSUB	error_handler
		STALL

	.test_exit:
		DSUB_MODE_RSUB
		clr.b	r_menu_cursor
		bra	main_menu

	section data
	align 1

d_mt_data:
	MT_PARAMS WORK_RAM, MT_NULL_ADDRESS_LIST, WORK_RAM_SIZE, WORK_RAM_ADDRESS_LINES, WORK_RAM_MASK, WORK_RAM_BASE_EC, MT_FLAG_NONE

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_PASSES_Y, "PASSES"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
