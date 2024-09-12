	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"
	include "cpu/68000/include/tests/memory.inc"

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
		SEEK_XY	12, 10
		move.l	d6, d0
		RSUB	print_hex_long
	endif

		jsr	auto_tile1_ram_tests
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

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		SEEK_XY 12, 10
		move.l	d6, d0
		RSUB	print_hex_long

	.loop_paused:
		btst	#INPUT_B1_BIT, REG_INPUT
		beq	.loop_paused
		bra	.loop_next_pass


	.test_exit:

		rts

	section data
	align 2

d_mt_data:
	MT_PARAMS TILE1_RAM_START, MT_NULL_ADDRESS_LIST, TILE1_RAM_SIZE, TILE1_RAM_ADDRESS_LINES, TILE1_RAM_MASK, MT_TEST_BOTH, TILE1_RAM_BASE_EC

d_screen_xys_list:
	XY_STRING 3,  4, "TILE1 RAM TEST"
	XY_STRING 3, 10, "PASSES"
	ifd _MAME_BUILD_
		XY_STRING 3, 14, "MAME BUILD - TEST DISABLED"
	endif
	XY_STRING 3, 19, "B1 - PAUSE"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
