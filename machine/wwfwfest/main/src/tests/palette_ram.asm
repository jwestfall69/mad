	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/memory_fill.inc"
	include "cpu/68000/include/tests/memory.inc"
	include "cpu/68000/include/xy_string.inc"
	include "global/include/screen.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"

	global auto_palette_ram_tests
	global manual_palette_ram_tests

	section code

; palette ram is wired up weird
; 180000 to 18001f = "A" valid data
; 180020 to 18003f = "A" mirror
; 180040 to 18005f = "A" mirror
; 180060 to 18007f = "A" mirror
; 180080 to 18009f = "B" valid data
; 180100 to 18011f = "B" mirror
; ...
; 180800 mirror of 18000 to 1807ff
; 181000 mirror of 18000 to 1807ff
; 181800 mirror of 18000 to 1807ff
; 182000 starts all over with new valid data
; This would imply these cpu address lines aren't
; wired up to the palette ram:
;   A5 A6 A11 A12
; This will cause breakage on data (posion), march
; and address line tests.
auto_palette_ram_tests:

		lea	PALETTE_RAM_START, a0
		moveq	#1, d0
		DSUB	memory_output_test
		tst.b	d0
		bne	.test_failed_output

		lea	PALETTE_RAM_START, a0
		moveq	#1, d0
		DSUB	memory_write_test
		tst.b	d0
		bne	.test_failed_write

		lea	PALETTE_RAM_START, a0
		move.l	#PALETTE_RAM_SIZE, d0
		move.w	#$ffff, d1
		DSUB	palette_ram_data_test
		tst.b	d0
		bne	.test_failed_data

		; not even going to try making a march
		; test for the palette ram
		;lea	PALETTE_RAM_START, a0
		;move.l	#PALETTE_RAM_SIZE, d0
		;move.w	#$ffff, d1
		;DSUB	memory_march_test
		;tst.b	d0
		;bne	.test_failed_march

		lea	PALETTE_RAM_START, a0
		move.w	#PALETTE_RAM_ADDRESS_LINES, d0
		move.w	#$ffff, d1
		RSUB	palette_ram_address_test
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

		moveq	#0, d6		; passes, memory tests don't touch it

	.loop_next_pass:
		WATCHDOG

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



; Write an incrementing value at each address line, then
; read them back checking for any differences.  This
; version skips address lines 5-6 and 11-12 per comments
; at the top of the file
; params:
;  a0 = start address
;  d0 = address lines to test (word)
;  d1 = mask (word)
; returns
;  d0 = 0 (pass), 1 (fail)
;  a0 = fail address
;  d1 = expected value
;  d2 = actual value
palette_ram_address_test_dsub:

		move.l	a0, a1
		sub.b	#1, d0		; adjust for loop
		move.w	d0, d4
		move.w	d1, d5

		moveq	#0, d1		; value we are writing
		moveq	#1, d3		; offset from address start

	.loop_write_next_address:
		add.w	#$101, d1

		; skip address lines 5-6, 11-12
		cmp.w	#$606, d1
		beq	.skip_write
		cmp.w	#$707, d1
		beq	.skip_write
		cmp.w	#$c0c, d1
		beq	.skip_write
		cmp.w	#$d0d, d1
		beq	.skip_write

		and.w	d5, d1
		move.w	d1, (a0)
	.skip_write:
		lsl.l	#1, d3
		move.l	a1, a0
		add.l	d3, a0
		dbra	d0, .loop_write_next_address


		move.l	a1, a0
		move.w	d4, d0

		moveq	#0, d1
		moveq	#1, d3

		WATCHDOG

	.loop_read_next_address:
		add.w	#$101, d1

		; skip address lines 5-6, 11-12
		cmp.w	#$606, d1
		beq	.skip_read
		cmp.w	#$707, d1
		beq	.skip_read
		cmp.w	#$c0c, d1
		beq	.skip_read
		cmp.w	#$d0d, d1
		beq	.skip_read

		and.w	d5, d1
		move.w	(a0), d2
		and.w	d5, d2
		cmp.w	d1, d2
		bne	.test_failed

	.skip_read:
		lsl.l	#1, d3
		move.l	a1, a0
		add.l	d3, a0
		dbra	d0, .loop_read_next_address

		moveq	#0, d0
		DSUB_RETURN

	.test_failed:
		moveq	#1, d0
		DSUB_RETURN

; This version removes the poison stuff as it will break
; because of the mirror happening on the palette ram
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
		WATCHDOG

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
	align 2

d_data_patterns:
	dc.w	$0000, $5555, $aaaa, $ffff
d_data_patterns_end:

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_PASSES_Y, "PASSES"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
