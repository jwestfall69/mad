	include "cpu/6309/include/common.inc"

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
		leax	14, x
		lde	#$8

	.loop_next_nibble:
		ldb	#$1
		andr	a, b

		addb	#'0'

		clr	,x+
		stb	,x
		leax	-3, x

		lsra

		dece
		bne	.loop_next_nibble
		DSUB_RETURN



; params:
;  a = raw byte
;  x = location in tile ram
print_byte_dsub:
		clr	,x+
		sta	,x
		DSUB_RETURN

; params:
;  a = char
;  x = location in tile ram
print_char_dsub:
		clr	,x+
		sta	,x
		DSUB_RETURN

; params:
;  a = char
;  b = number of times
;  x = start location in tile ram
print_char_repeat_dsub:
		clr	,x+
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
		leax	2, x
		lde	#$2

	.loop_next_nibble:
		ldb	#$f
		andr	a, b

		cmpb	#$a
		blt	.is_digit
		addb	#('A' - $a)
		bra	.do_print

	.is_digit:
		addb	#'0'

	.do_print:
		clr	,x+
		stb	,x
		leax	-3, x

		lsra
		lsra
		lsra
		lsra

		dece
		bne	.loop_next_nibble
		DSUB_RETURN

; params:
;  a = nibble
;  x = start location in tile ram
print_hex_nibble_dsub:
		ldb	#$f
		andr	a, b

		cmpb	#$a
		blt	.is_digit
		addb	#('A' - $a)
		bra	.do_print

	.is_digit:
		addb	#'0'

	.do_print:
		clr	,x+
		stb	,x
		DSUB_RETURN

; params:
;  d = word
;  x = start location in tile ram
print_hex_word_dsub:

		; printing backwards
		leax	6, x
		lde	#$4

	.loop_next_nibble:
		ldf	#$f
		andr	b, f

		cmpf	#$a
		blt	.is_digit
		addf	#('A' - $a)
		bra	.do_print

	.is_digit:
		addf	#'0'

	.do_print:
		clr	,x+
		stf	,x
		leax	-3, x

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

	.loop_next_char:
		clr	,x+
		sta	,x+
		lda	,y+
		bne	.loop_next_char
	DSUB_RETURN
