	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/values_edit.inc"

	global starfield_viewer

	section code

starfield_viewer:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		ld	hl, STARFIELD_PALETTE
		ld	de, d_palette_data
		ld	c, STARFIELD_PALETTE_SIZE
		call	palette_copy

		ld	a, $0
		ld	(r_sf_scroll_x), a
		ld	(r_sf_scroll_y), a
		ld	(r_sf_scroll_x_prev), a
		ld	(r_sf_scroll_y_prev), a
		ld	(REG_STARFIELD_SCROLL_X), a
		ld	(REG_STARFIELD_SCROLL_Y), a

		ld	ix, d_ve_settings
		ld	iy, d_ve_list

		ld	a, $6c
		ld	($c804), a

		call	values_edit_handler

		ld	a, $4c
		ld	($c804), a

		ret

value_changed_cb:
		ld	a, (r_sf_scroll_x)
		ld	hl, r_sf_scroll_x_prev
		cp	(hl)
		jr	z, .sf_scroll_x_no_change
		ld	(REG_STARFIELD_SCROLL_X), a
		ld	(hl), a

	.sf_scroll_x_no_change:
		ld	a, (r_sf_scroll_y)
		ld	hl, r_sf_scroll_y_prev
		cp	(hl)
		jr	z, .sf_scroll_y_no_change
		ld	(REG_STARFIELD_SCROLL_Y), a
		ld	(hl), a

	.sf_scroll_y_no_change:

		ret

loop_input_cb:
		ret

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_RAW, r_sf_scroll_x, $ff
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_RAW, r_sf_scroll_y, $ff
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SCROLL LEFT"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SCROLL UP"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 5), <"VALUES DONT MATTER", $2b, "ANY REGISTER">
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 4), "WRITE WILL CAUSE SCROLLING"
	XY_STRING_LIST_END

d_palette_data:
	dc.w	$ffff, $ffff, $ffff, $ffff

	section bss

r_sf_scroll_x:		dcb.b 1
r_sf_scroll_y:		dcb.b 1

r_sf_scroll_x_prev:	dcb.b 1
r_sf_scroll_y_prev:	dcb.b 1

