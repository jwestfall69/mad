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
		leax	15, x
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
		leax	-2, x

		leay	-1, y
		bne	.loop_next_nibble
		DSUB_RETURN

; params:
;  a = byte
;  x = location in tile ram
print_byte_dsub:
		sta	1,x
		DSUB_RETURN

; params:
;  a = char
;  x = location in tile ram
print_char_dsub:
		cmpa	#'-'
		bne	.not_dash
		lda	#$5c

	.not_dash:
		sta	1,x
		DSUB_RETURN

; params:
;  a = char
;  b = number of times
;  x = start location in tile ram
print_char_repeat_dsub:
		leax	1, x

	.loop_next_char:
		sta	,x++
		decb
		bne	.loop_next_char
	DSUB_RETURN

; params:
;  x = start location in tile ram
print_clear_line_dsub:
	lda	#$20
	ldb	#SCREEN_NUM_COLUMNS
	bra	print_char_repeat_dsub

; params:
;  a = byte
;  x = start location in tile ram
;  y should not be touched, needed for work ram errors
print_hex_byte_dsub:

		; printing backwards
		leax	3, x

	rept 2
	inline
		tfr	a, b
		andb	#$f

		stb	,x
		leax	-2, x

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
		sta	1,x
		DSUB_RETURN

; params:
;  d = word
;  x = start location in tile ram
print_hex_word_dsub:

		; printing backwards
		leax	7, x
		tfr	a, dp
		tfr	b, a
		ldy	#$2

	.loop_next_nibble:
		tfr	a, b
		andb	#$f
	.do_print:
		stb	,x
		leax	-2, x

		lsra
		lsra
		lsra
		lsra

		leay	-1, y
		bne	.loop_next_nibble

		tfr	dp, a
		ldb	#$0
		tfr	b, dp
		leax	-3, x
		bra	print_hex_byte_dsub

; params:
;  x = start location in tile ram
;  y = start address of string
print_string_dsub:
		lda	,y+
		leax	1, x

	; Deal with annoying tile font
	.loop_next_char:
		cmpa	#'-'
		bne	.not_dash
		lda	#$5c

	.not_dash:
		sta	,x++
		lda	,y+
		bne	.loop_next_char
	DSUB_RETURN
