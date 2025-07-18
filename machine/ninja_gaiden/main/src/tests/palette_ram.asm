	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_tests.inc"

	global auto_palette_ram_tests
	global manual_palette_ram_tests

	section code

; palette ram is 12 bit
; need to setup something better because its made up
; of 3x 4bit ram chips
auto_palette_ram_tests:

		lea	d_mt_data, a0
		DSUB	memory_tests_handler
		rts

manual_palette_ram_tests:
		jsr	print_passes
		jsr	print_b2_return_to_menu

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		move.l	d6, d0
		RSUB	print_hex_long

		jsr	auto_palette_ram_tests
		tst.b	d0
		bne	.test_failed

		addq.l	#1, d6

		btst	#INPUT_B2_BIT, REG_INPUT
		beq	.test_exit
		bra	.loop_next_pass

	.test_failed:
		RSUB	error_handler
		STALL

	.test_exit:
		rts

	section data
	align 1

d_mt_data:
	MT_PARAMS PALETTE_RAM, MT_NULL_ADDRESS_LIST, PALETTE_RAM_SIZE, PALETTE_RAM_ADDRESS_LINES, PALETTE_RAM_MASK, PALETTE_RAM_BASE_EC, MT_FLAG_NONE
