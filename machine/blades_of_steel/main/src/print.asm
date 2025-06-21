	include "cpu/6309/include/dsub.inc"
	include "cpu/6309/include/macros.inc"

	include "machine.inc"

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
		lde	#$8

	.loop_next_nibble:
		ldb	#$1
		andr	a, b

		stb	,x
		leax	$20, x

		lsra

		dece
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
	ldb	#$20
	bra	print_char_repeat_dsub

; params:
;  a = byte
;  x = start location in tile ram
print_hex_byte_dsub:

		; printing backwards
		leax	-$20, x
		lde	#$2

	.loop_next_nibble:
		ldb	#$f
		andr	a, b
		cmpb	#$a
		blt	.is_digit
		addb	#$7

	.is_digit:
		stb	,x
		leax	$20, x

		lsra
		lsra
		lsra
		lsra

		dece
		bne	.loop_next_nibble
		DSUB_RETURN

; params:
;  a = byte
;  x = start location in tile ram
print_hex_nibble_dsub:

		ldb	#$f
		andr	a, b
		cmpb	#$a
		blt	.is_digit
		addb	#$7

	.is_digit:
		stb	,x
		leax	$20, x
		DSUB_RETURN

; params:
;  d = word
;  x = start location in tile ram
print_hex_word_dsub:

		; printing backwards
		leax	-(3 * $20), x
		lde	#$4

	.loop_next_nibble:
		ldf	#$f
		andr	b, f

		cmpf	#$a
		blt	.is_digit
		addf	#$7

	.is_digit:
		stf	,x
		leax	$20, x

		lsrd
		lsrd
		lsrd
		lsrd

		dece
		bne	.loop_next_nibble
		DSUB_RETURN


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
		lda	#$2e
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
		leax	-$20, x
		lda	,y+
		bne	.loop_next_char
	DSUB_RETURN
