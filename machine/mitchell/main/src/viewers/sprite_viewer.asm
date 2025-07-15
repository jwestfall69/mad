	include "cpu/z80/include/common.inc"

	global sprite_viewer
	global sprite_viewer_palette_setup

	section code

sprite_viewer:
		ret


sprite_viewer_palette_setup:
		ld	a, CTRL_ENABLE_SPRITE_ROMS|CTRL_ENABLE_TILE_ROMS|CTRL_PALETTE_WRITE_REQUEST
		out	(IO_CONTROL), a

		ld	bc, $7ff
		RSUB	delay
;		RSUB	screen_wait_palette_enable

		ld	hl, d_romset_sprite_palette_data
		ld	de, SPRITE_PALETTE
		ld	bc, PALETTE_SIZE
		ldir

		ld	a, CTRL_ENABLE_SPRITE_ROMS|CTRL_ENABLE_TILE_ROMS
		out	(IO_CONTROL), a
		ret
