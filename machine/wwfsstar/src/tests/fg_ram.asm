	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/tests/memory.inc"
	include "cpu/68000/xy_string.inc"

	include "error_codes.inc"
	include "machine.inc"

	global auto_fg_ram_tests
	global manual_fg_ram_tests

	section code

	; fg ram is only 8 bit
auto_fg_ram_tests:
		lea	FG_RAM_START, a0
		moveq	#1, d0
		RSUB	memory_output_test
		tst.b	d0
		bne	.test_failed_output

		lea	FG_RAM_START, a0
		moveq	#1, d0
		RSUB	memory_write_test
		tst.b	d0
		bne	.test_failed_write

		lea	FG_RAM_START, a0
		move.w	#FG_RAM_SIZE, d0
		move.w	#$ff, d1
		RSUB	memory_data_test
		tst.b	d0
		bne	.test_failed_data

		lea	FG_RAM_START, a0
		move.w	#FG_RAM_ADDRESS_LINES, d0
		move.w	#$ff, d1
		RSUB	memory_address_test
		tst.b	d0
		bne	.test_failed_address

		lea	FG_RAM_START, a0
		move.w	#FG_RAM_SIZE, d0
		move.w	#$ff, d1
		RSUB	memory_march_test
		tst.b	d0
		bne	.test_failed_march
		rts

	.test_failed_address:
		moveq	#EC_FG_RAM_ADDRESS, d0
		rts

	.test_failed_data:
		moveq	#EC_FG_RAM_DATA, d0
		rts

	.test_failed_march:
		moveq	#EC_FG_RAM_MARCH, d0
		rts

	.test_failed_output:
		moveq	#EC_FG_RAM_OUTPUT, d0
		rts

	.test_failed_write:
		moveq	#EC_FG_RAM_WRITE, d0
		rts

manual_fg_ram_tests:

		; no point in printing out the SCREEN_XY_LIST
		; since it will be wiped out soon as testing
		; starts. Same with printing the number of
		; passes before each test

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

		jsr	auto_fg_ram_tests
		tst.b	d0
		bne	.test_failed

		btst	#P1_B2_BIT, REG_INPUT_P1
		beq	.test_exit

		btst	#P1_B1_BIT, REG_INPUT_P1
		beq	.test_pause

		addq.l	#1, d6

		bra	.loop_next_pass

	.test_failed:

		movem.l	d0-d2/a0-a1, -(a7)
		RSUB	screen_init
		movem.l	(a7)+, d0-d2/a0-a1

		RSUB	error_handler
		STALL

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

	.test_exit:
		rts

	section data

SCREEN_XYS_LIST:
	XY_STRING 3,  4, "FG RAM TEST"
	XY_STRING 3, 10, "PASSES"
	XY_STRING 3, 19, "B1 - PAUSE"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
