	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"

	global print_bits_byte_psub
	global print_byte_psub
	global print_char_psub
	global print_char_repeat_psub
	global print_clear_line_psub
	global print_hex_byte_psub
	global print_hex_nibble_psub
	global print_hex_word_psub
	global print_string_psub

	section code

; params:
;  a = byte
;  x = location in tile ram
print_bits_byte_psub:
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
		PSUB_RETURN



; params:
;  a = raw byte
;  x = location in tile ram
print_byte_psub:
		clr	,x+
		sta	,x
		PSUB_RETURN

; params:
;  a = char
;  x = location in tile ram
print_char_psub:
		clr	,x+
		sta	,x
		PSUB_RETURN

; params:
;  a = char
;  b = number of times
;  x = start location in tile ram
print_char_repeat_psub:
		clr	,x+
		sta	,x+
		decb
		bne	print_char_repeat_psub
	PSUB_RETURN

; params:
;  x = start location in tile ram
print_clear_line_psub:
	lda	#$0
	ldb	#$20
	bra	print_char_repeat_psub

; params:
;  a = byte
;  x = start location in tile ram
print_hex_byte_psub:

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
		PSUB_RETURN

; params:
;  a = nibble
;  x = start location in tile ram
print_hex_nibble_psub:
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
		PSUB_RETURN

; params:
;  d = word
;  x = start location in tile ram
print_hex_word_psub:

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
		PSUB_RETURN


; params:
;  x = start location in tile ram
;  y = start address of string
print_string_psub:
		lda	,y+

	.loop_next_char:
		clr	,x+
		sta	,x+
		lda	,y+
		bne	.loop_next_char
	PSUB_RETURN
