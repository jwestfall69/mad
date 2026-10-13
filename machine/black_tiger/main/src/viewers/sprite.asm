	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/values_edit.inc"

	global sprite_viewer
	global sprite_viewer_palette_setup

	section code

sprite_viewer:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		call	sprite_viewer_palette_setup

		ld	bc, $22
		ld	(r_sprite_num), bc

		ld	bc, $60
		ld	(r_sprite_pos_x), bc

		ld	a, $80
		ld	(r_sprite_pos_y), a

		ld	a, $0
		ld	(r_sprite_flip_x), a

		ld	ix, d_ve_settings
		ld	iy, d_ve_list

		ei

		call	values_edit_handler

		di

		ret

; Per MAME (capcom/1943_v.cpp)
; * Sprite Format
; * ------------------
; *
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | xxxxxxxx | sprite number
; *   1  | xxx----- | sprite number (high bit)
; *   1  | ---x---- | x pos (high bits)
; *   1  | ----x--- | flip x
; *   1  | -----xxx | palette number
; *   2  | xxxxxxxx | y pos
; *   3  | xxxxxxxx | x pos
value_changed_cb:
		ld	ix, SPRITE_RAM

		ld	bc, (r_sprite_num)
		ld	(ix), c

		sla	b
		sla	b
		sla	b
		sla	b
		sla	b

		ld	a, $0
		ld	bc, (r_sprite_pos_x)
		ld	(ix + 3), c
		bit	0, b
		jr	z, .skip_sprite_pos_x_high_bit
		or	$10

	.skip_sprite_pos_x_high_bit:

		ld	c, $1		; palette num
		ld	b, a
		ld	a, (r_sprite_flip_x)
		bit	0, a
		jr	z, .skip_sprite_flip_x
		ld	c, $09		; palette num + flip x

	.skip_sprite_flip_x:
		ld	a, b
		or	c
		ld	(ix + 1), a

		ld	a, (r_sprite_pos_y)
		ld	(ix + 2), a
loop_input_cb:
		ret

sprite_viewer_palette_setup:
		ld	hl, SPRITE_PALETTE + (SPRITE_PALETTE_SIZE / 2)
		ld	de, d_palette_data
		ld	c, SPRITE_PALETTE_SIZE
		call	palette_copy
		ret

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $7ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_RAW, r_sprite_pos_y, $ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "FLIP X"
	XY_STRING_LIST_END

d_palette_data:
	dc.w	$0000, $4404, $6604, $8808, $aa0a, $cc0c, $6000, $9000
	dc.w	$b600, $e800, $0206, $0408, $060a, $080d, $ee0e, $1101

	section bss

r_sprite_num:		dcb.w 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.b 1
r_sprite_flip_x:	dcb.b 1
