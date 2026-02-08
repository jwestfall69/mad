	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/values_edit.inc"

	global sprite_viewer
	global sprite_viewer_palette_setup

	section code

sprite_viewer:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		call	sprite_viewer_palette_setup

		ld	bc, RS_SV_SPRITE_NUM
		ld	(r_sprite_num), bc

		ld	bc, RS_SV_SPRITE_POS_X
		ld	(r_sprite_pos_x), bc

		ld	a, RS_SV_SPRITE_POS_Y
		ld	(r_sprite_pos_y), a

		ld	a, $0
		ld	(r_sprite_flip_y), a

		ld	ix, d_ve_settings
		ld	iy, d_ve_list

		ld	a, CTRL_RS_BASE|CTRL_NMI_ENABLE|CTRL_SND_RESET_OFF
		ld	(REG_CONTROL), a

		call	values_edit_handler

		ld	bc, $f8
		ld	(SPRITE_RAM), bc
		ld	(SPRITE_RAM + 2), bc

		ld	bc, $3ff
		RSUB	delay

		ld	a, CTRL_RS_BASE|CTRL_NMI_DISABLE|CTRL_SND_RESET_OFF
		ld	(REG_CONTROL), a

		ret

; Per MAME (capcom/1943_v.cpp)
; * Sprite Format
; * ------------------
; *
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | xxxxxxxx | sprite number
; *   1  | xxx----- | sprite number (high bits)
; *   1  | ---x---- | flip y
; *   1  | ----xxx- | palette number
; *   1  | -------x | x pos (high bit)
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

		ld	a, (r_sprite_flip_y)
		cp	$0
		jr	z, .skip_sprite_flip_y
		set	4, b
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
		ret

sprite_viewer_palette_setup:

		ld	hl, d_palette_data
		ld	(r_nmi_copy_src), hl
		ld	hl, SPRITE_PALETTE
		ld	(r_nmi_copy_dst), hl
		ld	a, SPRITE_PALETTE_SIZE / 2
		ld	(r_nmi_copy_size), a

		call	wait_nmi_copy

		ld	hl, d_palette_ext_data
		ld	(r_nmi_copy_src), hl
		ld	hl, SPRITE_PALETTE_EXT
		ld	(r_nmi_copy_dst), hl
		ld	a, SPRITE_PALETTE_SIZE / 2
		ld	(r_nmi_copy_size), a

		call	wait_nmi_copy
		ret

loop_input_cb:
		ret

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $7ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_RAW, r_sprite_pos_y, $ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "FLIP Y"
	XY_STRING_LIST_END


d_palette_data:
	RS_SV_PALETTE_DATA

d_palette_ext_data:
	RS_SV_PALETTE_EXT_DATA

	section bss

r_sprite_num:		dcb.w 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.b 1
r_sprite_flip_y:	dcb.b 1
