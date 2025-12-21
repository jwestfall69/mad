	include "cpu/6809/include/common.inc"

	global bg_tile_viewer

	section code

; no need to setup palettes as palette colors are hardcoded on this board
TILE_OFFSET_MASK	equ $3ff

bg_tile_viewer:
		ldd	#TILE_OFFSET_MASK
		ldx	#bg_seek_xy_cb
		ldy	#bg_draw_tile_cb
		jsr	tile_16x16_viewer_handler
		rts

bg_seek_xy_cb:
		ldx	#BG_RAM
		leax	b, x
		tfr	a, b
		clra
		lslb
		rola
		lslb
		rola
		lslb
		rola
		lslb
		rola
		leax	d, x
		rts

; params:
;  d = tile (word)
;  x = already at location in tile ram
;  TTTT TTTT ???? ?PTT
bg_draw_tile_cb:
		exg	a, b
		orb	#$4
		std	, x
		rts
