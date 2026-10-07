	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_write.inc"

	global sprite_debug

	section code

HIGHLIGHT_PALETTE_NUM	equ $8

sprite_debug:
		ld	hl, FIX_TILE_ATTR
		ld	(r_old_highlight), hl

		; setup initial values
		ld	ix, r_mw_buffer
		ld	(ix + 0), $80	; sprite num
		ld	(ix + 1), $00	; size + palette num
		ld	(ix + 2), $c0	; y pos
		ld	(ix + 3), $b0	; x pos

		ei

		ld	ix, d_mw_settings
		call	memory_write_handler
		call	sprite_ram_clear	; will di for us
		ret

; hl = location in video ram
highlight_cb:
		ld	iy, (r_old_highlight)
		ld	(iy), $01

		ld	bc, $400
		add	hl, bc
		ld	(hl), HIGHLIGHT_PALETTE_NUM
		ld	(r_old_highlight), hl
		ret

write_memory_cb:
		ld	ix, r_sprite_data
		call	memory_write_generic_write

		ld	a, $1 << SPRITE_REQ_COPY_BIT
		ld	(r_sprite_req), a
loop_cb:
		ret

	section data

d_mw_settings:		MW_SETTINGS 4, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

	section bss

r_mw_buffer:		dcb.b 4
r_old_highlight:	dcb.w 1
