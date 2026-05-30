	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/values_edit.inc"

	global sprite_viewer
	global sprite_viewer_palette_setup

	section code

sprite_viewer:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		call	sprite_viewer_palette_setup

		ld	bc, $10
		ld	(r_sprite_num), bc

		ld	a, $02
		ld	(r_sprite_size), a

		ld	bc, $60
		ld	(r_sprite_pos_x), bc

		ld	bc, $80
		ld	(r_sprite_pos_y), bc

		ld	a, $0
		ld	(r_sprite_flip_x), a
		ld	(r_sprite_flip_y), a

		ld	ix, d_ve_settings
		ld	iy, d_ve_list

		call	values_edit_handler
		ret

; Per MAME (shared/tecmo_spr.cpp):
; * Sprite Format
; * ------------------
; *
; *  Byte | Bit(s)   | Use
; * ------+-76543210-+----------------
; *    0  | xxxxx--- | bank / upper tile bits
; *    0  | -----x-- | enable
; *    0  | ------x- | flip y
; *    0  | -------x | flip x
; *    1  | xxxxxxxx | tile number (low bits)
; *    2  | ------xx | size
; *    3  | xx-------| priority
; *    3  | --x----- | upper y co-ord
; *    3  | ---x---- | upper x co-ord
; *    3  | ----xxxx | colour
; *    4  | xxxxxxxx | ypos
; *    5  | xxxxxxxx | xpos
; *    6  | -------- | unused
; *    7  | -------- | unused
value_changed_cb:
		ld	ix, SPRITE_RAM

		ld	bc, (r_sprite_num)
		ld	(ix + 1), c

		sla	b
		sla	b
		sla	b

		ld	a, b
		or	$04	; enable sprite

		ld	b, a
		ld	a, (r_sprite_flip_x)
		cp	$0
		jr	z, .skip_sprite_flip_x
		ld	a, b
		or	$01
		ld	b, a

	.skip_sprite_flip_x:
		ld	a, (r_sprite_flip_y)
		cp	$0
		jr	z, .skip_sprite_flip_y
		ld	a, b
		or	$02
		ld	b, a

	.skip_sprite_flip_y:
		ld	(ix), b

		ld	a, (r_sprite_size)
		ld	(ix + 2), a

		ld	a, $0
		ld	bc, (r_sprite_pos_x)
		ld	(ix + 5), c

		bit	0, b
		jr	z, .skip_sprite_pos_x_high_bit
		or	$10

	.skip_sprite_pos_x_high_bit:
		ld	bc, (r_sprite_pos_y)
		ld	(ix + 4), c
		bit	0, b
		jr	z, .skip_sprite_pos_y_high_bit
		or	$20

	.skip_sprite_pos_y_high_bit:
		ld	(ix + 3), a
		ret


loop_input_cb:
		ret


sprite_viewer_palette_setup:
		ld	de, SPRITE_PALETTE
		ld	hl, d_palette_data
		ld	bc, PALETTE_SIZE
		ldir
		ret

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $1fff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size, $3
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_y, $1ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SIZE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "FLIP Y"
	XY_STRING_LIST_END

d_palette_data:
	dc.w	$0000, $7707, $aa0a, $9101, $b303, $d505, $7007, $3300
	dc.w	$8605, $a807, $b908, $ca09, $db0a, $ec0b, $dd0d, $0000

	section bss

r_sprite_num:		dcb.w 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.w 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
r_sprite_size:		dcb.b 1
