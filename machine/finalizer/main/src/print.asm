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
		leax	-(7 * $20), x
		ldy	#$8

	.loop_next_nibble:
		rora
		bcc	.is_zero
		ldb	#$1
		bra	.do_print

	.is_zero:
		ldb	#$0

	.do_print:
		stb	,x
		leax	$20, x

		leay	-1, y
		bne	.loop_next_nibble
		DSUB_RETURN

; params:
;  a = byte
;  x = location in tile ram
print_byte_dsub:
		sta	,x
		DSUB_RETURN

; params:
;  a = char
;  x = location in tile ram
print_char_dsub:
		; Deal with annoying tile font
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
		ble	.do_adjust
		bra	.do_print

	.do_adjust:
		suba	#$30

	.do_print:
		sta	,x
		DSUB_RETURN

; params:
;  a = char
;  b = number of times
;  x = start location in tile ram
print_char_repeat_dsub:

	; Not doing anything fancy like on print_string
	; as only screen_clear calls this. It can just
	; use the correct raw cha
	.loop_next_char:
		sta	,x
		leax	-$20, x
		decb
		bne	.loop_next_char
	DSUB_RETURN

; params:
;  x = start location in tile ram
print_clear_line_dsub:
	lda	#$10
	ldb	#SCREEN_NUM_COLUMNS
	bra	print_char_repeat_dsub

; params
;  a = byte
;  x = start location in tile ram
print_hex_byte_dsub:

		; printing backwards
		leax	-$20, x

	rept 2
	inline
		tfr	a, b
		andb	#$f
		cmpb	#$a
		blt	.is_digit
		addb	#$7

	.is_digit:
		stb	, x
		leax	$20, x

		lsra
		lsra
		lsra
		lsra

	einline
	endr
		DSUB_RETURN

; params:
;  a = nibble
;  x = start location in tile ram
print_hex_nibble_dsub:

		anda	#$f
		cmpa	#$a
		blt	.is_digit
		adda	#$7

	.is_digit:
		sta	, x
		DSUB_RETURN

; params:
;  d = word
;  x = start location in tile ram
print_hex_word_dsub:

		; printing backwards
		leax	-(3 * $20), x
		tfr	a, dp
		tfr	b, a
		ldy	#$2

	.loop_next_nibble:
		tfr	a, b
		andb	#$f

		cmpb	#$a
		blt	.do_print
		addb	#$7

	.do_print:
		stb	,x
		leax	$20, x

		lsra
		lsra
		lsra
		lsra

		leay	-1, y
		bne	.loop_next_nibble

		tfr	dp, a
		ldb	#$0
		tfr	b, dp
		leax	$20, x
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
		lda	#$10
		bra	.do_print

	.not_space:
		cmpa	#'-'
		bne	.not_dash
		lda	#$0c
		bra	.do_print

	.not_dash:
		cmpa	#'_'
		bne	.not_underscore
		lda	#$10
		bra	.do_print

	.not_underscore:
		cmpa	#'0'
		blt	.do_print

		cmpa	#'Z'
		ble	.do_adjust
		bra	.do_print

	.do_adjust:
		suba	#$30

	.do_print:
		sta	,x
		leax	-$20, x
		lda	,y+
		bne	.loop_next_char
	DSUB_RETURN
