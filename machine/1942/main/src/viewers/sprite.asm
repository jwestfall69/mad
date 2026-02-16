	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/values_edit.inc"

	global sprite_viewer

	section code

sprite_viewer:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		ld	bc, $104
		ld	(r_sprite_num), bc

		ld	a, $1
		ld	(r_sprite_size), a

		ld	bc, $80
		ld	(r_sprite_pos_x), bc

		ld	a, $70
		ld	(r_sprite_pos_y), a

		ld	a, $0
		ld	(r_sprite_palette_num), a

		ld	ix, d_ve_settings
		ld	iy, d_ve_list

		ei

		call	values_edit_handler
		call	sprite_ram_clear	; will di for us
		ret

; Per MAME (capcom/1943_v.cpp)
; * Sprite Format
; * ------------------
; *
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | x------- | sprite number bit 8
; *   0  | -xxxxxxx | sprite number bits 0-6
; *   1  | xx------ | sprite size 
; *   1  | --x----- | sprite number bit 7
; *   1  | ---x---- | x pos (high bits)
; *   1  | ----xxxx | palette number
; *   2  | xxxxxxxx | y pos
; *   3  | xxxxxxxx | x pos
value_changed_cb:
		ld	ix, r_sprite_data

		ld	bc, (r_sprite_num)
		ld	a, c
		and	$7f

		bit	0, b
		jr	z, .not_bit_0
		or	$80

	.not_bit_0:
		ld	(ix), a

		ld	a, c
		and	$80
		ld	b, a
		srl	b
		srl	b

		ld	a, (r_sprite_palette_num)
		or	b

		ld	bc, (r_sprite_pos_x)
		ld	(ix + 3), c
		bit	0, b
		jr	z, .skip_sprite_pos_x_high_bit
		or	$10

	.skip_sprite_pos_x_high_bit:
		ld	b, a
		ld	a, (r_sprite_size)
		or	a
		rra
		rra
		rra
		or	b

		ld	(ix + 1), a

		ld	a, (r_sprite_pos_y)
		ld	(ix + 2), a

		ld	a, $1 << SPRITE_REQ_COPY_BIT
		ld	(r_sprite_req), a
		ret

loop_input_cb:
		ret

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $1ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size, $3
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_palette_num, $f
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_RAW, r_sprite_pos_y, $ff
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SPRITE SIZE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "PALETTE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "POS Y"
	XY_STRING_LIST_END

	section bss

r_sprite_num:		dcb.w 1
r_sprite_size:		dcb.b 1
r_sprite_palette_num:	dcb.b 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.b 1
