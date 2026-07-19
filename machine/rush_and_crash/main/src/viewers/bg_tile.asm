	include "cpu/6809/include/common.inc"

	global bg_tile_viewer

	section code

; no need to setup palettes as palette colors are hardcoded on this board
TILE_OFFSET_MASK	equ $3ff

bg_tile_viewer:

		ldd	#$800
		std	REG_BG_TILE_SCROLL_X
		std	REG_BG_TILE_SCROLL_Y

		CPU_INTS_ENABLE

		ldd	#d_palette_data
		std	r_vblank_copy_src
		ldd	#BG_TILE_PALETTE + BG_TILE_PALETTE_SIZE
		std	r_vblank_copy_dst
		ldd	#BG_TILE_PALETTE_SIZE
		std	r_vblank_copy_size

		jsr	wait_vblank_copy

		CPU_INTS_DISABLE


		ldd	#TILE_OFFSET_MASK
		ldx	#bg_seek_xy_cb
		ldy	#bg_draw_tile_cb
		jsr	tile_16x16_viewer_handler
		rts

bg_seek_xy_cb:
		ldx	#$2282
		;asla
		leax	a, x

		stb	r_scratch
		ldb	#SCREEN_NUM_ROWS
		subb	r_scratch

		clra
		exg	b, a
		rora
		rorb
		rora
		rorb
		leax	d, x
		rts

; params:
;  d = tile (word)
;  x = already at location in tile ram
;  PPP? YTTT TTTT TTTT 
bg_draw_tile_cb:
		ora	#$20
		std	, x
		rts

	section data

d_palette_data:
	dc.w	$0000, $8750, $9860, $a970, $ba80, $8600, $a700, $c960
	dc.w	$eb70, $fd80, $ffa0, $a700, $c960, $eb70, $fd80, $7870
