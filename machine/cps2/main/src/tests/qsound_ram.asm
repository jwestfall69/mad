	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"

	global auto_qsound_ram_tests
	global manual_qsound_ram_tests

	section code

auto_qsound_ram_tests:

		; This mostly disables the z80 from touching qsound ram.  This
		; also means a qsound ram error will not produce a beep code.
		move.b	#$0, $619ffb

		lea	d_mt_data, a0
		DSUB	memory_tests_handler

		SOUND_INIT
		rts

manual_qsound_ram_tests:
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

		jsr	auto_qsound_ram_tests
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

	section data
	align 1

d_mt_data:
		MT_PARAMS QSOUND_RAM, MT_NULL_ADDRESS_LIST, QSOUND_RAM_SIZE, QSOUND_RAM_ADDRESS_LINES, QSOUND_RAM_MASK, QSOUND_RAM_BASE_EC, MT_FLAG_LOWER_ONLY

d_str_b1_pause:		STRING "B1 - PAUSE"
