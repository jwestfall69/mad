	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_write.inc"

	global sprite_debug

	section code

HIGHLIGHT_PALETTE_NUM	equ $6

sprite_debug:
		ld	hl, FIX_TILE_ATTR
		ld	(r_old_highlight), hl

		; setup initial values
		ld	ix, r_mw_buffer
		ld	(ix + 0), $09
		ld	(ix + 1), $30
		ld	(ix + 2), $c0
		ld	(ix + 3), $b0

		ei

		ld	ix, d_mw_settings
		call	memory_write_handler

		di

		; zero out what we changed, and request a copy
		; to remove the sprite from the screen
		ld	bc, $0
		ld	(SPRITE_RAM), bc
		ld	(SPRITE_RAM + 2), bc
		call	wait_sprite_copy_request
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
		ld	ix, SPRITE_RAM
		call	memory_write_generic_write

		ld	a, $1
		ld	(r_sprite_copy_request), a
loop_cb:
		ret

	section data

d_mw_settings:		MW_SETTINGS 4, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

	section bss

r_mw_buffer:		dcb.b 4
r_old_highlight:	dcb.w 1
