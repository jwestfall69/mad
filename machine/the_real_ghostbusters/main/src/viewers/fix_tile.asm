	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

	include "machine.inc"

	global fix_tile_viewer

	section code

; no need to setup palettes as palette colors are hardcoded on this board
TILE_OFFSET_MASK	equ $3ff

fix_tile_viewer:
		PSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_title
		PSUB	print_string

		ldd	#$0
		ldw	#TILE_OFFSET_MASK
		ldx	#fix_seek_xy_cb
		ldy	#fix_draw_tile_cb
		jsr	tile8_viewer_handler
		rts

fix_seek_xy_cb:
		PSUB	screen_seek_xy
		rts

; params:
;  d = tile (word)
;  x = already at location in tile ram
;  ???? PPTT TTTT TTTT
fix_draw_tile_cb:
		std	,x
		rts

	section data

d_str_title: 	STRING "FIX TILE VIEWER"
