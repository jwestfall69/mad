	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/tests/memory.inc"
	include "cpu/68000/xy_string.inc"

	include "error_codes.inc"
	include "machine.inc"

	global auto_bg_ram_tests
	global manual_bg_ram_tests

	section code

	; bg ram is only 8 bit
auto_bg_ram_tests:
		lea	BG_RAM_START, a0
		moveq	#1, d0
		RSUB	memory_output_test
		tst.b	d0
		bne	.test_failed_output

		lea	BG_RAM_START, a0
		moveq	#1, d0
		RSUB	memory_write_test
		tst.b	d0
		bne	.test_failed_write

		lea	BG_RAM_START, a0
		move.w	#BG_RAM_SIZE, d0
		move.w	#$ff, d1
		RSUB	memory_data_test
		tst.b	d0
		bne	.test_failed_data

		lea	BG_RAM_START, a0
		move.w	#BG_RAM_ADDRESS_LINES, d0
		move.w	#$ff, d1
		RSUB	memory_address_test
		tst.b	d0
		bne	.test_failed_address
		rts

		lea	BG_RAM_START, a0
		move.w	#BG_RAM_SIZE, d0
		move.w	#$ff, d1
		RSUB	memory_march_test
		tst.b	d0
		bne	.test_failed_march


	.test_failed_address:
		moveq	#EC_BG_RAM_ADDRESS, d0
		rts

	.test_failed_data:
		subq.b	#1, d0
		add.b	#EC_BG_RAM_DATA_LOWER, d0
		rts

	.test_failed_march:
		subq.b	#1, d0
		add.b	#EC_BG_RAM_MARCH_LOWER, d0
		rts

	.test_failed_output:
		subq.b	#1, d0
		add.b	#EC_BG_RAM_OUTPUT_LOWER, d0
		rts

	.test_failed_write:
		subq.b	#1, d0
		add.b	#EC_BG_RAM_WRITE_LOWER, d0
		rts

manual_bg_ram_tests:

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

		SEEK_XY	12, 10
		move.l	d6, d0
		RSUB	print_hex_long

		jsr	auto_bg_ram_tests
		tst.b	d0
		bne	.test_failed

		btst	#P1_B2_BIT, REG_INPUT_P1
		beq	.test_exit

		addq.l	#1, d6

		bra	.loop_next_pass

	.test_failed:

		movem.l	d0-d2/a0-a1, -(a7)
		RSUB	screen_init
		movem.l	(a7)+, d0-d2/a0-a1

		RSUB	error_handler
		STALL

	.test_exit:
		bra	main_menu

	section data

SCREEN_XYS_LIST:
	XY_STRING 3,  4, "BG RAM TEST"
	XY_STRING 3, 10, "PASSES"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
