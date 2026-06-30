	include "cpu/68000/include/common.inc"

	global bg_tile_viewer
	global bg_tile_viewer_palette_setup

	section code

bg_tile_viewer:
		bsr	bg_tile_viewer_palette_setup

		move.w	#$8, REG_BG_SCROLL_Y
		move.w	#$0, REG_BG_SCROLL_X

		moveq	#0, d0
		move.w	#$7ff, d1
		lea	seek_xy_cb, a0
		lea	draw_tile_cb, a1
		bsr	tile_8x8_viewer_handler

		move.w	#$0, REG_BG_SCROLL_Y
		move.w	#$0, REG_BG_SCROLL_X

		rts

bg_tile_viewer_palette_setup:

		CPU_INTS_ENABLE

		move.l	#d_palette_data, r_vblank_copy_src
		move.l	#BG_TILE_PALETTE, r_vblank_copy_dst
		move.w	#(BG_TILE_PALETTE_SIZE / 2), r_vblank_copy_size
		jsr	wait_vblank_copy

		CPU_INTS_DISABLE
		rts

seek_xy_cb:
		lsl.l	#$2, d0
		lsl.l	#$8, d1
		lea	$f4300, a6
		adda.l	d0, a6
		adda.l	d1, a6
		rts

; params:
;  d0 = tile (word)
;  a6 = already at location in fg ram
; Tile Layout
;  bg tile ram = xxxx xxxx TTTT TTTT
;  bg tile ram + 2 = xxxx xxxx XYLP PTTT 
;   X = flip x
;   Y = flip y
;   L = layer
;   P = palette number
;   T = tile number
draw_tile_cb:
		move.b	d0, (1, a6)
		lsr.w	#$8, d0
		move.b	d0, (3, a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$0004, $ddf4, $acf4, $7af4, $9994, $0004, $0004, $7774
	dc.w	$c004, $9004, $dd04, $aa04, $8804, $aa04, $1114, $4054
