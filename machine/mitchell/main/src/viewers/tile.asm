	include "cpu/z80/include/common.inc"

	global tile_viewer

	section code

PALETTE_NUM		equ $2
TILE_OFFSET_MASK_UPPER	equ $3f

tile_viewer:
		RSUB	screen_init
		call	palette_setup

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_title
		RSUB	print_string

		ld	b, $0
		ld	c, TILE_OFFSET_MASK_UPPER
		ld	de, seek_xy_cb
		ld	hl, draw_tile_cb
		call	tile8_viewer_handler
		ret

; Palette Layout
;  xxxx RRRR GGGG BBBB
palette_setup:
		ld	a, CTRL_ENABLE_SPRITE_ROMS|CTRL_ENABLE_TILE_ROMS|CTRL_PALETTE_WRITE_REQUEST
		out	(IO_CONTROL), a

		ld	bc, $7ff
		RSUB	delay

		ld	hl, d_palette_data
		ld	de, TILE_PALETTE + (PALETTE_SIZE * PALETTE_NUM)
		ld	bc, PALETTE_SIZE
		ldir

		ld	a, CTRL_ENABLE_SPRITE_ROMS|CTRL_ENABLE_TILE_ROMS
		out	(IO_CONTROL), a

		ret

seek_xy_cb:
		RSUB	screen_seek_xy
		ret

; params:
;  bc = tile (word)
;  hl = already at location in tile ram
; tile ram = TTTT TTTT TTTT TTTT
; color ram = xPPP PPPP
draw_tile_cb:

		; write tile
		ld	(hl), c
		inc	hl
		ld	(hl), b
		dec	hl

		; location in color ram is /2 the offset of
		; the location in tile ram
		ld	bc, $d000
		or	a	; clear carry
		sbc	hl, bc
		srl	h
		rr	l
		ld	bc, $c800
		add	hl, bc
		ld	(hl), PALETTE_NUM
		ret

	section data

d_palette_data:
	dc.w	$0817, $0ed0, $00bc, $0a35, $09d5, $009c, $0c66
	dc.w	$06c4, $0c64, $0b39, $02cb, $0e94, $036b, $04d8
	dc.w	$064c, $050d

d_str_title:	STRING "TILE VIEWER"
