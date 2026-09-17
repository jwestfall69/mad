	include "cpu/6809/include/common.inc"

	global tile_viewer

	section code

; no need to setup palettes as palette colors are hardcoded on this board
TILE_OFFSET_MASK	equ $3ff

tile_viewer:
		ldd	#TILE_OFFSET_MASK
		ldx	#seek_xy_cb
		ldy	#draw_tile_cb
		jsr	tile_8x8_viewer_handler
		rts

seek_xy_cb:
		RSUB	screen_seek_xy
		rts

; params:
;  d = tile (word)
;  x = already at location in tile ram
;  tile ram  = TTTT TTTT 
;  color ram = TTYX PPPP 
draw_tile_cb:

		stb	, x
		tfr	a, b

		andcc	#$fe
		rora
		rora
		rora
		anda	#$c0
		sta	-$800, x

		andcc	#$fe
		rorb
		rorb
		andb	#$3
		rts
