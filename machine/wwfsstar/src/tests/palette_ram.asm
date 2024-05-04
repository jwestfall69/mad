	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/memory_tests_handler.inc"
	include "cpu/68000/xy_string.inc"

	include "error_codes.inc"
	include "machine.inc"

	global auto_palette_ram_tests
	global manual_palette_ram_tests

	section code

; The high nibble of the upper byte in palette ram
; doesn't seem to be wired up to the cpu so it gets
; filled with random data.
auto_palette_ram_tests:

	; mame doesn't allow reading palette ram, so
	; we have to skip testing it
	ifnd _MAME_BUILD_
		lea	MT_DATA, a0
		DSUB	memory_tests_handler
	endif
		rts

manual_palette_ram_tests:

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

		SEEK_XY	12, 10
		move.l	d6, d0
		RSUB	print_hex_long


		jsr	auto_palette_ram_tests
		tst.b	d0
		bne	.test_failed

		btst	#P1_B2_BIT, REG_INPUT_P1
		beq	.test_exit

		addq.l	#1, d6

		bra	.loop_next_pass

	.test_failed:
		movem.l d0-d2/a0-a1, -(a7)
		RSUB	screen_init
		movem.l (a7)+, d0-d2/a0-a1

		RSUB	error_handler
		STALL

	.test_exit:
		rts

	section data

	align 2
MT_DATA:
	MT_PARAMS PALETTE_RAM_START, $0, PALETTE_RAM_SIZE, PALETTE_RAM_ADDRESS_LINES, PALETTE_RAM_MASK, $1, PALETTE_RAM_BASE_EC

SCREEN_XYS_LIST:
	XY_STRING 3, 10, "PASSES"
	ifd _MAME_BUILD_
	XY_STRING 3, 14, "MAME BUILD - TEST DISABLED"
	else
	XY_STRING 3, 14, "EXPECT ROLLING COLORS"
	endif
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
