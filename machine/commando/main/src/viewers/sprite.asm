	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/values_edit.inc"

	global sprite_viewer

	section code

sprite_viewer:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		ld	bc, $9
		ld	(r_sprite_num), bc

		ld	bc, $81
		ld	(r_sprite_pos_x), bc

		ld	a, $70
		ld	(r_sprite_pos_y), a

		ld	a, $3
		ld	(r_sprite_palette_num), a

		ld	a, $0
		ld	(r_sprite_flip_x), a
		ld	(r_sprite_flip_y), a

		ld	ix, d_ve_settings
		ld	iy, d_ve_list

		ei

		call	values_edit_handler

		di

		; zero out what we changed, and request a copy
		; to remove the sprite from the screen
		ld	bc, $0
		ld	(SPRITE_RAM), bc
		ld	(SPRITE_RAM + 2), bc
		call	wait_sprite_copy_request
		ret

; Per MAME (capcom/commando.cpp)
; * Sprite Format
; * ------------------
; *
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | xxxxxxxx | sprite number (low bits)
; *   1  | xx------ | sprite number (high bits)
; *   1  | --xx---- | palette number
; *   1  | ----x--- | flip y
; *   1  | -----x-- | flip x
; *   1  | -------x | x pos high bit
; *   2  | xxxxxxxx | y pos
; *   3  | xxxxxxxx | x pos
value_changed_cb:

		ld	ix, SPRITE_RAM

		ld	bc, (r_sprite_num)
		ld	(ix + 0), c
		rrc	b
		rrc	b

		ld	a, (r_sprite_palette_num)
		sla	a
		sla	a
		sla	a
		sla	a
		or	b
		ld	b, a

		ld	a, (r_sprite_flip_x)
		cp	$0
		jr	z, .skip_sprite_flip_x
		set	2, b

	.skip_sprite_flip_x:
		ld	a, (r_sprite_flip_y)
		cp	$0
		jr	z, .skip_sprite_flip_y
		set	3, b

	.skip_sprite_flip_y:
		ld	a, b

		ld	bc, (r_sprite_pos_x)
		ld	(ix + 3), c
		bit	0, b
		jr	z, .skip_sprite_pos_x_high_bit
		or	$1

	.skip_sprite_pos_x_high_bit:
		ld	(ix + 1), a

		ld	a, (r_sprite_pos_y)
		ld	(ix + 2), a

		ld	a, $1
		ld	(r_sprite_copy_request), a
		ret

loop_input_cb:
		ret

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $2ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_palette_num, $3
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_RAW, r_sprite_pos_y, $ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "PALETTE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "FLIP Y"
	XY_STRING_LIST_END

	section bss

r_sprite_num:		dcb.w 1
r_sprite_palette_num:	dcb.b 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.b 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
