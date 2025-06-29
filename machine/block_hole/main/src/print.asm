	include "cpu/6x09/include/macros.inc"

	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/macros.inc"

	global print_bits_byte_dsub
	global print_byte_dsub
	global print_char_dsub
	global print_clear_line_dsub
	global print_hex_nibble_dsub
	global print_hex_byte_dsub
	global print_hex_word_dsub
	global print_string_dsub

	section code

; params:
;  a = byte
;  x = location in tile ram
print_bits_byte_dsub:
		; printing backwards
		leax	7, x
		ldb	#$8

	.loop_next_nibble:
		tfr	b, y
		tfr	a, b
		andb	#$1

		stb	,x
		leax	-1, x

		lsra

		tfr	y, b
		decb
		bne	.loop_next_nibble
		DSUB_RETURN

; params
;  a = char
;  x = start location in tile ram
print_byte_dsub:
		sta	, x
		DSUB_RETURN

; params
;  a = char
;  x = start location in tile ram

print_char_dsub:
		; deal with annoying tile font
		cmpa	#' '
		bne	.not_space
		lda	#$10
		bra	.do_print

	.not_space:
		cmpa	#'-'
		bne	.not_dash
		lda	#$0c
		bra	.do_print

	.not_dash:
		cmpa	#'0'
		blt	.do_print

		cmpa	#'Z'
		bgt	.do_print

		suba	#$30

	.do_print:
		sta	, x
		DSUB_RETURN

; params:
;  x = start location in tile ram
print_clear_line_dsub:
		CHAR_REPEAT #$10, #40
		DSUB_RETURN

; params:
;  a = nibble (lower)
;  x = start location in tile ram
print_hex_nibble_dsub:
		anda	#$f
		cmpa	#$9
		ble	.do_print
		adda	#$7

	.do_print:
		sta	, x
		DSUB_RETURN

; params:
;  a = byte
;  x = start location in tile ram
print_hex_byte_dsub:
		; printing backwards
		leax	1, x

	rept 2
	inline
		tfr	a, y
		anda	#$f
		cmpa	#$9
		ble	.do_print
		adda	#$7

	.do_print:
		sta	, x
		leax	-1, x

		tfr	y, a
		lsra
		lsra
		lsra
		lsra
	einline
	endr
		DSUB_RETURN

; params:
;  d = word
;  x = start location in tile ram
print_hex_word_dsub:
		; printing backwards
		leax	3, x

	rept 4
	inline
		tfr	b, y
		andb	#$f
		cmpb	#$9
		ble	.do_print
		addb	#$7

	.do_print:
		stb	, x
		leax	-1, x

		tfr	y, b
		lsra
		rorb
		lsra
		rorb
		lsra
		rorb
		lsra
		rorb
	einline
	endr
		DSUB_RETURN

; params:
;  x = start location in tile ram
;  y = start address of string
print_string_dsub:
		lda	,y+

		; deal with annoying tile font
	.loop_next_char:
		cmpa	#' '
		bne	.not_space
		lda	#$10
		bra	.do_print

	.not_space:
		cmpa	#'-'
		bne	.not_dash
		lda	#$0c
		bra	.do_print

	.not_dash:
		cmpa	#'0'
		blt	.do_print

		cmpa	#'Z'
		bgt	.do_print

		suba	#$30

	.do_print:
		sta	,x+
		lda	,y+
		bne	.loop_next_char
		DSUB_RETURN
