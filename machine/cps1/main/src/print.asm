	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad.inc"

	global print_bits_byte_dsub
	global print_byte_dsub
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
		; printing backwards to need to shift over
	ifd _SCREEN_TATE_
		add.l	#$7*$4, a6
	else
		add.l	#$7*$80, a6
	endif
		moveq	#7, d2
	.loop_next_bit:
		btst	#0, d0

		beq	.print_zero

		move.w	#'1', d1
		bra	.do_print

	.print_zero:
		move.w	#'0', d1

	.do_print:
		or.w	#(ROMSET_TEXT_TILE_GROUP << 8), d1
		move.w	d1, (a6)
		move.w	#0, (2, a6)

	ifd _SCREEN_TATE_
		suba.l	#$4, a6
	else
		suba.l	#$80, a6
	endif
		lsr.b	#1, d0
		dbra	d2, .loop_next_bit
		DSUB_RETURN

; params:
;  d0 = char or byte
;  a6 = address in fg ram to start printing at
print_byte_dsub:
print_char_dsub:
		and.l	#$ff, d0
		or.w	#(ROMSET_TEXT_TILE_GROUP << 8), d0
		move.w	d0, (a6)
		move.w	#0, (2, a6)
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
		move.w	#0, (2, a6)
	ifd _SCREEN_TATE_
		adda.l	#$4, a6
	else
		adda.l	#$80, a6
	endif
		dbra	d1, .loop_next_address
		DSUB_RETURN

; params:
;  a6 = address in fg ram to start clearing from
print_clear_line_dsub:
		moveq	#' ', d0
		moveq	#48, d1
		bra	print_char_repeat_dsub

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
	ifd _SCREEN_TATE_
		mulu	#$4, d2
	else
		mulu	#$80, d2
	endif
		adda.l	d2, a6
		sub.b	#1, d1

	.loop_next_hex:
		moveq	#$f, d2
		and.b	d0, d2
		move.b	(HEX_LOOKUP,PC,d2.w), d2
		or.w	#(ROMSET_TEXT_TILE_GROUP << 8), d2
		move.w	d2, (a6)
		move.w	#0, (2, a6)

	ifd _SCREEN_TATE_
		suba.l	#$4, a6
	else
		suba.l	#$80, a6
	endif
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
	ifd _SCREEN_TATE_
		adda.l	#$4, a6
	else
		adda.l	#$80, a6
	endif
		move.b	(a0)+, d0
		bne	.loop_next_char
		DSUB_RETURN
