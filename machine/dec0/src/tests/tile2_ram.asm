	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/xy_string.inc"
	include "cpu/68000/handlers/memory_tests.inc"
	include "cpu/68000/tests/memory.inc"

	include "diag_rom.inc"
	include "error_codes.inc"
	include "machine.inc"

	global auto_tile2_ram_tests
	global manual_tile2_ram_tests

	section code

auto_tile2_ram_tests:

	; mame doesn't allow reading all of the ram
	ifd _MAME_BUILD_
		rts
	endif

		lea 	MT_DATA, a0
		RSUB	memory_tests_handler
		rts

manual_tile2_ram_tests:

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		moveq	#0, d6		; passes, memory tests don't touch it
	.loop_next_pass:

		SEEK_XY	12, 10
		move.l	d6, d0
		RSUB	print_hex_long

		jsr	auto_tile2_ram_tests
		tst.b	d0
		bne	.test_failed

		btst	#P1_B2_BIT, REG_INPUT_P1
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
	MT_PARAMS TILE2_RAM_START, MT_NULL_ADDRESS_LIST, TILE2_RAM_SIZE, TILE2_RAM_ADDRESS_LINES, TILE2_RAM_MASK, MT_TEST_BOTH, TILE2_RAM_BASE_EC

SCREEN_XYS_LIST:
	XY_STRING 3, 10, "PASSES"
	ifd _MAME_BUILD_
		XY_STRING 3, 14, "MAME BUILD - TEST DISABLED"
	endif
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
