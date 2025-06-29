	include "global/include/macros.inc"
	include "global/include/screen.inc"

	include "cpu/6x09/include/macros.inc"

	include "cpu/konami2/include/dsub.inc"

	include "machine.inc"
	include "mad.inc"

	global layer_a_tile_viewer

	section code

TILE_OFFSET_MASK	equ $7fff

layer_a_tile_viewer:
		RSUB	screen_init

		ldy	#LAYER_A_TILE_PALETTE + (PALETTE_SIZE * TVC_PALETTE_NUM)
		jsr	tvc_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_title
		RSUB	print_string

		ldd	#TILE_OFFSET_MASK
		ldx	#layer_a_seek_xy_cb
		ldy	#tvc_draw_tile_cb
		jsr	tile_8x8_viewer_handler
		rts

layer_a_seek_xy_cb:
		RSUB	screen_seek_xy

		; convert fix location to layer a
		leax	$800, x
		rts

	section data

d_str_title:	STRING "LAYER A TILE VIEWER"
