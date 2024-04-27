	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/memory_fill.inc"
	include "cpu/68000/tests/memory.inc"
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

	ifd	_MAME_BUILD_
		rts
	endif

		lea	MEMORY_ADDRESS_LIST, a0
		moveq	#1, d0
		DSUB	memory_output_list_test
		tst.b	d0
		bne	.test_failed_output

		lea	MEMORY_ADDRESS_LIST, a0
		moveq	#1, d0
		DSUB	memory_write_list_test
		tst.b	d0
		bne	.test_failed_write

		lea	PALETTE_RAM_START, a0
		move.w	#PALETTE_RAM_SIZE, d0
		move.w	#$fff, d1
		DSUB	memory_data_test
		tst.b	d0
		bne	.test_failed_data

		lea	PALETTE_RAM_START, a0
		move.w	#PALETTE_RAM_SIZE, d0
		move.w	#$fff, d1
		DSUB	memory_march_test
		tst.b	d0
		bne	.test_failed_march

		lea	PALETTE_RAM_START, a0
		move.w	#PALETTE_RAM_ADDRESS_LINES, d0
		move.w	#$ff, d1
		RSUB	memory_address_test
		tst.b	d0
		bne	.test_failed_address
		bra	.fix_palette


	.test_failed_address:
		moveq	#EC_PALETTE_RAM_ADDRESS, d0
		bra	.fix_palette

	.test_failed_data:
		subq.b	#1, d0
		add.b	#EC_PALETTE_RAM_DATA_LOWER, d0
		bra	.fix_palette

	.test_failed_march:
		subq.b	#1, d0
		add.b	#EC_PALETTE_RAM_MARCH_LOWER, d0
		bra	.fix_palette

	.test_failed_output:
		subq.b	#1, d0
		add.b	#EC_PALETTE_RAM_OUTPUT_LOWER, d0
		bra	.fix_palette

	.test_failed_write:
		subq.b	#1, d0
		add.b	#EC_PALETTE_RAM_WRITE_LOWER, d0
		bra	.fix_palette

	; do just enough to fix text on screen
	.fix_palette:
		move.w	#$0f00, PALETTE_RAM_START + $18 	; text
		move.w	#$0111, PALETTE_RAM_START + $2		; text shadow
		move.w	#$0000, PALETTE_RAM_START + $200	; background
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
		RSUB	error_handler
		STALL

	.test_exit:
		bra	main_menu

	section data

SCREEN_XYS_LIST:
	XY_STRING  3, 10, "PASSES"
	ifd _MAME_BUILD_
	XY_STRING  3, 14, "MAME BUILD - TEST DISABLED"
	else
	XY_STRING  3, 14, "EXPECT ROLLING COLORS"
	endif
	XY_STRING  3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

	align 2
MEMORY_ADDRESS_LIST:
        MEMORY_ADDRESS_ENTRY PALETTE_RAM_START
        MEMORY_ADDRESS_LIST_END
