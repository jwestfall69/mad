	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/values_edit.inc"

	global sprite_viewer
	global sprite_viewer_palette_setup

	section code


sprite_viewer:
		call	sprite_viewer_palette_setup

		ld	de, d_screen_xys_list
		call	print_xy_string_list

		ld	bc, SV_SPRITE_NUM
		ld	(r_sprite_num), bc

		ld	bc, $a0
		ld	(r_sprite_pos_x), bc

		ld	a, $80
		ld	(r_sprite_pos_y), a

		ld	ix, d_ve_settings
		ld	iy, d_ve_list

		ei
		call	values_edit_handler
		di

		ret

; Per MAME
; * Sprite Format
; * ------------------
; *
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | xxxxxxxx | sprite number
; *   1  | xxx----- | sprite number (high bit)
; *   1  | ---x---- | x pos (high bits)
; *   1  | ----xxxx | palette number
; *   2  | xxxxxxxx | y pos
; *   3  | xxxxxxxx | x pos
value_changed_cb:
		ld	a, VIDEO_BANK_SPRITE
		out	(IO_VIDEO_BANK), a

		ld	ix, SPRITE_RAM

		ld	bc, (r_sprite_num)
		ld	(ix), c
		ld	a, b
		sla	a
		sla	a
		sla	a
		sla	a
		sla	a

		ld	bc, (r_sprite_pos_x)
		ld	(ix + 3), c
		bit	0, b
		jr	z, .skip_sprite_pos_x_high_bit
		or	$10

	.skip_sprite_pos_x_high_bit:
		or	SPRITE_PALETTE_NUM
		ld	(ix + 1), a

		ld	a, (r_sprite_pos_y)
		ld	(ix + 2), a

		ld	a, VIDEO_BANK_TILE
		out	(IO_VIDEO_BANK), a
		ret

loop_input_cb:
		ret


sprite_viewer_palette_setup:
		ld	a, CTRL_ENABLE_SPRITE_ROMS|CTRL_ENABLE_TILE_ROMS|CTRL_PALETTE_WRITE_REQUEST
		out	(IO_CONTROL), a

		ld	bc, $7ff
		RSUB	delay

		ld	hl, d_romset_sprite_palette_data
		ld	de, SPRITE_PALETTE
		ld	bc, PALETTE_SIZE
		ldir

		ld	a, CTRL_ENABLE_SPRITE_ROMS|CTRL_ENABLE_TILE_ROMS
		out	(IO_CONTROL), a
		ret

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $3ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_RAW, r_sprite_pos_y, $ff
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "POS Y"
	XY_STRING_LIST_END

	section bss

r_sprite_num:		dcb.w 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.b 1
