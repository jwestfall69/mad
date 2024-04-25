	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/tests/memory.inc"
	include "cpu/68000/xy_string.inc"

	include "diag_rom.inc"
	include "error_codes.inc"
	include "machine.inc"

	global auto_gfx_ram_tests
	global manual_gfx_ram_tests

	section code

auto_gfx_ram_tests:
		lea	MEMORY_ADDRESS_LIST, a0
		moveq	#0, d0
		RSUB	memory_output_list_test
		tst.b	d0
		bne	.test_failed_output

		lea	MEMORY_ADDRESS_LIST, a0
		moveq	#0, d0
		RSUB	memory_write_list_test
		tst.b	d0
		bne	.test_failed_write

		lea	GFX_RAM_START, a0
		move.l	#GFX_RAM_SIZE, d0
		move.w	#$ffff, d1
		RSUB	memory_data_test
		tst.b	d0
		bne	.test_failed_data

		lea	GFX_RAM_START, a0
		move.w	#GFX_RAM_ADDRESS_LINES, d0
		move.w	#$ffff, d1
		RSUB	memory_address_test
		tst.b	d0
		bne	.test_failed_address

		lea	GFX_RAM_START, a0
		move.l	#GFX_RAM_SIZE, d0
		move.w	#$ffff, d1
		RSUB	memory_march_test
		tst.b	d0
		bne	.test_failed_march
		rts

	.test_failed_address:
		moveq	#EC_GFX_RAM_ADDRESS, d0
		rts

	.test_failed_data:
		subq.b	#1, d0
		add.b	#EC_GFX_RAM_DATA_LOWER, d0
		rts

	.test_failed_march:
		subq.b	#1, d0
		add.b	#EC_GFX_RAM_MARCH_LOWER, d0
		rts

	.test_failed_output:
		subq.b	#1, d0
		add.b	#EC_GFX_RAM_OUTPUT_LOWER, d0
		rts

	.test_failed_write:
		subq.b	#1, d0
		add.b	#EC_GFX_RAM_WRITE_LOWER, d0
		rts



manual_gfx_ram_tests:

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

		SEEK_XY	12, 10
		move.l	d6, d0
		RSUB	print_hex_long


		bsr	auto_gfx_ram_tests
		tst.b	d0
		bne	.test_failed

		btst	#P1_B2_BIT, REG_INPUT_P1
		beq	.test_exit

		addq.l	#1, d6

		bra	.loop_next_pass

	.test_failed:
		RSUB	error_handler

	.test_exit:
		bra	main_menu

	section data

SCREEN_XYS_LIST:
	XY_STRING  3, 10, "PASSES"
	XY_STRING  3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

; fix me based on ram chips
	align 2
MEMORY_ADDRESS_LIST:
        MEMORY_ADDRESS_ENTRY GFX_RAM_START
        MEMORY_ADDRESS_LIST_END
