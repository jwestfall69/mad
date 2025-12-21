	include "cpu/6809/include/common.inc"

	global print_bits_byte_dsub
	global print_byte_dsub
	global print_char_dsub
	global print_char_repeat_dsub
	global print_clear_line_dsub
	global print_hex_byte_dsub
	global print_hex_nibble_dsub
	global print_hex_word_dsub
	global print_string_dsub

	section code

; params:
;  a = byte
;  x = location in tile ram
print_bits_byte_dsub:
		; printing backwards
		leax	7, x
		ldy	#$8

	.loop_next_nibble:
		rora
		bcc	.is_zero
		ldb	#$1b
		bra	.do_print

	.is_zero:
		ldb	#$1a

	.do_print:
		stb	,x
		leax	-1, x

		leay	-1, y
		bne	.loop_next_nibble
		DSUB_RETURN



; params:
;  a = raw byte
;  x = location in tile ram
print_byte_dsub:
		sta	,x
		DSUB_RETURN

; params:
;  a = char
;  x = location in tile ram
print_char_dsub:
		cmpa	#' '
		bne	.not_space
		lda	#$0
		bra	.do_print

	.not_space:
		cmpa	#'-'
		bne	.not_dash
		lda	#$6
		bra	.do_print

	.not_dash:
		cmpa	#'0'
		blt	.do_print

		cmpa	#'9'
		ble	.is_number

		cmpa	#'A'
		blt	.do_print

		cmpa	#'Z'
		ble	.is_char

	.is_number:
		suba	#$16
		bra	.do_print

	.is_char:
		suba	#$1d

	.do_print:
		sta	,x
		DSUB_RETURN

; params:
;  a = char
;  b = number of times
;  x = start location in tile ram
print_char_repeat_dsub:
		sta	,x+
		decb
		bne	print_char_repeat_dsub
	DSUB_RETURN

; params:
;  x = start location in tile ram
print_clear_line_dsub:
	lda	#$0
	ldb	#$20
	bra	print_char_repeat_dsub

; params:
;  a = byte
;  x = start location in tile ram
print_hex_byte_dsub:

		; printing backwards
		leax	1, x
		ldy	#$2

	.loop_next_nibble:
		tfr	a, b
		andb	#$f

		cmpb	#$a
		blt	.is_digit
		addb	#($24 - $a)
		bra	.do_print

	.is_digit:
		addb	#$1a

	.do_print:
		stb	,x
		leax	-1, x

		lsra
		lsra
		lsra
		lsra

		leay	-1, y
		bne	.loop_next_nibble
		DSUB_RETURN

; params:
;  a = nibble
;  x = start location in tile ram
print_hex_nibble_dsub:
		anda	#$f

		cmpa	#$a
		blt	.is_digit
		adda	#($24 - $a)
		bra	.do_print

	.is_digit:
		adda	#$1a

	.do_print:
		sta	,x
		DSUB_RETURN

; params:
;  d = word
;  x = start location in tile ram
print_hex_word_dsub:

		; printing backwards
		leax	3, x
		tfr	a, dp
		tfr	b, a
		ldy	#$2

	.loop_next_nibble:
		tfr	a, b
		andb	#$f

		cmpb	#$a
		blt	.is_digit
		addb	#($24 - $a)
		bra	.do_print

	.is_digit:
		addb	#$1a

	.do_print:
		stb	,x
		leax	-1, x

		lsra
		lsra
		lsra
		lsra

		leay	-1, y
		bne	.loop_next_nibble

		tfr	dp, a
		ldb	#$0
		tfr	b, dp
		leax	-1, x
		bra	print_hex_byte_dsub

; params:
;  x = start location in tile ram
;  y = start address of string
print_string_dsub:
		lda	,y+

	; Deal with annoying tile font
	.loop_next_char:
		cmpa	#' '
		bne	.not_space
		lda	#$0
		bra	.do_print

	.not_space:
		cmpa	#'-'
		bne	.not_dash
		lda	#$6
		bra	.do_print

	.not_dash:
		cmpa	#'0'
		blt	.do_print

		cmpa	#'9'
		ble	.is_number

		cmpa	#'A'
		blt	.do_print

		cmpa	#'Z'
		ble	.is_char

	.is_number:
		suba	#$16
		bra	.do_print

	.is_char:
		suba	#$1d

	.do_print:
		sta	,x+
		lda	,y+
		bne	.loop_next_char
	DSUB_RETURN
