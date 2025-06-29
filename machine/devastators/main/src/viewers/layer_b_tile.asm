	include "global/include/macros.inc"
	include "global/include/screen.inc"

	include "cpu/6x09/include/macros.inc"
	include "cpu/6x09/include/xy_string.inc"

	include "cpu/6309/include/dsub.inc"

	include "machine.inc"
	include "mad.inc"

	global layer_b_tile_viewer

	section code

TILE_OFFSET_MASK	equ $1fff

layer_b_tile_viewer:
		RSUB	screen_init

		; shift over layer b so its the same offset as fix
		lda	#$6
		sta	REG_LAYER_B_SCROLL_X

		ldy	#LAYER_B_TILE_PALETTE + (PALETTE_SIZE * TVC_PALETTE_NUM)
		jsr	tvc_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_title
		RSUB	print_string

		clrd
		ldw	#TILE_OFFSET_MASK
		ldx	#layer_b_seek_xy_cb
		ldy	#tvc_draw_tile_cb
		jsr	tile_8x8_viewer_handler
		rts

layer_b_seek_xy_cb:
		RSUB	screen_seek_xy

		; convert fix location to layer b
		leax	$1000, x
		rts

	section data

d_str_title:	STRING "LAYER B TILE VIEWER"
