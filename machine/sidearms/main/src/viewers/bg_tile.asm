	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/values_edit.inc"

	global bg_tile_viewer

	section code

bg_tile_viewer:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		call	bg_tile_palette_setup

		ld	bc, $200
		ld	(r_bg_scroll_x), bc
		ld	(REG_BG_SCROLL_X), bc

		ld	a, $0
		ld	(r_bg_scroll_y), a

		ld	ix, d_ve_settings
		ld	iy, d_ve_list

		ld	a, LAYER_BG_ENABLE
		ld	(REG_LAYER), a

		call	values_edit_handler

		ld	a, $0
		ld	(REG_LAYER), a

		ld	bc, $0
		ld	(REG_BG_SCROLL_Y), bc
		ld	(REG_BG_SCROLL_X), bc
		ret

value_changed_cb:
		ld	bc, (r_bg_scroll_x)
		ld	(REG_BG_SCROLL_X), bc

		ld	bc, (r_bg_scroll_y)
		ld	(REG_BG_SCROLL_Y), bc

		ret

loop_input_cb:
		ret

; we don't have control over which palette the background tiles
; use as they and their attributes are pulled directly from the
; bg tile roms.  So we are filling the entire bg palette space
; with the same palette over and over
bg_tile_palette_setup:

		ld	b, $20
		ld	hl, BG_TILE_PALETTE
	.loop_next_palette:
		push	bc
		push	hl
		ld	de, d_palette_data
		ld	c, PALETTE_SIZE
		call	palette_copy
		pop	hl
		ld	bc, PALETTE_SIZE / 2
		add	hl, bc
		pop	bc
		dec	b
		jr	nz, .loop_next_palette
		ret

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_bg_scroll_x, $fff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_bg_scroll_y, $fff
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SCROLL X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SCROLL Y"
	XY_STRING_LIST_END

d_palette_data:
	dc.w	$0000, $0505, $5605, $6705, $7808, $990a, $4505, $5505
	dc.w	$6505, $7605, $8705, $090f, $060c, $0508, $0406, $1101

	section bss

r_bg_scroll_x:		dcb.w 1
r_bg_scroll_y:		dcb.w 1
