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
	ifd _SCREEN_TATE_
		ld	de, 7 * $20
	else
		ld	de, 7
	endif

		add	hl, de

		ld	e, 8
	.loop_next_bit:
		ld	a, $1
		and	a, c

		ld	(hl), a

		dec	hl

	ifd _SCREEN_TATE_
		rept $1f
			dec	hl
		endr
	endif

		rr	c
		dec	e
		jr	nz, .loop_next_bit
		DSUB_RETURN

; parms:
;  c = char
;  hl = location in video ram
print_char_dsub:
		exx

		ld	(hl), c
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
	ifd _SCREEN_TATE_
		rept $1f
			inc	hl
		endr
	endif
		dec	b
		jr	nz, .loop_next_char
		DSUB_RETURN

; params:
;  x = start location in tile ram
print_clear_line_dsub:
		exx
		ld	c, $20
		ld	b, SCREEN_NUM_COLUMNS
		jr	print_char_repeat_dsub + 1 ; skip exx

; params:
;  c = byte
; hl = location in video ram
print_hex_byte_dsub:
		exx

		; printing backwards
	ifd _SCREEN_TATE_
		ld	de, 1 * $20
	else
		ld	de, 1
	endif

		add	hl, de

		; 2 nibbles
		ld	e, 2
	.loop_next_nibble:
		ld	a, $f
		and	a, c
		ld	(hl), a

		dec	hl
	ifd _SCREEN_TATE_
		rept $1f
			dec	hl
		endr
	endif

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

		ld	(hl), a
		dec	hl
		DSUB_RETURN

; params:
; bc = word
; hl = location in video ram
print_hex_word_dsub:
		exx

		; printing backwards
	ifd _SCREEN_TATE_
		ld	de, 3 * $20
	else
		ld	de, 3
	endif
		add	hl, de

		; 4 nibbles
		ld	e, 4
	.loop_next_nibble:
		ld	a, $f
		and	a, c

		ld	(hl), a

		dec	hl
	ifd _SCREEN_TATE_
		rept $1f
			dec	hl
		endr
	endif

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
		ld	(hl), a

		inc	hl
	ifd _SCREEN_TATE_
		rept $1f
			inc	hl
		endr
	endif

		inc	de
		ld	a, (de)
		cp	$0
		jr	nz, .loop_next_char
		DSUB_RETURN
