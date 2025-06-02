	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

	include "machine.inc"
	include "mad.inc"

	global layer_a_tile_viewer

	section code

TILE_OFFSET_MASK	equ $fff

layer_a_tile_viewer:
		PSUB	screen_init

		; shift over layer a so its the same offset as fix
		lda	#$6
		sta	REG_LAYER_A_SCROLL_X

		ldy	#LAYER_A_TILE_PALETTE + (PALETTE_SIZE * TVC_PALETTE_NUM)
		jsr	tvc_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_title
		PSUB	print_string

		ldd	#$100
		ldw	#TILE_OFFSET_MASK
		ldx	#layer_a_seek_xy_cb
		ldy	#tvc_draw_tile_cb
		jsr	tile8_viewer_handler
		rts

layer_a_seek_xy_cb:
		PSUB	screen_seek_xy

		; convert fix location to layer a
		leax	$800, x
		rts

	section data

d_str_title: 	STRING "LAYER A TILE VIEWER"
