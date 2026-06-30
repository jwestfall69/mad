	include "cpu/68000/include/common.inc"

	global fix_tile_viewer
	global fix_tile_viewer_palette_setup

	section code

fix_tile_viewer:
		bsr	fix_tile_viewer_palette_setup

		moveq	#0, d0
		move.w	#$3ff, d1
		lea	seek_xy_cb, a0
		lea	draw_tile_cb, a1
		bsr	tile_8x8_viewer_handler
		rts

fix_tile_viewer_palette_setup:

		CPU_INTS_ENABLE

		move.l	#d_palette_data, r_vblank_copy_src
		move.l	#(FIX_TILE_PALETTE + FIX_TILE_PALETTE_SIZE), r_vblank_copy_dst
		move.w	#(FIX_TILE_PALETTE_SIZE / 2), r_vblank_copy_size
		jsr	wait_vblank_copy

		CPU_INTS_DISABLE
		rts

seek_xy_cb:
		RSUB	screen_seek_xy
		rts

; params:
;  d0 = tile (word)
;  a6 = already at location in fg ram
; Tile Layout
; tile ram = xxxx xxxx TTTT TTTT
; tile ram + $800 = xxxx xxxx TTPP PPPP
;   P = palette number
;   T = tile number
draw_tile_cb:
		move.b	d0, ($1, a6)
		lsr.w	#$2, d0
		and.b	#$c0, d0
		or.b	#$1, d0
		move.b	d0, ($801, a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$111f, $0c95, $086f, $000f
