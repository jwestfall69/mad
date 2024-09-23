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

	global auto_tile1_ram_tests
	global manual_tile1_ram_tests

	section code

auto_tile1_ram_tests:

	; mame doesn't allow reading all of the ram
	ifd _MAME_BUILD_
		rts
	endif

		lea 	d_mt_data, a0
		RSUB	memory_tests_handler
		rts

manual_tile1_ram_tests:

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

	; on real hardware screen will be black
	; during testing, but on a mame build have
	; it print the pass count
	ifd _MAME_BUILD_
		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		move.l	d6, d0
		RSUB	print_hex_long
	endif

		jsr	auto_tile1_ram_tests
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

		SEEK_XY SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
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
	MT_PARAMS TILE1_RAM_START, MT_NULL_ADDRESS_LIST, TILE1_RAM_SIZE, TILE1_RAM_ADDRESS_LINES, TILE1_RAM_MASK, MT_TEST_BOTH, TILE1_RAM_BASE_EC

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "TILE1 RAM TEST"
	XY_STRING SCREEN_START_X, SCREEN_PASSES_Y, "PASSES"
	ifd _MAME_BUILD_
		XY_STRING SCREEN_START_X, (SCREEN_PASSES_Y + 2), "MAME BUILD - TEST DISABLED"
	endif
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PAUSE"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
