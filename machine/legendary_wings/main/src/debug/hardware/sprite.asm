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

		ld	hl, FIX_TILE_ATTR
		ld	(r_old_highlight), hl

		; setup initial values
		ld	ix, r_mw_buffer
		ld	(ix + 0), $35
		ld	(ix + 1), $04
		ld	(ix + 2), $b0
		ld	(ix + 3), $b0

		ld	a, CTRL_NMI_ENABLE|CTRL_SND_RESET_OFF
		ld	(REG_CONTROL), a

		ld	ix, d_mw_settings
		call	memory_write_handler

		ld	bc, $f8
		ld	(SPRITE_RAM), bc
		ld	(SPRITE_RAM + 2), bc

		ld	bc, $3ff
		RSUB	delay

		ld	a, CTRL_NMI_DISABLE|CTRL_SND_RESET_OFF
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
		ld	ix, SPRITE_RAM
		call	memory_write_generic_write
loop_cb:
		ret

	section data

d_mw_settings:		MW_SETTINGS 4, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

; highlight palette colors
d_palette_data:
	dc.b	$00, $f0, $00, $00

d_palette_ext_data:
	dc.b	$00, $00, $00, $00

	section bss

r_mw_buffer:		dcb.b 4
r_old_highlight:	dcb.w 1
