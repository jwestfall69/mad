	include "global/include/macros.inc"
	include "global/include/screen.inc"

	include "cpu/6x09/include/macros.inc"
	include "cpu/6x09/include/xy_string.inc"

	include "cpu/6309/include/dsub.inc"

	include "machine.inc"

	global bac06_tile_viewer

	section code

; no need to setup palettes as palette colors are hardcoded on this board
TILE_OFFSET_MASK	equ $7ff

bac06_tile_viewer:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_title
		RSUB	print_string

		ldd	#$0
		ldw	#TILE_OFFSET_MASK
		ldx	#bac06_seek_xy_cb
		ldy	#bac06_draw_tile_cb
		jsr	tile_16x16_viewer_handler
		rts


; params:
;  a = x
;  b = y
bac06_seek_xy_cb:
		ldx	#BAC06_RAM
		leax	a, x

		tfr 	b, a
		clrb
		rord
		rord
		rord
		rord
		leax	d, x
		rts

; params:
;  d = tile (word)
;  x = already at location in tile ram
;  ???? TTTT TTTT TTTT
bac06_draw_tile_cb:
		std	,x
		rts

	section data

d_str_title: 	STRING "BAC06 TILE VIEWER"
