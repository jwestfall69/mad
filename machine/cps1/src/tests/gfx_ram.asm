	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/xy_string.inc"
	include "cpu/68000/handlers/memory_tests.inc"
	include "cpu/68000/tests/memory.inc"

	include "diag_rom.inc"
	include "error_codes.inc"
	include "machine.inc"

	global auto_gfx_ram_tests
	global manual_gfx_ram_tests

	section code

auto_gfx_ram_tests:
		lea	MT_DATA, a0
		DSUB	memory_tests_handler
		rts

manual_gfx_ram_tests:

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

		bsr	auto_gfx_ram_tests
		tst.b	d0
		bne	.test_failed

		btst	#P1_B1_BIT, REG_INPUT_P1
		beq	.test_pause

		btst	#P1_B2_BIT, REG_INPUT_P1
		beq	.test_exit

		addq.l	#1, d6

		bra	.loop_next_pass

	.test_pause:
		RSUB	screen_init

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		SEEK_XY	12, 10
		move.l	d6, d0
		RSUB	print_hex_long

	.loop_paused:
		btst	#P1_B1_BIT, REG_INPUT_P1
		beq	.loop_paused
		bra	.loop_next_pass

	.test_failed:
		RSUB	error_handler
		STALL

	.test_exit:
		rts

	section data

	align 2

; fix me based on ram chips
MEMORY_ADDRESS_LIST:
	MEMORY_ADDRESS_ENTRY GFX_RAM_START
	MEMORY_ADDRESS_LIST_END

MT_DATA:
	MT_PARAMS GFX_RAM_START, MEMORY_ADDRESS_LIST, GFX_RAM_SIZE, GFX_RAM_ADDRESS_LINES, GFX_RAM_MASK, $0, GFX_RAM_BASE_EC

SCREEN_XYS_LIST:
	XY_STRING 3,  4, "GFX RAM TEST"
	XY_STRING 3, 10, "PASSES"
	XY_STRING 3, 19, "B1 - PAUSE"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
