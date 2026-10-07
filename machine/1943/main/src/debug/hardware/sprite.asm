	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_write.inc"

	global sprite_debug

	section code

HIGHLIGHT_PALETTE_NUM	equ $8

sprite_debug:
		ld	bc, $3ff
		RSUB	delay

		ld	hl, FIX_TILE_ATTR
		ld	(r_old_highlight), hl

		; setup initial values
		ld	ix, r_mw_buffer
		ld	(ix + 0), $2c
		ld	(ix + 1), $03
		ld	(ix + 2), $b0
		ld	(ix + 3), $b0

		ld	a, LAYER_SPRITE_ENABLE
		ld	(REG_LAYER), a

		ei

		ld	ix, d_mw_settings
		call	memory_write_handler

		di

		ld	a, $0
		ld	(REG_LAYER), a
		ret

; params:
;  hl = location in video ram
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		ld	iy, (r_old_highlight)
		ld	(iy), $0

		ld	bc, $400
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
