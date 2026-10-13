	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_write.inc"

	global io_debug

	section code

HIGHLIGHT_PALETTE_NUM	equ $1

io_debug:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		call	sprite_viewer_palette_setup
		call	bg_tile_viewer_palette_setup


.loop_palette_write_error:
		out	(IO_PAL_WRITE_ERROR_CLEAR), a
		ld	a, $f0

		ld	(FIX_TILE_PALETTE + (FIX_TILE_PALETTE_SIZE / 2) + 1), a

		in	a, (IO_INPUT_SYS)
		bit	SYS_PAL_WRITE_ERROR_BIT, a
		jr	z, .loop_palette_write_error

		ld	hl, FIX_TILE_ATTR
		ld	(r_old_highlight), hl

		; setup initial values
		ld	ix, r_mw_buffer
		ld	(ix + 0), $00	; io 04
		ld	(ix + 1), $00	; io 0c

		ld	ix, SPRITE_RAM
		ld	(ix + 0), $22
		ld	(ix + 1), $01
		ld	(ix + 2), $80
		ld	(ix + 3), $80

		ld	ix, BG_TILE_RAM + $10c
		ld	(ix + 0), $23
		ld	(ix + 1), $08

		ei

		ld	ix, d_mw_settings
		call	memory_write_handler

		di

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

		ld	a, (r_mw_buffer)
		out	($04), a
		SEEK_XY	(SCREEN_START_X + 18), (SCREEN_START_Y + 4)
		ld	c, a
		RSUB	print_hex_byte

		ld	a, (r_mw_buffer + 1)
		out	($0c), a
		SEEK_XY	(SCREEN_START_X + 18), (SCREEN_START_Y + 5)
		ld	c, a
		RSUB	print_hex_byte
;		ld	ix, SPRITE_RAM
;		call	memory_write_generic_write
loop_cb:
		ret

	section data

d_mw_settings:		MW_SETTINGS 2, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_screen_xys_list:
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 2), "IO  LW"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "04"
			XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 5), "0C"
			XY_STRING_LIST_END

	section bss

r_mw_buffer:		dcb.b 2
r_old_highlight:	dcb.w 1
