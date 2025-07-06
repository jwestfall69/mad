	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"

	global auto_work_ram_tests_dsub
	global manual_work_ram_tests

	section code

auto_work_ram_tests_dsub:

		; do to nesting depth issues we need to directly
		; branch to the handler and let it do the DSUB_RETURN
		lea	d_mt_data, a0
		bra	memory_tests_handler_dsub

manual_work_ram_tests:
		jsr	print_passes
		jsr	print_b2_return_to_menu

		moveq	#0, d6		; passes, memory tests don't touch it
		DSUB_MODE_PSUB

	.loop_next_pass:
		WATCHDOG

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		move.l	d6, d0
		PSUB	print_hex_long

		PSUB	auto_work_ram_tests
		tst.b	d0
		bne	.test_failed

		btst	#INPUT_B2_BIT, REG_INPUT
		beq	.test_exit

		addq.l	#1, d6

		bra	.loop_next_pass

	.test_failed:
		PSUB	error_handler
		STALL

	.test_exit:
		DSUB_MODE_RSUB
		clr.b	r_menu_cursor
		bra	main_menu

	section data
	align 1

d_mt_data:
	MT_PARAMS WORK_RAM, MT_NULL_ADDRESS_LIST, WORK_RAM_SIZE, WORK_RAM_ADDRESS_LINES, WORK_RAM_MASK, WORK_RAM_BASE_EC, MT_FLAG_NONE
