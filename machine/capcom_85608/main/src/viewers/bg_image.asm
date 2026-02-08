	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/values_edit.inc"

	global bg_image_viewer

	section code

bg_image_viewer:
		ld	de, d_screen_xys_list
		call	print_xy_string_list
		call	bg_image_palette_setup

		ld	a, $0
		ld	(r_bg_image), a
		ld	(REG_BG_IMAGE), a

		ld	ix, d_ve_settings
		ld	iy, d_ve_list

		call	values_edit_handler

		ld	a, $3f
		ld	(REG_BG_IMAGE), a
		ret

value_changed_cb:
		ld	a, (r_bg_image)
		ld	(REG_BG_IMAGE), a
		ret

loop_input_cb:
		ret

bg_image_palette_setup:
		ld	hl, BG_IMAGE_PALETTE
		ld	b, $b
	.loop_next_palette_block:
		ld	de, d_palette_data
		ld	(r_nmi_copy_src), de
		ld	(r_nmi_copy_dst), hl
		ld	a, BG_IMAGE_PALETTE_SIZE / 2
		ld	(r_nmi_copy_size), a
		call	wait_nmi_copy

		push	bc
		ld	bc, $10
		add	hl, bc
		pop	bc

		djnz	.loop_next_palette_block

		ld	hl, BG_IMAGE_PALETTE_EXT
		ld	(r_nmi_copy_dst), hl
		ld	b, $b
	.loop_next_palette_ext_block:
		ld	de, d_palette_ext_data
		ld	(r_nmi_copy_src), de
		ld	(r_nmi_copy_dst), hl
		ld	a, BG_IMAGE_PALETTE_SIZE / 2
		ld	(r_nmi_copy_size), a
		call	wait_nmi_copy

		push	bc
		ld	bc, $10
		add	hl, bc
		pop	bc

		djnz	.loop_next_palette_ext_block
		ret

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_EDGE, r_bg_image, $3f
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "IMAGE NUM"
	XY_STRING_LIST_END

d_palette_data:
	RS_BG_IV_PALETTE_DATA

d_palette_ext_data:
	RS_BG_IV_PALETTE_EXT_DATA

	section bss

r_bg_image:		dcb.b 1
