	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global print_bits_byte_dsub
	global print_char_dsub
	global print_char_repeat_dsub
	global print_clear_line_dsub
	global print_hex_3_bytes_dsub
	global print_hex_byte_dsub
	global print_hex_long_dsub
	global print_hex_nibble_dsub
	global print_hex_word_dsub
	global print_string_dsub

	section code

; params:
;  d0 = byte
;  a6 = address in fg ram to start printing at
print_bits_byte_dsub:
		DSUB_RETURN

; params:
;  d0 = char
;  a6 = address in fg ram to start printing at
print_char_dsub:
		and.l	#$ff, d0
		or.w	#(ROMSET_TEXT_TILE_GROUP << 8), d0
		move.w	d0, (a6)
		DSUB_RETURN
; params:
;  d0 = char
;  d1 = number of times
;  a6 = address in fg ram to start printing at
print_char_repeat_dsub:
		subq.w	#1, d1
		and.l	#$ff, d0
		or.w	#(ROMSET_TEXT_TILE_GROUP << 8), d0
	.loop_next_address:
		move.w	d0, (a6)
		lea	($80, a6), a6
		dbra	d1, .loop_next_address
		DSUB_RETURN

; params:
;  a6 = address in fg ram to start clearing from
print_clear_line_dsub:
		moveq	#' ', d0
		moveq	#32, d1
		bra	print_char_repeat_dsub

; called by error_handler
; params:
;  a1 = error description
print_error_string_dsub:
		SEEK_XY	4, 5
		movea.l	a1, a0
		bra	print_string_dsub	; will do the DSUB_RETURN

; d0 = data
print_hex_nibble_dsub:
		moveq	#1, d1
		bra	print_hex_dsub
; d0 = data
print_hex_byte_dsub:
		moveq	#2, d1
		bra	print_hex_dsub

; d0 = data
print_hex_word_dsub:
		moveq	#4, d1
		bra	print_hex_dsub

; d0 = data
print_hex_3_bytes_dsub:
		moveq	#6, d1
		bra	print_hex_dsub

; d0 = data
print_hex_long_dsub:
		moveq	#8, d1

; d0 = data
; d1 = number of chars to print
print_hex_dsub:

		; we are printing backwards so adjust our print
		; location based on the number of nibbles we will
		; be printing
		move.l	d1, d2
		subq.l	#1, d2
		mulu	#$80, d2
		adda.l	d2, a6
		sub.b	#1, d1

	.loop_next_hex:
		moveq	#$f, d2
		and.b	d0, d2
		move.b	(HEX_LOOKUP,PC,d2.w), d2
		or.w	#(ROMSET_TEXT_TILE_GROUP << 8), d2
		move.w	d2, (a6)
		lea	(-$80, a6), a6
		lsr.l	#4, d0
		dbra	d1, .loop_next_hex
		DSUB_RETURN

HEX_LOOKUP:	dc.b	"0123456789ABCDEF"

; a1 = address of string
; a6 = address in fg ram to start printing at
print_string_dsub:
		move.w	#(ROMSET_TEXT_TILE_GROUP << 8), d0
		move.b	(a0)+, d0

	.loop_next_char:
		move.w	d0, (a6)
		move.w	#0, (2, a6)
		lea	($80, a6), a6
		move.b	(a0)+, d0
		bne	.loop_next_char
		DSUB_RETURN
