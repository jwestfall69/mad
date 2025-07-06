	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/tests/memory.inc"

	global auto_palette_ram_tests
	global manual_palette_ram_tests

	section code

; The high nibble of the upper byte in palette ram
; doesn't seem to be wired up to the cpu so it gets
; filled with random data.
auto_palette_ram_tests:

	; mame doesn't allow reading palette ram, so
	; we have to skip testing it
	ifd	_MAME_BUILD_
		rts
	endif

		lea	PALETTE_RAM, a0
		moveq	#1, d0
		DSUB	memory_output_test
		tst.b	d0
		bne	.test_failed_output

		lea	PALETTE_RAM, a0
		moveq	#1, d0
		DSUB	memory_write_test
		tst.b	d0
		bne	.test_failed_write

		lea	PALETTE_RAM, a0
		move.l	#PALETTE_RAM_SIZE, d0
		move.w	#$fff, d1
		DSUB	palette_ram_data_test
		tst.b	d0
		bne	.test_failed_data

		lea	PALETTE_RAM, a0
		move.l	#PALETTE_RAM_SIZE, d0
		move.w	#$fff, d1
		DSUB	memory_march_test
		tst.b	d0
		bne	.test_failed_march

		lea	PALETTE_RAM, a0
		move.w	#PALETTE_RAM_ADDRESS_LINES, d0
		move.w	#$ff, d1
		RSUB	memory_address_test
		tst.b	d0
		bne	.test_failed_address
		rts


	.test_failed_address:
		moveq	#EC_PALETTE_RAM_ADDRESS, d0
		rts

	.test_failed_data:
		subq.b	#1, d0
		add.b	#EC_PALETTE_RAM_DATA_LOWER, d0
		rts

	.test_failed_march:
		subq.b	#1, d0
		add.b	#EC_PALETTE_RAM_MARCH_LOWER, d0
		rts

	.test_failed_output:
		subq.b	#1, d0
		add.b	#EC_PALETTE_RAM_OUTPUT_LOWER, d0
		rts

	.test_failed_write:
		subq.b	#1, d0
		add.b	#EC_PALETTE_RAM_WRITE_LOWER, d0
		rts

manual_palette_ram_tests:

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list
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


; This palette ram specific version of data tests removes the
; poison stuff.  It or the timing changes from it causes false
; postives on the palette ram.
; params:
;  a0 = start address
;  d0 = length in bytes (long)
;  d1 = mask (word)
; returns:
;  d0 = 0 (pass), 1 (lower bad), 2 (upper bad), 3 (both bad)
;  a0 = failed address
;  d1 = expected value
;  d2 = actual value
palette_ram_data_test_dsub:

		; adjust length since we are writing in words
		ror.l	#1, d0
		subq.l	#1, d0

		lea	d_data_patterns, a1
		moveq	#(((d_data_patterns_end - d_data_patterns) / 2) - 1), d3

		; backup params
		move.l	d0, d4
		move.w	d1, d5
		movea.l	a0, a2

	.loop_next_pattern:
		movea.l	a2, a0
		move.w	d4, d0

		move.w	(a1)+, d1
		and.w	d5, d1

	.loop_next_write_address:
		move.w	d1, (a0)+
		subq.l	#1, d0
		bne	.loop_next_write_address

		; re-init for re-read
		movea.l	a2, a0
		move.l	d4, d0

	.loop_next_read_address:
		move.w	(a0)+, d2
		and.w	d5, d2
		cmp.w	d1, d2
		bne	.test_failed
		subq.l	#1, d0
		bne	.loop_next_read_address
		dbra	d3, .loop_next_pattern
		moveq	#0, d0
		DSUB_RETURN

	.test_failed:
		subq.l	#2, a0

		moveq	#0, d0
		cmp.b	d1, d2
		beq	.check_upper
		moveq	#1, d0

	.check_upper:
		ror.l	#8, d1
		ror.l	#8, d2
		cmp.b	d1, d2
		beq	.check_done
		or.b	#2, d0

	.check_done:
		rol.l	#8, d1
		rol.l	#8, d2
		DSUB_RETURN


	section data
	align 1

d_data_patterns:
	dc.w	$0000, $5555, $aaaa, $ffff
d_data_patterns_end:

d_screen_xys_list:
	ifd _MAME_BUILD_
		XY_STRING SCREEN_START_X, (SCREEN_PASSES_Y + 2), "MAME BUILD - TEST DISABLED"
	else
		XY_STRING SCREEN_START_X, (SCREEN_PASSES_Y + 2), "EXPECT ROLLING COLORS"
	endif
	XY_STRING_LIST_END
