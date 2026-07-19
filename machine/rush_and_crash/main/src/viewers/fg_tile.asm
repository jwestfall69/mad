	include "cpu/6809/include/common.inc"

	global fg_tile_viewer

	section code

; no need to setup palettes as palette colors are hardcoded on this board
TILE_OFFSET_MASK	equ $3ff

fg_tile_viewer:

		CPU_INTS_ENABLE

		ldd	#d_palette_data
		std	r_vblank_copy_src
		ldd	#FG_TILE_PALETTE + FG_TILE_PALETTE_SIZE
		std	r_vblank_copy_dst
		ldd	#FG_TILE_PALETTE_SIZE
		std	r_vblank_copy_size

		jsr	wait_vblank_copy

		CPU_INTS_DISABLE

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
;  ?LPP PPTT TTTT TTTT
fg_draw_tile_cb:
		ora	#$4
		std	,x
		rts

	section data

d_palette_data:
	dc.w	$33f0, $df00, $06c0, $0000
