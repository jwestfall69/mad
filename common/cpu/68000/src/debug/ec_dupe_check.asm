	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"

	include "input.inc"
	include "machine.inc"

	global ec_dupe_check

	section code

; This is a check to verify I dont accidently have any dupe
; error codes in EC_LIST.
;
; There are 256 possible error codes.  We are using a 32 byte
; array where each bit represents a single error code we've
; seen.  We are doing (error_code / 8), the whole number is the
; byte in our array and the remainder is the bit within that
; byte.  If we already see a bit set it means we have a dupe.
ec_dupe_check:

		SEEK_XY	3, 20
		lea	STR_B2_RETURN, a0
		RSUB	print_string

		lea	EC_SEEN, a0
		move.l	#32, d0
		move.l	#$0, d1
		RSUB	memory_fill

		lea	EC_LIST, a1
	.loop_ec_next_entry:
		lea	EC_SEEN, a2
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

		addq.l	#6, a1		; goto next EC_LIST entry
		bra	.loop_ec_next_entry

	.found_dupe:
		SEEK_XY	3, 10
		lea	STR_DUPE_FOUND, a0
		RSUB	print_string

		SEEK_XY	15, 10
		move.b	(a1), d0
		RSUB	print_hex_byte
		bra	.loop_input

	.ec_list_end:
		SEEK_XY	3, 10
		lea	STR_NO_DUPES, a0
		RSUB	print_string

	.loop_input:
		WATCHDOG
		btst	#INPUT_B2_BIT, REG_INPUT
		bne	.loop_input
		rts

	section data

STR_B2_RETURN:	STRING "B2 - RETURN TO MENU"
STR_DUPE_FOUND: STRING <"DUPE FOUND", CHAR_COLON>
STR_NO_DUPES:	STRING "NO DUPES FOUND"

	section bss

	align 2

EC_SEEN:
	dcb.b	32
