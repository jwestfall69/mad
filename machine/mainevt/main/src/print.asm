	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"

	global print_char_psub
	global print_char_repeat_psub
	global print_hex_byte_psub
	global print_hex_word_psub
	global print_string_psub

	section	code


; params:
;  a = char
;  x = location in tile ram
print_char_psub:
		; Deal with annoying tile font
		cmpa	#'-'
		bne	.not_dash
		lda	#$4c
		bra	.do_print

	.not_dash:
		cmpa	#'.'
		bne	.not_period
		lda	#$9c
		bra	.do_print

	.not_period:
		cmpa	#'0'
		blt	.do_print

		cmpa	#'9'
		blt	.is_number

		cmpa	#'A'
		blt	.do_print

		cmpa	#'Z'
		blt	.is_char

	.is_number:
		adda	#$7c
		bra	.do_print

	.is_char:
		adda	#$75

	.do_print:
		sta	,x
		PSUB_RETURN

; params:
;  a = char
;  b = number of times
;  x = start location in tile ram
print_char_repeat_psub:

	; Not doing anything fancy like on print_string
	; as only screen_clear calls this. It can just
	; use the correct raw cha
	.loop_next_char:
		sta	,x+
		decb
		bne	.loop_next_char
	PSUB_RETURN

; params:
;  a = byte
;  x = start location in tile ram
print_hex_byte_psub:

		; printing backwards
		leax	1, x
		lde	#$2

	.loop_next_nibble:
		ldb	#$f
		andr	a, b

		addb	#$ac		; gets us the font which is 0-9,A-Z

		stb	,x
		leax	-1, x

		lsra
		lsra
		lsra
		lsra

		dece
		bne	.loop_next_nibble
		PSUB_RETURN

; params:
;  d = word
;  x = start location in tile ram
print_hex_word_psub:

		; printing backwards
		leax	3, x
		lde	#$4

	.loop_next_nibble:
		ldf	#$f
		andr	b, f

		addf	#$ac		; gets us the font which is 0-9,A-Z

		stf	,x
		leax	-1, x

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

	; Deal with annoying tile font
	.loop_next_char:
		cmpa	#'-'
		bne	.not_dash
		lda	#$4c
		bra	.do_print

	.not_dash:
		cmpa	#'.'
		bne	.not_period
		lda	#$9c
		bra	.do_print

	.not_period:
		cmpa	#'0'
		blt	.do_print

		cmpa	#'9'
		blt	.is_number

		cmpa	#'A'
		blt	.do_print

		cmpa	#'Z'
		blt	.is_char

	.is_number:
		adda	#$7c
		bra	.do_print

	.is_char:
		adda	#$75

	.do_print:
		sta	,x+
		lda	,y+
		bne	.loop_next_char
	PSUB_RETURN
