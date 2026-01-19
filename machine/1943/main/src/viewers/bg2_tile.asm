	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/values_edit.inc"

	global bg2_tile_viewer

	section code

bg2_tile_viewer:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		ld	bc, $0
		ld	(r_bg2_scroll_x), bc
		ld	(REG_BG2_SCROLL_X), bc

		ld	ix, d_ve_settings
		ld	iy, d_ve_list

		ld	a, LAYER_BG2_ENABLE
		ld	(REG_LAYER), a

		call	values_edit_handler

		ld	a, $0
		ld	(REG_LAYER), a

		ld	bc, $0
		ld	(REG_BG2_SCROLL_X), bc
		ret

value_changed_cb:
		ld	bc, (r_bg2_scroll_x)
		ld	(REG_BG2_SCROLL_X), bc
		ret

loop_input_cb:
		ret

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_bg2_scroll_x, $ffff
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SCROLL X"
	XY_STRING_LIST_END

	section bss

r_bg2_scroll_x:		dcb.w 1
