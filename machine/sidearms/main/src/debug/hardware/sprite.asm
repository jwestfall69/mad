	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_write.inc"

	global sprite_debug

	section code

HIGHLIGHT_PALETTE_NUM	equ $1

sprite_debug:
		call	sprite_viewer_palette_setup

.loop_palette_write_error:
		ld	(REG_PAL_WRITE_ERROR_CLEAR), a
		ld	a, $f0

		ld	(FIX_TILE_PALETTE + (FIX_TILE_PALETTE_SIZE / 2) + 1), a

		ld	a, (REG_INPUT_SYS)
		bit	SYS_PAL_WRITE_ERROR_BIT, a
		jr	z, .loop_palette_write_error

		ld	hl, FIX_TILE_ATTR
		ld	(r_old_highlight), hl

		; setup initial values
		ld	ix, r_mw_buffer
		ld	(ix + 0), $22
		ld	(ix + 1), $10
		ld	(ix + 2), $50
		ld	(ix + 3), $20

		ld	a, LAYER_SPRITE_ENABLE
		ld	(REG_LAYER), a

		ei

		ld	ix, d_mw_settings
		call	memory_write_handler

		di

		ld	a, $0
		ld	(REG_LAYER), a

		ret

; hl = location in video ram
highlight_cb:
		ld	iy, (r_old_highlight)
		ld	(iy), $0

		ld	bc, $800
		add	hl, bc
		ld	(hl), HIGHLIGHT_PALETTE_NUM
		ld	(r_old_highlight), hl
		ret

write_memory_cb:
		ld	ix, SPRITE_RAM + $200
		call	memory_write_generic_write
loop_cb:
		ret

	section data

d_mw_settings:		MW_SETTINGS 4, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

	section bss

r_mw_buffer:		dcb.b 4
r_old_highlight:	dcb.w 1
