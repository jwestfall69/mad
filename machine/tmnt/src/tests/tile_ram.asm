	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"

	include "error_codes.inc"
	include "machine.inc"

	global auto_tile_ram_tests
	global manual_tile_ram_tests

	section code

; tile ram is only 8 bit
auto_tile_ram_tests:

		lea	MT_DATA1, a0
		DSUB	memory_byte_tests_handler
		tst.b	d0
		bne	.test_failed

		lea	MT_DATA2, a0
		DSUB	memory_byte_tests_handler
		tst.b	d0
		bne	.test_failed

		lea	MT_DATA3, a0
		DSUB	memory_byte_tests_handler
		tst.b	d0
		bne	.test_failed

		;lea	MT_DATA4, a0
		;DSUB	memory_byte_tests_handler
		;tst.b	d0
		;bne	.test_failed
		rts

	.test_failed:
		rts

manual_tile_ram_tests:

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:
		WATCHDOG

		jsr	auto_tile_ram_tests
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
MT_DATA1:
;	MT_PARAMS TILE_RAM_START, MT_NULL_ADDRESS_LIST, TILE_RAM_SIZE, TILE_RAM_ADDRESS_LINES, TILE_RAM_MASK, MT_TEST_LOWER_ONLY, TILE_RAM_BASE_EC
	MT_PARAMS TILE_RAM_START, MT_NULL_ADDRESS_LIST, $1000, 12, TILE_RAM_MASK, MT_TEST_BOTH, TILE_RAM_BASE_EC
MT_DATA2:
	MT_PARAMS TILE_RAM_START+$2000, MT_NULL_ADDRESS_LIST, $1000, 12, TILE_RAM_MASK, MT_TEST_BOTH, TILE_RAM_BASE_EC
MT_DATA3:
	MT_PARAMS TILE_RAM_START+$4000, MT_NULL_ADDRESS_LIST, $1000, 12, TILE_RAM_MASK, MT_TEST_BOTH, TILE_RAM_BASE_EC
MT_DATA4:
	MT_PARAMS TILE_RAM_START+$6000, MT_NULL_ADDRESS_LIST, $800, 12, TILE_RAM_MASK, MT_TEST_BOTH, TILE_RAM_BASE_EC

SCREEN_XYS_LIST:
	XY_STRING 3,  4, "TILE RAM TEST"
	XY_STRING 3, 10, "PASSES"
	XY_STRING 3, 19, "B1 - PAUSE"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
