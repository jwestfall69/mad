	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_write.inc"

	global sprite_debug

	section code

HIGHLIGHT_PALETTE_NUM	equ $1

sprite_debug:
		call	sprite_viewer_palette_setup

		ld	hl, FIX_TILE_ATTR
		ld	(r_old_highlight), hl
		ld	a, $f0
		ld	(FIX_TILE_PALETTE + PALETTE_SIZE + $f), a

		; setup initial values
		ld	ix, r_mw_buffer
		ld	(ix + 0), $04
		ld	(ix + 1), $10
		ld	(ix + 2), $02
		ld	(ix + 3), $40
		ld	(ix + 4), $58
		ld	(ix + 5), $a0
		ld	(ix + 6), $0
		ld	(ix + 7), $0

		ld	ix, d_mw_settings
		call	memory_write_handler
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
		ld	(hl), HIGHLIGHT_PALETTE_NUM<<4
		ld	(r_old_highlight), hl
		ret

write_memory_cb:
		ld	ix, SPRITE_RAM
		call	memory_write_generic_write
loop_cb:
		ret

	section data

d_mw_settings:		MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

	section bss

r_mw_buffer:		dcb.b 8
r_old_highlight:	dcb.w 1
