	include "cpu/68000/include/common.inc"

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
		add.l	#7*2, a6
		moveq	#7, d2
	.loop_next_bit:
		btst	#0, d0

		beq	.print_zero

		moveq	#'1'-$30, d1
		bra	.do_print

	.print_zero:
		moveq	#'0'-$30, d1

	.do_print:
		move.b	#$0, (a6)
		move.b	d1, ($1, a6)
		subq.l	#2, a6
		lsr.b	#1, d0
		dbra	d2, .loop_next_bit
		DSUB_RETURN

; params:
;  d0 = char or byte
;  a6 = address in fg ram to start printing at
print_char_dsub:
		sub.b	#$30, d0
print_byte_dsub:
		move.b	#$0, (a6)+
		move.b	d0, (a6)+
		DSUB_RETURN

; params:
;  d0 = char
;  d1 = number of times
;  a6 = address in fg ram to start printing at
print_char_repeat_dsub:
		subq.w	#1, d1
		sub.b	#$30, d0
	.loop_next_address:
		move.b	#0, (a6)+
		move.b	d0, (a6)+
		dbra	d1, .loop_next_address
		DSUB_RETURN

; params:
;  a6 = address in fg ram to start clearing from
print_clear_line_dsub:
		moveq	#' ', d0
		moveq	#40, d1
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
		subq.b	#1, d2
		lsl.b	#1, d2
		adda.l	d2, a6
		sub.b	#1, d1

	.loop_next_hex:
		moveq	#$f, d2
		and.b	d0, d2
		move.b	(HEX_LOOKUP,PC,d2.w), d2
		sub.b	#$30, d2
		move.b	#$0, (a6)
		move.b	d2, ($1, a6)
		subq.l	#2, a6
		lsr.l	#4, d0
		dbra	d1, .loop_next_hex
		DSUB_RETURN

HEX_LOOKUP:	dc.b	"0123456789ABCDEF"

; a1 = address of string
; a6 = address in fg ram to start printing at
print_string_dsub:
		moveq	#0, d0
		move.b	(a0)+, d0

	.loop_next_char:
		sub.b	#$30, d0
		move.b	#0, (a6)+
		move.b	d0, (a6)+
		move.b	(a0)+, d0
		bne	.loop_next_char
		DSUB_RETURN
