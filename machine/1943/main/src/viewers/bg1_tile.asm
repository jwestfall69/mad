	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/values_edit.inc"

	global bg1_tile_viewer

	section code

bg1_tile_viewer:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		ld	bc, $200
		ld	(r_bg1_scroll_x), bc
		ld	(REG_BG1_SCROLL_X), bc

		ld	a, $0
		ld	(r_bg1_scroll_y), a

		ld	ix, d_ve_settings
		ld	iy, d_ve_list

		ld	a, LAYER_BG1_ENABLE
		ld	(REG_LAYER), a

		call	values_edit_handler

		ld	a, $0
		ld	(REG_LAYER), a
		ld	(REG_BG1_SCROLL_Y), a

		ld	bc, $0
		ld	(REG_BG1_SCROLL_X), bc
		ret

value_changed_cb:
		ld	bc, (r_bg1_scroll_x)
		ld	(REG_BG1_SCROLL_X), bc

		ld	a, (r_bg1_scroll_y)
		ld	(REG_BG1_SCROLL_Y), a

		ret

loop_input_cb:
		ret

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_bg1_scroll_x, $ffff
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_RAW, r_bg1_scroll_y, $ff
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SCROLL X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SCROLL Y"
	XY_STRING_LIST_END

	section bss

r_bg1_scroll_x:		dcb.w 1
r_bg1_scroll_y:		dcb.b 1
