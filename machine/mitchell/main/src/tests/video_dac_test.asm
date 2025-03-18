	include "cpu/z80/include/dsub.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/xy_string.inc"
	include "global/include/screen.inc"

	include "input.inc"
	include "mad.inc"
	include "machine.inc"

	global video_dac_test

	section code

video_dac_test:
		RSUB	screen_init

		ld	de, d_screen_xys_list
		call	print_xy_string_list

		; wait for vblank before palette writes.
		; There is a risk this might sometimes stall
		; on real hardware
	.loop_wait_vblank:
		in	a, (IO_INPUT_SYS2)
		cpl
		and	$08
		jr	z, .loop_wait_vblank

		; Palette Layout
		;  xxxx RRRR GGGG BBBB
		; red palette setup
		ld	ix, PALETTE_RAM_START + PALETTE_SIZE
		ld	bc, $0f00
		call	palette_color_setup

		; blue palette setup
		ld	ix, PALETTE_RAM_START + (PALETTE_SIZE * 2)
		ld	bc, $00f0
		call	palette_color_setup

		; green palette setup
		ld	ix, PALETTE_RAM_START + (PALETTE_SIZE * 3)
		ld	bc, $000f
		call	palette_color_setup

		; white/all palette setup
		ld	ix, PALETTE_RAM_START + (PALETTE_SIZE * 4)
		ld	bc, $0fff
		call	palette_color_setup

		call	generate_tiles_table
		call	draw_colors

	.loop_input:
		call	input_update
		ld	a, (r_input_edge)

		bit	INPUT_B1_BIT, a
		jr	z, .b1_not_pressed
		call	full_screen
		jr	video_dac_test

	.b1_not_pressed:
		bit	INPUT_B2_BIT, a
		jr	z, .loop_input
		ret

; In full screen mode we fill the entire tile ram with a single
; tile/color bit to allow isolating it for testing
MAX_COLOR_INDEX		equ (VD_NUM_COLORS - 1)
MAX_COLOR_BIT_INDEX	equ (VD_NUM_BITS_PER_COLOR - 1)
full_screen:

		; Treat r_tiles_table as a multidimensional array of
		;  word[VD_NUM_COLORS][VD_NUM_BITS_PER_COLOR]
		; where:
		;  b is the first index (color)
		;  c is the second index (color bit for that color)
		; start at [0][0], red bit 0
		ld	bc, $101

	.draw_full_screen:
		ld	ix, r_tiles_table
		push	bc

		; 2 bytes per tile
		sla	c

		; 2 bytes per tile * VD_NUM_BITS_PER_COLOR) = 10
		sla	b		; * 2
		ld	a, b		; backup 2
		sla	b		; * 2
		sla	b		; * 2
		add	b		; 8 + 2 = 10
		add	c		; add on c

		ld	b, 0
		ld	c, a
		add	ix, bc		; got the tile

		ld	b, (ix)		; palette number
		ld	c, (ix + 1)	; tile number

		ld	ix, COLOR_RAM_START
		ld	iy, TILE_RAM_START
		ld	de, COLOR_RAM_SIZE

	.loop_next_address:
		ld	(ix), b		; palette number to color ram
		inc	ix
		ld	(iy), c		; tile number to tile ram
		inc	iy
		ld	(iy), 0
		inc	iy
		dec	de
		ld	a, d
		or	e
		jr	nz, .loop_next_address

		pop	bc

	.loop_input:
		push	bc
		call	input_update
		pop	bc
		ld	a, (r_input_edge)

		bit	INPUT_UP_BIT, a
		jr	z, .up_not_pressed
		dec	b
		jp	p, .draw_full_screen
		ld	b, MAX_COLOR_INDEX
		jr	.draw_full_screen

	.up_not_pressed:
		bit	INPUT_DOWN_BIT, a
		jr	z, .down_not_pressed
		inc	b
		ld	a, b
		cp	MAX_COLOR_INDEX + 1
		jr	c, .draw_full_screen
		ld	b, 0
		jr	.draw_full_screen

	.down_not_pressed:
		bit	INPUT_LEFT_BIT, a
		jr	z, .left_not_pressed
		dec	c
		jp	p, .draw_full_screen
		ld	c, MAX_COLOR_BIT_INDEX
		jr	.draw_full_screen

	.left_not_pressed:
		bit	INPUT_RIGHT_BIT, a
		jr	z, .right_not_pressed
		inc	c
		ld	a, c
		cp	MAX_COLOR_BIT_INDEX + 1
		jp	c, .draw_full_screen
		ld	c, 0
		jr	.draw_full_screen

	.right_not_pressed:
		bit	INPUT_B2_BIT, a
		jr	z, .loop_input
		ret

; Given the raw tile numbers, generate a table that has
; the needed palette + tile number.  Tile numbers are 2
; bytes, but (so far) they are all less then $ff.  So
; we going to use the upper byte to store the palette
; number in our table.
generate_tiles_table:
		ld	ix, r_tiles_table
		ld	b, 1		; palette number
		ld	d, VD_NUM_COLORS

	.loop_next_color:
		ld	iy, d_tiles_raw
		ld	e, $5		; number of raw tiles

	.loop_next_raw_tile:
		ld	(ix), b		; pallete number
		inc	ix

		ld	a, (iy)
		inc	iy

		ld	(ix), a		; tile number (byte)
		inc	ix

		dec	e
		jr	nz, .loop_next_raw_tile

		inc	b
		dec	d
		jr	nz, .loop_next_color
		ret

COLOR_BLOCK_START_X	equ SCREEN_START_X + 2
COLOR_BLOCK_START_Y	equ SCREEN_START_Y + 3
draw_colors:
		ld	iy, r_tiles_table
		ld	a, COLOR_BLOCK_START_Y
		ld	(r_draw_colors_y_offset), a

		ld	d, VD_NUM_COLORS

	.loop_next_color:
		ld	a, COLOR_BLOCK_START_X
		ld	(r_draw_colors_x_offset), a
		ld	e, VD_NUM_BITS_PER_COLOR

	.loop_next_color_bit:
		ld	a, (r_draw_colors_x_offset)
		ld	b, a
		ld	a, (r_draw_colors_y_offset)
		ld	c, a
		RSUB	screen_seek_xy

		ld	b, (iy)
		inc	iy
		ld	c, (iy)
		inc	iy

		push	iy
		push	de
		call	draw_color_bit
		pop	de
		pop	iy

		ld	a, (r_draw_colors_x_offset)
		add	VD_COLOR_BLOCK_WIDTH
		ld	(r_draw_colors_x_offset), a
		dec	e
		jr	nz, .loop_next_color_bit

		ld	a, (r_draw_colors_y_offset)
		add	VD_COLOR_BLOCK_HEIGHT
		ld	(r_draw_colors_y_offset), a
		dec	d
		jr	nz, .loop_next_color

		ret

; draws an individual color bit
; params:
;  bc = tile (palette + tile)
;  hl = upper left loction in tile ram to start at
draw_color_bit:

		; palette number gets written to color ram
		; which is 1/2 the offset of tile ram.  figure
		; out the color ram location
		push	hl
		pop	ix

		ld	de, $d000
		sbc	hl, de
		srl	h
		rr	l
		ld	de, $c800
		add	hl, de
		push	hl
		pop	iy

		ld	e, VD_COLOR_BLOCK_HEIGHT

	.loop_next_row:
		ld	(ix), c
		ld	(ix + 1), 0
		ld	(ix + 2), c
		ld	(ix + 3), 0
		ld	(ix + 4), c
		ld	(ix + 5), 0
		ld	(ix + 6), c
		ld	(ix + 7), 0

		ld	(iy), b
		ld	(iy + 1), b
		ld	(iy + 2), b
		ld	(iy + 3), b

		push	bc
		ld	bc, SCREEN_BYTES_PER_LINE
		add	ix, bc

		ld	bc, SCREEN_BYTES_PER_LINE / 2
		add	iy, bc
		pop	bc

		dec	e
		jr	nz, .loop_next_row
		ret

; params:
;  bc = color's bits set to 1's
;  ix = palette start address
palette_color_setup:
		ld	iy, d_palette_offsets

		ld	(r_palette_color_bits), bc
		ld	l, VD_NUM_BITS_PER_COLOR - 1
		ld	a, $11
		ld	(r_palette_color_mask), a

		; zero out, will use for 16bit add
		ld	d, 0

	.loop_next_offset:
		; get ix to the right location in palette ram
		ld	e, (iy)
		inc	iy
		push	ix
		add	ix, de

		ld	bc, (r_palette_color_bits)
		ld	a, (r_palette_color_mask)
		and	c
		ld	(ix), a

		ld	a, (r_palette_color_mask)
		and	b
		ld	(ix + 1), a

		pop	ix

		ld	a, (r_palette_color_mask)
		sla	a
		ld	(r_palette_color_mask), a

		dec	l
		jr	nz, .loop_next_offset

		; finally do the full color with all bits
		ld	e, (iy)
		add	ix, de
		ld	bc, (r_palette_color_bits)
		ld	(ix), c
		ld	(ix + 1), b
		ret

	section data

d_palette_offsets:
	dc.b	VD_TILE_B0_PAL_OFFSET, VD_TILE_B1_PAL_OFFSET, VD_TILE_B2_PAL_OFFSET, VD_TILE_B3_PAL_OFFSET, VD_TILE_BA_PAL_OFFSET

d_tiles_raw:
	dc.b	VD_TILE_B0_NUM, VD_TILE_B1_NUM, VD_TILE_B2_NUM, VD_TILE_B3_NUM, VD_TILE_BA_NUM

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "VIDEO DAC TEST"
	XY_STRING (SCREEN_START_X + 3), (SCREEN_START_Y + 2), "B0  B1  B2  B3  ALL"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - FULL SCREEN"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

	section bss

r_draw_colors_x_offset:		dcb.b 1
r_draw_colors_y_offset:		dcb.b 1
r_palette_color_bits:		dcb.w 1
r_palette_color_mask:		dcb.w 1
r_tiles_table:			dcb.w VD_NUM_COLORS*VD_NUM_BITS_PER_COLOR
