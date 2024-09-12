	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"

	global auto_tile_ram_tests
	global manual_tile_ram_tests

	section code

auto_tile_ram_tests:

		lea	d_mt_data1, a0
		DSUB	memory_byte_tests_handler
		tst.b	d0
		bne	.test_failed

		lea	d_mt_data2, a0
		DSUB	memory_byte_tests_handler
		tst.b	d0
		bne	.test_failed

		lea	d_mt_data3, a0
		DSUB	memory_byte_tests_handler
		tst.b	d0
		bne	.test_failed

		;lea	d_mt_data4, a0
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

		btst	#INPUT_B2_BIT, REG_INPUT
		beq	.test_exit

		btst	#INPUT_B1_BIT, REG_INPUT
		beq	.test_pause

		addq.l	#1, d6

		bra	.loop_next_pass

	.test_failed:
		RSUB	error_handler
		STALL

	.test_pause:
		RSUB	screen_init

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		SEEK_XY	12, 10
		move.l	d6, d0
		RSUB	print_hex_long

	.loop_paused:
		btst	#INPUT_B1_BIT, REG_INPUT
		beq	.loop_paused
		bra	.loop_next_pass

	.test_exit:
		rts

	section data
	align 2

d_mt_data1:
	MT_PARAMS TILE_RAM_START, MT_NULL_ADDRESS_LIST, $1000, 12, TILE_RAM_MASK, MT_TEST_BOTH, TILE_RAM_BASE_EC

d_mt_data2:
	MT_PARAMS TILE_RAM_START+$2000, MT_NULL_ADDRESS_LIST, $1000, 12, TILE_RAM_MASK, MT_TEST_BOTH, TILE_RAM_BASE_EC

d_mt_data3:
	MT_PARAMS TILE_RAM_START+$4000, MT_NULL_ADDRESS_LIST, $1000, 12, TILE_RAM_MASK, MT_TEST_BOTH, TILE_RAM_BASE_EC

d_mt_data4:
	MT_PARAMS TILE_RAM_START+$6000, MT_NULL_ADDRESS_LIST, $800, 12, TILE_RAM_MASK, MT_TEST_BOTH, TILE_RAM_BASE_EC

d_screen_xys_list:
	XY_STRING 3,  4, "TILE RAM TEST"
	XY_STRING 3, 10, "PASSES"
	XY_STRING 3, 19, "B1 - PAUSE"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
