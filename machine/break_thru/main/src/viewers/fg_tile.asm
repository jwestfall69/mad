	include "cpu/6809/include/common.inc"

	global fg_tile_viewer

	section code

; no need to setup palettes as palette colors are hardcoded on this board
TILE_OFFSET_MASK	equ $ff

fg_tile_viewer:
		ldd	#TILE_OFFSET_MASK
		ldx	#fg_seek_xy_cb
		ldy	#fg_draw_tile_cb
		jsr	tile_8x8_viewer_handler
		rts

fg_seek_xy_cb:
		RSUB	screen_seek_xy
		rts

; params:
;  d = tile (word)
;  x = already at location in tile ram
;  ???? PPTT TTTT TTTT
fg_draw_tile_cb:
		stb	,x
		rts
