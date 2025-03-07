	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"
	include "global/include/screen.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"

	global auto_object_ram_tests
	global manual_object_ram_tests

	section code

auto_object_ram_tests:

		move.b	#$0, REG_OBJECT_RAM_BANK
		lea	d_mt_data, a0
		DSUB	memory_tests_handler
		tst.b	d0
		bne	.test_exit

		move.b	#$1, REG_OBJECT_RAM_BANK
		lea	d_mt_data, a0
		DSUB	memory_tests_handler
		tst.b	d0
		bne	.test_exit

		DSUB	object_ram_bank_switch_test

	.test_exit:
		move.b	#$0, REG_OBJECT_RAM_BANK
		rts

manual_object_ram_tests:

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

		jsr	auto_object_ram_tests
		tst.b	d0
		bne	.test_failed

		addq.l	#1, d6

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		move.l	d6, d0
		RSUB	print_hex_long

		btst	#INPUT_B2_BIT, REG_INPUT
		beq	.test_exit

		btst	#INPUT_B1_BIT, REG_INPUT
		beq	.test_pause
		bra	.loop_next_pass

	.test_failed:
		RSUB	error_handler
		STALL

	.test_pause:

		moveq	#INPUT_B1_BIT, d0
		RSUB	wait_button_release

		bra	.loop_next_pass

	.test_exit:
		rts


object_ram_bank_switch_test_dsub:
		lea	OBJECT_RAM_START, a0
		move.w	#$ffff, d1

		move.b	#$0, REG_OBJECT_RAM_BANK
		move.w	d1, (a0)

		move.b	#$1, REG_OBJECT_RAM_BANK
		move.w	#$0, (a0)

		move.b	#$0, REG_OBJECT_RAM_BANK
		move.w	(a0), d2
		cmp.w	d2, d1
		bne	.test_failed

		moveq	#$0, d0
		DSUB_RETURN

	.test_failed:
		move.w	#EC_OBJECT_RAM_BANK, d0
		DSUB_RETURN

	section data
	align 1

d_mt_data:
		MT_PARAMS OBJECT_RAM_START, MT_NULL_ADDRESS_LIST, OBJECT_RAM_SIZE, OBJECT_RAM_ADDRESS_LINES, OBJECT_RAM_MASK, MT_TEST_BOTH, OBJECT_RAM_BASE_EC

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_PASSES_Y, "PASSES"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PAUSE"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
