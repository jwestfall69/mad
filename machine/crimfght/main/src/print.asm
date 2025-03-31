	include "cpu/konami/include/macros.inc"
	include "cpu/konami/include/psub.inc"

	global print_hex_nibble
	global print_hex_byte
	global print_hex_word
	global print_string

	section code

; params:
;  a = nibble (lower)
;  x = start location in tile ram
print_hex_nibble:

		anda	#$f
		cmpa	#$9
		ble	.do_print
		adda	#$7

	.do_print:
		sta	, x
		rts

; params:
;  a = byte
;  x = start location in tile ram
print_hex_byte:

		; printing backwards
		leax	1, x

	rept 2
	inline
		pshs	a
		anda	#$f
		cmpa	#$9
		ble	.do_print
		adda	#$7

	.do_print:
		sta	, x
		leax	-1, x

		puls	a
		lsra
		lsra
		lsra
		lsra
	einline
	endr
		rts

; params:
;  d = word
;  x = start location in tile ram
print_hex_word:
		; printing backwards
		leax	3, x

	rept 4
	inline
		pshs	b
		andb	#$f
		cmpb	#$9
		ble	.do_print
		addb	#$7

	.do_print:
		stb	, x
		leax	-1, x

		puls	b
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
		rts

; params:
;  x = start location in tile ram
;  y = start address of string
print_string:

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
		rts
