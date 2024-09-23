	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"
	include "cpu/6309/include/handlers/memory_tests.inc"
	include "global/include/screen.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"

	global auto_tile2_ram_tests
	global manual_tile2_ram_tests

	section code

auto_tile2_ram_tests:

		ldx	#d_mt_data
		jsr	memory_tests_handler
		rts

manual_tile2_ram_tests:
		ldy	#d_screen_xys_list
		PSUB	print_xy_string_list

		clrd

	.loop_next_pass:
		pshs	d
		WATCHDOG

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		PSUB	print_hex_word

		jsr	auto_tile2_ram_tests
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

	.loop_paused:
		WATCHDOG
		ldw	#$1ff
		PSUB	delay
		lda	REG_INPUT
		bita	#INPUT_B1
		beq	.loop_paused
		puls	d
		jmp	.loop_next_pass

	.test_exit:
		puls	d
		rts

	section data

d_mt_data:
	MT_PARAMS TILE2_RAM_START, TILE2_RAM_SIZE, TILE2_RAM_ADDRESS_LINES, TILE2_RAM_BASE_EC

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "TILE2 RAM TEST"
	XY_STRING SCREEN_START_X, SCREEN_PASSES_Y, "PASSES"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PAUSE"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
