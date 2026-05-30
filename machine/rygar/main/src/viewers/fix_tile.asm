	include "cpu/z80/include/common.inc"

	global fix_tile_viewer

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK_UPPER	equ $3

fix_tile_viewer:
		ld	hl, d_palette_data
		ld	de, FIX_TILE_PALETTE + (PALETTE_SIZE * PALETTE_NUM)
		ld	bc, PALETTE_SIZE
		ldir

		ld	b, $0
		ld	c, TILE_OFFSET_MASK_UPPER
		ld	ix, seek_xy_cb
		ld	iy, draw_tile_cb
		call	tile_8x8_viewer_handler
		ret

seek_xy_cb:
		RSUB	screen_seek_xy
		ret

; params:
;  bc = tile (word)
;  hl = already at location in tile ram
; fix ram        = TTTT TTTT
; fix ram + $400 = PPPP xxTT 
draw_tile_cb:
		ld	(hl), c

		ld	a, b

		ld	bc, $400
		add	hl, bc

		or	PALETTE_NUM<<4
		ld	(hl), a
		ret

	section data

d_palette_data:
	dc.w	$0000, $5000, $7000, $9000, $b000, $d000, $f700, $ff00
	dc.w	$c907, $fb09, $a705, $f900, $fc00, $0000, $0000, $ff0f
