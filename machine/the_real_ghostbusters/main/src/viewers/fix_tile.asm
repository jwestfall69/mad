	include "cpu/6309/include/common.inc"

	global fix_tile_viewer

	section code

; no need to setup palettes as palette colors are hardcoded on this board
TILE_OFFSET_MASK	equ $3ff

fix_tile_viewer:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_title
		RSUB	print_string

		ldd	#TILE_OFFSET_MASK
		ldx	#fix_seek_xy_cb
		ldy	#fix_draw_tile_cb
		jsr	tile_8x8_viewer_handler
		rts

fix_seek_xy_cb:
		RSUB	screen_seek_xy
		rts

; params:
;  d = tile (word)
;  x = already at location in tile ram
;  ???? PPTT TTTT TTTT
fix_draw_tile_cb:
		std	,x
		rts

	section data

d_str_title:	STRING "FIX TILE VIEWER"
