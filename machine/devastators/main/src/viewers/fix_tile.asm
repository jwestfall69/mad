	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/dsub.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/xy_string.inc"

	include "machine.inc"
	include "mad.inc"

	global fix_tile_viewer

	section code

TILE_OFFSET_MASK	equ $1fff

fix_tile_viewer:
		RSUB	screen_init

		ldy	#FIX_TILE_PALETTE + (PALETTE_SIZE * TVC_PALETTE_NUM)
		jsr	tvc_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_title
		RSUB	print_string

		clrd
		ldw	#TILE_OFFSET_MASK
		ldx	#fix_seek_xy_cb
		ldy	#tvc_draw_tile_cb
		jsr	tile8_viewer_handler
		rts

fix_seek_xy_cb:
		RSUB	screen_seek_xy
		rts

	section data

d_str_title: 	STRING "FIX TILE VIEWER"
