	include "cpu/konami2/include/common.inc"

	global fix_tile_viewer

	section code

TILE_OFFSET_MASK	equ $3fff

fix_tile_viewer:
		RSUB	screen_init

		ldy	#FIX_TILE_PALETTE + (PALETTE_SIZE * TVC_PALETTE_NUM)
		jsr	tvc_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_title
		RSUB	print_string

		ldd	#TILE_OFFSET_MASK
		ldx	#fix_seek_xy_cb
		ldy	#tvc_draw_tile_cb
		jsr	tile_8x8_viewer_handler
		rts

fix_seek_xy_cb:
		RSUB	screen_seek_xy
		rts

	section data

d_str_title:	STRING "FIX TILE VIEWER"
