	include "cpu/z80/include/common.inc"

	global fg_tile_viewer

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK_UPPER	equ $7

fg_tile_viewer:
		ld	hl, d_palette_data
		ld	de, FG_TILE_PALETTE + (PALETTE_SIZE * PALETTE_NUM)
		ld	bc, PALETTE_SIZE
		ldir

		ld	bc, $8
		ld	(REG_FG_SCROLL_X), bc
		ld	a, $8
		ld	(REG_FG_SCROLL_Y), a

		ld	b, $0
		ld	c, TILE_OFFSET_MASK_UPPER
		ld	ix, seek_xy_cb
		ld	iy, draw_tile_cb
		call	tile_16x16_viewer_handler
		ret

; b = x
; c = y
seek_xy_cb:
		ld	hl, FG_TILE_RAM + $23
		srl	b
		srl	c
		ld	a, b

		; y offset
		ld	b, c
		ld	c, $0
		sra	b
		rr	c
		sra	b
		rr	c
		sra	b
		rr	c
		add	hl, bc

		; x offset
		ld	b, $0
		ld	c, a
		add	hl, bc
		ret

; params:
;  bc = tile (word)
;  hl = already at location in tile ram
; fg ram        = TTTT TTTT
; fg ram + $200 = PPPP xTTT 
draw_tile_cb:
		ld	(hl), c

		ld	a, b

		ld	bc, $200
		add	hl, bc

		or	PALETTE_NUM<<4
		ld	(hl), a
		ret

	section data

d_palette_data:
	dc.w	$0000, $6401, $9602, $b804, $da06, $fd08, $ff00, $ff0f
	dc.w	$c904, $0302, $0604, $0905, $4b07, $7e0b, $7b0e, $990f
