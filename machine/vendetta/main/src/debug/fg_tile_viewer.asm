	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/macros.inc"
	include "cpu/konami2/include/xy_string.inc"

	include "machine.inc"

	global fg_tile_viewer

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK	equ $0fff

fg_tile_viewer:
		RSUB	screen_init
		bsr	fg_palette_setup

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_title
		RSUB	print_string

		ldd	#TILE_OFFSET_MASK
		ldx	#fg_seek_xy_cb
		ldy	#fg_draw_tile_cb
		jsr	tile8_viewer_handler
		rts

; Palette Layout
;  xBBB BBGG GGGR RRRR
fg_palette_setup:


		lda	#$1
		sta	REG_CONTROL

		ldx	#d_palette_data
		ldy	#(PALETTE_RAM_START + $400 + (PALETTE_SIZE*PALETTE_NUM))
		ldb	#PALETTE_SIZE

	.loop_next_color:
		lda	,x+
		sta	,y+
		decb
		bne	.loop_next_color

		lda	#$0
		sta	REG_CONTROL

		rts


fg_seek_xy_cb:
		RSUB	screen_seek_xy
		rts

; params:
;  d = tile (word)
;  x = already at location in tile ram
; PPTT ??TT TTTT TTTT
fg_draw_tile_cb:
		exg	b, a
		RSUB	print_byte

		tfr	b, a
		bita	#$4
		beq	.skip1
		ora	#$10
	.skip1:

		bita	#$8
		beq	.skip2
		ora	#$20
	.skip2:
		anda	#$33

		ora	#(PALETTE_NUM<<6)
		sta	-$2000, x
		rts

	section data

d_palette_data:
	dc.w	$1223, $6d39, $3e34, $fe00, $5864, $8064, $e519
	dc.w	$d126, $ffff, $8271, $0e78, $aa39, $f725, $0e5e
	dc.w	$9532, $e277

d_str_title: 	STRING "FG TILE VIEWER"
