	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"

	include "error_codes.inc"
	include "machine.inc"
	include "mad_rom.inc"

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
		PSUB_INIT

	.loop_next_pass:

		PSUB	auto_ram_tests
		tst.b	d0
		bne	.test_failed

		SCREEN_UPDATE

		addq.l	#1, d6

		btst	#P1_B1_BIT, REG_INPUT_P1
		beq	.test_pause

		btst	#P1_B2_BIT, REG_INPUT_P1
		beq	.test_exit

		bra	.loop_next_pass

	.test_pause:
		PSUB	screen_init

		lea	d_screen_xys_list, a0
		PSUB	print_xy_string_list

		SEEK_XY	12, 10
		move.l	d6, d0
		PSUB	print_hex_long

	.loop_paused:
		btst	#P1_B1_BIT, REG_INPUT_P1
		beq	.loop_paused
		bra	.loop_next_pass

	.test_failed:
		PSUB	error_handler
		STALL

	.test_exit:
		RSUB_INIT
		INTS_ENABLE
		clr.b	r_menu_cursor
		bra	main_menu

	section data
	align 2

d_mt_data:
	MT_PARAMS RAM_START, MT_NULL_ADDRESS_LIST, RAM_SIZE, RAM_ADDRESS_LINES, RAM_MASK, MT_TEST_BOTH, RAM_BASE_EC

d_screen_xys_list:
	XY_STRING 3,  4, "RAM TEST"
	XY_STRING 3, 10, "PASSES"
	XY_STRING 3, 19, "B1 - PAUSE"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

d_str_ram_test:		STRING "RAM TEST"
