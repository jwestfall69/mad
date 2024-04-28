	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/tests/memory.inc"
	include "cpu/68000/xy_string.inc"

	include "error_codes.inc"
	include "machine.inc"

	global auto_sprite_ram_tests
	global manual_sprite_ram_tests

	section code

	; sprite ram is only 8 bit
auto_sprite_ram_tests:
		lea	SPRITE_RAM_START, a0
		moveq	#1, d0
		RSUB	memory_output_test
		tst.b	d0
		bne	.test_failed_output

		lea	SPRITE_RAM_START, a0
		moveq	#1, d0
		RSUB	memory_write_test
		tst.b	d0
		bne	.test_failed_write

		lea	SPRITE_RAM_START, a0
		move.w	#SPRITE_RAM_SIZE, d0
		move.w	#$ff, d1
		RSUB	memory_data_test
		tst.b	d0
		bne	.test_failed_data

		lea	SPRITE_RAM_START, a0
		move.w	#SPRITE_RAM_ADDRESS_LINES, d0
		move.w	#$ff, d1
		RSUB	memory_address_test
		tst.b	d0
		bne	.test_failed_address
		rts

		lea	SPRITE_RAM_START, a0
		move.w	#SPRITE_RAM_SIZE, d0
		move.w	#$ff, d1
		RSUB	memory_march_test
		tst.b	d0
		bne	.test_failed_march


	.test_failed_address:
		moveq	#EC_SPRITE_RAM_ADDRESS, d0
		rts

	.test_failed_data:
		moveq	#EC_SPRITE_RAM_DATA, d0
		rts

	.test_failed_march:
		moveq	#EC_SPRITE_RAM_MARCH, d0
		rts

	.test_failed_output:
		moveq	#EC_SPRITE_RAM_OUTPUT, d0
		rts

	.test_failed_write:
		moveq	#EC_SPRITE_RAM_WRITE, d0
		rts

manual_sprite_ram_tests:

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

		SEEK_XY	12, 10
		move.l	d6, d0
		RSUB	print_hex_long

		jsr	auto_sprite_ram_tests
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
		rts

	section data

SCREEN_XYS_LIST:
	XY_STRING 3,  4, "SPRITE RAM TEST"
	XY_STRING 3, 10, "PASSES"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
