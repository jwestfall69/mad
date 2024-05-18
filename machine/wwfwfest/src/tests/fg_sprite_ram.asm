	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"

	include "error_codes.inc"
	include "machine.inc"

	global auto_fg_sprite_ram_tests
	global manual_fg_sprite_ram_tests

	section code

; fg ram is only 8 bit
auto_fg_sprite_ram_tests:

		lea	MT_DATA, a0
		DSUB	memory_tests_handler
		rts

manual_fg_sprite_ram_tests:

		; no point in printing out the SCREEN_XY_LIST
		; since it will be wiped out soon as testing
		; starts. Same with printing the number of
		; passes before each test

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

		jsr	auto_fg_sprite_ram_tests
		tst.b	d0
		bne	.test_failed

		btst	#P1_B2_BIT, REG_INPUT_P1
		beq	.test_exit

		btst	#P1_B1_BIT, REG_INPUT_P1
		beq	.test_pause

		addq.l	#1, d6

		bra	.loop_next_pass

	.test_failed:
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

	align 2
MT_DATA:
	MT_PARAMS FG_SPRITE_RAM_START, MT_NULL_ADDRESS_LIST, FG_SPRITE_RAM_SIZE, FG_SPRITE_RAM_ADDRESS_LINES, FG_SPRITE_RAM_MASK, MT_TEST_LOWER_ONLY, FG_SPRITE_RAM_BASE_EC

SCREEN_XYS_LIST:
	XY_STRING 3,  4, "FG/SPRITE RAM TEST"
	XY_STRING 3, 10, "PASSES"
	XY_STRING 3, 19, "B1 - PAUSE"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
