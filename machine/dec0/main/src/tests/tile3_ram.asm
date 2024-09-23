	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"
	include "cpu/68000/include/tests/memory.inc"
	include "global/include/screen.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"
	include "mad_rom.inc"

	global auto_tile3_ram_tests
	global manual_tile3_ram_tests

	section code

auto_tile3_ram_tests:

	ifd _MAME_BUILD_
		rts
	endif

		lea 	d_mt_data, a0
		RSUB	memory_tests_handler
		rts

manual_tile3_ram_tests:

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		moveq	#0, d6		; passes, memory tests don't touch it
	.loop_next_pass:

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		move.l	d6, d0
		RSUB	print_hex_long

		jsr	auto_tile3_ram_tests
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
	align 2

d_mt_data:
	MT_PARAMS TILE3_RAM_START, MT_NULL_ADDRESS_LIST, TILE3_RAM_SIZE, TILE3_RAM_ADDRESS_LINES, TILE3_RAM_MASK, MT_TEST_BOTH, TILE3_RAM_BASE_EC

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_PASSES_Y, "PASSES"
	ifd _MAME_BUILD_
		XY_STRING SCREEN_START_X, (SCREEN_PASSES_Y + 2), "MAME BUILD - TEST DISABLED"
	endif
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
