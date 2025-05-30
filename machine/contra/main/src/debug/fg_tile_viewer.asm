	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

	include "machine.inc"

	global fg_tile_viewer

	section code

; Not 100% clear how palettes work.  It seems like each tilemap device can have
; a single palette number assigned to it.  For below we are just using the same
; palette number as what we use for text.

PALETTE_NUM		equ $1
TILE_OFFSET_MASK	equ $1fff

fg_tile_viewer:
		PSUB	screen_init
		bsr	fg_palette_setup

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_title
		PSUB	print_string

		ldd	#$0
		ldw	#TILE_OFFSET_MASK
		ldx	#fg_seek_xy_cb
		ldy	#fg_draw_tile_cb
		jsr	tile8_viewer_handler
		rts

; Palette Layout
;  xBBB BBGG GGGR RRRR
fg_palette_setup:

		ldx	#d_palette_data
		ldy	#(PALETTE_RAM+(PALETTE_SIZE*PALETTE_NUM))
		lde	#(PALETTE_SIZE/2)

	.loop_next_color:
		ldd	,x++
		std	,y++
		dece
		bne	.loop_next_color
		rts


fg_seek_xy_cb:
		PSUB	screen_seek_xy
		rts

; params:
;  d = tile (word)
;  x = already at location in tile ram
; TTTT T??? TTTT TTTT
fg_draw_tile_cb:
		exg	b, a
		PSUB	print_byte

		lslb
		lslb
		lslb
	.not_set:
		stb	-$400, x
		rts

	section data

d_palette_data:
	dc.w	$0000, $6d39, $3e34, $fe00, $5864, $8064, $e519
	dc.w	$d126, $e277, $8271, $0e78, $aa39, $f725, $0e5e
	dc.w	$9532, $ffff

d_str_title: 	STRING "FG TILE VIEWER"
