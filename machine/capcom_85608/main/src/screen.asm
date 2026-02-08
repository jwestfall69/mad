	include "cpu/z80/include/common.inc"

	global palette_init_no_nmi_dsub
	global palette_init_nmi
	global screen_init_dsub
	global screen_seek_xy_dsub

	section code


palette_init_no_nmi_dsub:
		exx
		ld	hl, PALETTE_RAM
		ld	de, PALETTE_RAM_SIZE
		ld	c, $0
		NSUB	memory_fill

		ld	hl, PALETTE_EXT_RAM
		ld	de, PALETTE_EXT_RAM_SIZE
		ld	c, $0
		NSUB	memory_fill

		; both games have the same text color index
		ld	a, $ff
		ld	(FIX_TILE_PALETTE + 1), a
		ld	(FIX_TILE_PALETTE_EXT + 1), a
		DSUB_RETURN

palette_init_nmi:
		ld	a, $0
		ld	(r_nmi_copy_size), a
		ld	b, $10
		ld	hl, PALETTE_RAM
		ld	de, d_palette_data

	.loop_next_palette_block:
		ld	(r_nmi_copy_src), de
		ld	(r_nmi_copy_dst), hl
		ld	a, $80
		ld	(r_nmi_copy_size), a

		call	wait_nmi_copy

		push	bc
		ld	bc, $80
		add	hl, bc
		pop	bc
		djnz	.loop_next_palette_block

		ld	de, d_palette_data_text
		ld	(r_nmi_copy_src), de
		ld	hl, FIX_TILE_PALETTE + 1
		ld	(r_nmi_copy_dst), hl
		ld	a, $1
		ld	(r_nmi_copy_size), a

		call	wait_nmi_copy

		ld	(r_nmi_copy_src), de
		ld	hl, FIX_TILE_PALETTE_EXT + 1
		ld	(r_nmi_copy_dst), hl
		ld	a, $1
		ld	(r_nmi_copy_size), a

		call	wait_nmi_copy
		ret

screen_init_dsub:
		exx

		ld	hl, FIX_TILE
		ld	de, FIX_TILE_SIZE
		ld	c, $20
		NSUB	memory_fill

		ld	hl, FIX_TILE_ATTR
		ld	de, FIX_TILE_ATTR_SIZE
		ld	c, $0
		NSUB	memory_fill

		ld	hl, BG_TILE_RAM
		ld	de, BG_TILE_RAM_SIZE
		ld	c, $0
		NSUB	memory_fill

		ld	hl, SPRITE_RAM
		ld	de, SPRITE_RAM_SIZE
		ld	c, $f8
		NSUB	memory_fill

	ifd _SCREEN_TATE_
		SEEK_XY	0, 0
	else
		SEEK_XY	1, 0
	endif
		ld	de, d_str_version
		NSUB	print_string

		SEEK_XY	0, 1
		ld	c, CHAR_DASH
		ld	b, SCREEN_NUM_COLUMNS
		NSUB	print_char_repeat

		SEEK_XY	((SCREEN_NUM_COLUMNS - _ROMSET_STR_LENGTH_) - 1), 1
		ld	de, d_str_romset
		NSUB	print_string
		DSUB_RETURN

; b = x
; c = y
screen_seek_xy_dsub:
		exx

		SEEK_XY	0, 0

	ifd _SCREEN_TATE_
		ld	a, b
		ld	b, $0
		or	a	; clear carry
		sbc	hl, bc
	else
		ld	a, c
		ld	c, b
		ld	b, 0
		or	a	; clear carry
		add	hl, bc
	endif

		ld	c, a
		sla	c
		rl	b
		sla	c
		rl	b
		sla	c
		rl	b
		sla	c
		rl	b
		sla	c
		rl	b
		add	hl, bc
		DSUB_RETURN

	section data

d_palette_data:
	dcb.b	$80, $0
d_palette_data_text:
	dc.b	$ff
