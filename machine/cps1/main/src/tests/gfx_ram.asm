	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"
	include "cpu/68000/include/tests/memory.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"
	include "mad_rom.inc"

	global auto_gfx_ram_tests
	global manual_gfx_ram_tests

	section code

auto_gfx_ram_tests:
		lea	d_mt_data, a0
		DSUB	memory_tests_handler
		rts

manual_gfx_ram_tests:

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

		bsr	auto_gfx_ram_tests
		tst.b	d0
		bne	.test_failed

		btst	#INPUT_B1_BIT, REG_INPUT
		beq	.test_pause

		btst	#INPUT_B2_BIT, REG_INPUT
		beq	.test_exit

		addq.l	#1, d6

		bra	.loop_next_pass

	.test_pause:
		RSUB	screen_init

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		SEEK_XY	12, 10
		move.l	d6, d0
		RSUB	print_hex_long

		moveq	#INPUT_B1_BIT, d0
		RSUB	wait_button_release

		bra	.loop_next_pass

	.test_failed:
		RSUB	error_handler
		STALL

	.test_exit:
		rts

	section data
	align 2

; fix me based on ram chips
d_memory_address_list:
	MEMORY_ADDRESS_ENTRY GFX_RAM_START
	MEMORY_ADDRESS_LIST_END

d_mt_data:
	MT_PARAMS GFX_RAM_START, d_memory_address_list, GFX_RAM_SIZE, GFX_RAM_ADDRESS_LINES, GFX_RAM_MASK, $0, GFX_RAM_BASE_EC

d_screen_xys_list:
	XY_STRING 3,  4, "GFX RAM TEST"
	XY_STRING 3, 10, "PASSES"
	XY_STRING 3, 19, "B1 - PAUSE"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
