	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_write.inc"

	global sprite_debug

	section code

HIGHLIGHT_PALETTE_NUM	equ $1

sprite_debug:
		call	sprite_viewer_palette_setup

		ld	hl, d_palette_data
		ld	(r_nmi_copy_src), hl
		ld	hl, FIX_TILE_PALETTE + (FIX_TILE_PALETTE_SIZE / 2)
		ld	(r_nmi_copy_dst), hl
		ld	a, FIX_TILE_PALETTE_SIZE / 2
		ld	(r_nmi_copy_size), a
		call	wait_nmi_copy

		ld	hl, d_palette_ext_data
		ld	(r_nmi_copy_src), hl
		ld	hl, FIX_TILE_PALETTE_EXT + (FIX_TILE_PALETTE_SIZE / 2)
		ld	(r_nmi_copy_dst), hl
		ld	a, FIX_TILE_PALETTE_SIZE / 2
		ld	(r_nmi_copy_size), a
		call	wait_nmi_copy

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 13)
		ld	de, d_str_last_written
		RSUB	print_string

		ld	hl, FIX_TILE_ATTR
		ld	(r_old_highlight), hl

		RS_SD_SETUP

		ld	a, CTRL_RS_BASE|CTRL_NMI_ENABLE|CTRL_SND_RESET_OFF
		ld	(REG_CONTROL), a

		ld	ix, d_mw_settings
		call	memory_write_handler

		ld	bc, $f8
		ld	(SPRITE_RAM), bc
		ld	(SPRITE_RAM + 2), bc

		ld	bc, $3ff
		RSUB	delay

		ld	a, CTRL_RS_BASE|CTRL_NMI_DISABLE|CTRL_SND_RESET_OFF
		ld	(REG_CONTROL), a

		ret

; hl = location in video ram
highlight_cb:
		ld	iy, (r_old_highlight)
		ld	(iy), $0

		ld	bc, $400
		add	hl, bc
		ld	(hl), HIGHLIGHT_PALETTE_NUM
		ld	(r_old_highlight), hl
		ret

write_memory_cb:
		ld	iy, r_mw_buffer
		ld	a, SCREEN_START_X
		ld	(r_x_offset), a
		ld	b, $4
	.loop_next_byte_print:
		push	bc
		ld	a, (r_x_offset)
		ld	b, a
		add	a, $3
		ld	(r_x_offset), a
		ld	c, SCREEN_START_Y + 15
		RSUB	screen_seek_xy

		ld	a, (iy)
		ld	c, a
		RSUB	print_hex_byte
		inc	ix
		inc	iy
		pop	bc
		djnz	.loop_next_byte_print

		ld	iy, r_mw_buffer
		ld	ix, SPRITE_RAM

		ld	b, $4
	.loop_next_byte_sprite:
		ld	a, (iy)
		ld	(ix), a
		inc	ix
		inc	iy
		djnz	.loop_next_byte_sprite
		ret

loop_cb:
		ret

	section data

d_mw_settings:		MW_SETTINGS 4, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
d_str_last_written:	STRING "LAST WRITTEN"

d_palette_data:
	dc.b	$00, $f0, $00, $00

d_palette_ext_data:
	dc.b	$00, $00, $00, $00

	section bss

r_mw_buffer:		dcb.b 4
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
