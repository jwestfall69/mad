	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "global/include/screen.inc"

	include "input.inc"
	include "machine.inc"

	global ec_dupe_check

	section code

; This is a check to verify I dont accidently have any dupe
; error codes in d_ec_list.
;
; There are 256 possible error codes.  We are using a 32 byte
; array where each bit represents a single error code we've
; seen.  We are doing (error_code / 8), the whole number is the
; byte in our array and the remainder is the bit within that
; byte.  If we already see a bit set it means we have a dupe.
ec_dupe_check:

		SEEK_XY	SCREEN_START_X, SCREEN_B2_Y
		lea	d_str_b2_return, a0
		RSUB	print_string

		lea	r_ec_seen, a0
		move.l	#32, d0
		move.l	#$0, d1
		RSUB	memory_fill

		lea	d_ec_list, a1
	.loop_ec_next_entry:
		lea	r_ec_seen, a2
		tst.l	(a1)		; list ends in a $0.l
		beq	.ec_list_end

		move.b	(a1), d3
		and.l	#$ff, d3
		divu	#8, d3

		; figure out the byte in the array
		move.b	d3, d2
		and.l	#$ff, d2
		add.l	d2, a2

		; figure out bit in the byte
		swap	d3
		moveq	#0, d2
		and.l	#$ff, d3
		moveq	#1, d2
		lsl.w	d3, d2

		btst	d3, (a2)
		bne	.found_dupe

		or.b	d2, (a2)

		addq.l	#6, a1		; goto next d_ec_list entry
		bra	.loop_ec_next_entry

	.found_dupe:
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		lea	d_str_dupe_found, a0
		RSUB	print_string

		SEEK_XY	(SCREEN_START_X + 14), (SCREEN_START_Y + 2)
		move.b	(a1), d0
		RSUB	print_hex_byte
		bra	.wait_exit

	.ec_list_end:
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		lea	d_str_no_dupes, a0
		RSUB	print_string

	.wait_exit:
		moveq	#INPUT_B2_BIT, d0
		RSUB	wait_button_press
		rts

	section data
	align 2

d_str_b2_return:	STRING "B2 - RETURN TO MENU"
d_str_dupe_found: 	STRING <"DUPE FOUND", CHAR_COLON>
d_str_no_dupes:		STRING "NO DUPES FOUND"

	section bss
	align 2

r_ec_seen:
	dcb.b	32
