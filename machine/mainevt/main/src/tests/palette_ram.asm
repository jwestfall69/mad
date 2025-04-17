	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"
	include "cpu/6309/include/handlers/memory_tests.inc"
	include "global/include/screen.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"

	global auto_palette_ram_tests
	global manual_palette_ram_tests

	section code

auto_palette_ram_tests:

		; palette ram consists of 2x 8bit chips
		; where 1 chip handles even addresses and
		; the other odd.  We are manually testing
		; output/write of the odd address and the
		; normal memory test handler will handle
		; the rest.

		ldx	#PALETTE_RAM_START + 1
		PSUB	memory_output_test
		tsta
		bne	.test_failed_output_odd

		ldx	#PALETTE_RAM_START + 1
		PSUB	memory_write_test
		tsta
		bne	.test_failed_write_odd

		ldx	#d_mt_data
		jsr	memory_tests_handler
		rts

	.test_failed_output_odd:
		lda	#EC_PALETTE_RAM_OUTPUT
		rts

	.test_failed_write_odd:
		lda	#EC_PALETTE_RAM_WRITE
		rts


manual_palette_ram_tests:
		ldy	#d_screen_xys_list
		PSUB	print_xy_string_list

		clrd

	.loop_next_pass:
		WATCHDOG

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		pshs	d
		PSUB	print_hex_word

		jsr	auto_palette_ram_tests
		tsta
		bne	.test_failed

		lda	REG_INPUT
		bita	#INPUT_B1
		beq	.test_paused

		bita	#INPUT_B2
		beq	.test_exit

		puls	d
		incd

		bra	.loop_next_pass

	.test_failed:
		jsr	error_handler
		STALL

	.test_paused:
		PSUB	screen_init

		ldy	#d_screen_xys_list
		PSUB	print_xy_string_list

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		puls	d
		pshs	d
		PSUB	print_hex_word

		lda	#INPUT_B1
		jsr	wait_button_release

		puls	d
		jmp	.loop_next_pass

	.test_exit:
		puls	d
		rts

	section data

d_mt_data:
	MT_PARAMS PALETTE_RAM_START, PALETTE_RAM_SIZE, PALETTE_RAM_ADDRESS_LINES, PALETTE_RAM_BASE_EC, MT_FLAG_NONE

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "PALETTE RAM TEST"
	XY_STRING SCREEN_START_X, SCREEN_PASSES_Y, "PASSES"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PAUSE"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
