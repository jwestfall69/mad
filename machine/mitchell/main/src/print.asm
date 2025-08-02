	include "cpu/z80/include/common.inc"

	global print_bits_byte_dsub
	;global print_byte_dsub
	global print_char_dsub
	global print_char_repeat_dsub
	global print_clear_line_dsub
	global print_hex_byte_dsub
	global print_hex_nibble_dsub
	global print_hex_word_dsub
	global print_string_dsub

	section code

; parmas:
;  c = byte
; hl = location in video ram
print_bits_byte_dsub:
		exx

		; printing backwards
		ld	de, 15
		add	hl, de

		ld	e, 8
	.loop_next_bit:
		ld	a, $1
		and	a, c

	ifnd _MGAKUEN_TEXT_

		jr	nz, .is_one
		ld	a, '0'
		jr	.do_print

	.is_one:
		ld	a, '1'

	.do_print:

	endif
		ld	(hl), $0
		dec	hl
		ld	(hl), a
		dec	hl

		rr	c

		dec	e
		jr	nz, .loop_next_bit
		DSUB_RETURN

; parms:
;  c = char
;  hl = location in video ram
print_char_dsub:
		exx

	ifd _MGAKUEN_TEXT_
		ld	a, c
		cp	' '
		jr	nz, .not_space
		ld	a, $30
		jr	.do_print

	.not_space:
		cp	'-'
		jr	nz, .not_dash
		ld	a, $1d
		jr	.do_print

	.not_dash:
		cp	'0'
		jp	m, .do_print

		cp	'9' + 1
		jp	p, .do_print

		sub	$30

	.do_print:
		ld	c, a

	endif

		ld	(hl), c
		inc	hl
		ld	(hl), $0
		DSUB_RETURN

; params:
;  c = char
;  b = number of times
;  hl = start location in video ram
print_char_repeat_dsub:
		exx

	.loop_next_char:
		ld	(hl), c
		inc	hl
		ld	(hl), $0
		inc	hl
		dec	b
		jr	nz, .loop_next_char
		DSUB_RETURN

; params:
;  x = start location in tile ram
print_clear_line_dsub:
		exx

	ifd _MGAKUEN_TEXT_
		ld	c, $30
	else
		ld	c, ' '
	endif

		ld	b, 48
		jr	print_char_repeat_dsub + 1 ; skip exx

; params:
;  c = byte
; hl = location in video ram
print_hex_byte_dsub:
		exx

		; printing backwards
		ld	de, 3
		add	hl, de

		; 2 nibbles
		ld	e, 2
	.loop_next_nibble:
		ld	a, $f
		and	a, c

	ifnd _MGAKUEN_TEXT_
		cp	$a
		jp	m, .is_digit

		add	a, 'A' - $a
		jr	.do_print

	.is_digit:
		add	a, '0'

	.do_print:

	endif
		ld	(hl), $0
		dec	hl
		ld	(hl), a
		dec	hl

		rr	c
		rr	c
		rr	c
		rr	c

		dec	e
		jr	nz, .loop_next_nibble
		DSUB_RETURN

; params:
;  c = nibble
; hl = location in video ram
print_hex_nibble_dsub:
		exx

		ld	a, $f
		and	a, c

	ifnd _MGAKUEN_TEXT_
		cp	$a
		jp	m, .is_digit

		add	a, 'A' - $a
		jr	.do_print

	.is_digit:
		add	a, '0'

	.do_print:

	endif
		ld	(hl), $0
		dec	hl
		ld	(hl), a
		dec	hl
		DSUB_RETURN

; params:
; bc = word
; hl = location in video ram
print_hex_word_dsub:
		exx

		; printing backwards
		ld	de, 7
		add	hl, de

		; 4 nibbles
		ld	e, 4
	.loop_next_nibble:
		ld	a, $f
		and	a, c

	ifnd _MGAKUEN_TEXT_

		cp	$a
		jp	m, .is_digit

		add	a, 'A' - $a
		jr	.do_print

	.is_digit:
		add	a, '0'

	.do_print:

	endif
		ld	(hl), $0
		dec	hl
		ld	(hl), a
		dec	hl

		rr	b
		rr	c
		rr	b
		rr	c
		rr	b
		rr	c
		rr	b
		rr	c

		dec	e
		jr	nz, .loop_next_nibble
		DSUB_RETURN

; params:
;  de = start of string
;  hl = location in video ram
print_string_dsub:
		exx
		ld	a, (de)

	.loop_next_char:

	ifd _MGAKUEN_TEXT_
		cp	' '
		jr	nz, .not_space
		ld	a, $30
		jr	.do_print

	.not_space:
		cp	'-'
		jr	nz, .not_dash
		ld	a, $1d
		jr	.do_print

	.not_dash:
		cp	'0'
		jp	m, .do_print

		cp	'9' + 1
		jp	p, .do_print

		sub	$30

	.do_print:

	endif
		ld	(hl), a
		inc	hl
		ld	(hl), $0
		inc	hl

		inc	de
		ld	a, (de)
		cp	$0
		jr	nz, .loop_next_char
		DSUB_RETURN
