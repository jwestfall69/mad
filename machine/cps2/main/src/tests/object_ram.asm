	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"

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
		SEEK_XY	SCREEN_START_X, SCREEN_B1_Y
		lea	d_str_b1_pause, a0
		RSUB	print_string
		jsr	print_passes
		jsr	print_b2_return_to_menu

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:
		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		move.l	d6, d0
		RSUB	print_hex_long

		jsr	auto_object_ram_tests
		tst.b	d0
		bne	.test_failed

		addq.l	#1, d6

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
		lea	OBJECT_RAM, a0
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
		MT_PARAMS OBJECT_RAM, MT_NULL_ADDRESS_LIST, OBJECT_RAM_SIZE, OBJECT_RAM_ADDRESS_LINES, OBJECT_RAM_MASK, OBJECT_RAM_BASE_EC, MT_FLAG_NONE

d_str_b1_pause:		STRING "B1 - PAUSE"
