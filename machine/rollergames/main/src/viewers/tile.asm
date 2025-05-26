	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/macros.inc"
	include "cpu/konami2/include/xy_string.inc"

	include "machine.inc"
	include "mad.inc"

	global tile_viewer

	section code

TILE_OFFSET_MASK	equ $fff
PALETTE_NUM		equ $1

tile_viewer:
		RSUB	screen_init
		jsr	palette_setup

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_title
		RSUB	print_string

		ldd	#TILE_OFFSET_MASK
		ldx	#seek_xy_cb
		ldy	#draw_tile_cb
		jsr	tile8_viewer_handler
		rts

seek_xy_cb:
		RSUB	screen_seek_xy
		rts

	section data

d_str_title: 	STRING "TILE VIEWER"


; Palette Layout
;  xBBB BBGG GGGR RRRR
palette_setup:

		ldx	#d_palette_data
		ldy	#TILE_PALETTE + (PALETTE_SIZE * PALETTE_NUM)
		ldb	#PALETTE_SIZE
	.loop_next_color:
		lda	,x+
		sta	,y+
		decb
		bne	.loop_next_color
		rts

; params:
;  d = tile (word)
;  0000 TTTT TTTT TTTT
;  T = tile num
;  x = already at location in tile ram
;  00PP TTTT TTTT TTTT
;  P = palette num
;  T = tile num
draw_tile_cb:
		exg	b, a
		RSUB	print_byte

		tfr	b, a
		ora	#(PALETTE_NUM<<4)
		sta	$400, x
		rts

	section data

d_palette_data:
	dc.w	$0000, $6d39, $3e34, $fe00, $5864, $8064, $e519, $d126
	dc.w	$ffff, $8271, $0e78, $aa39, $f725, $0e5e, $9532, $e277

	section bss

r_tvc_bank_num:		dcb.b 1
