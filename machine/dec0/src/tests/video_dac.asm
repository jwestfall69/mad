	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"

	include "input.inc"
	include "mad_rom.inc"
	include "machine.inc"

	global video_dac_test

	section code

; Note: There are only 3 available solid tiles per romset (2 for hbarrel),
; but we need to setup 9 color bits per color.  So we are unable to use a
; single palette/group of tiles like on other machines.  Instead we need
; to use the 3 tiles across 3 palettes for each color.  This requires some
; extra logic in palette_setup_color and generate_tiles_table that other
; machines to have.
video_dac_test:
		RSUB	screen_clear

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		; Palette layout
		;  GGGG RRRR (palette ram)
		;  xxxx BBBB (palette ext ram)
		; red palette setup
		lea	PALETTE_RAM_START+PALETTE_SIZE, a0
		move.w	#$ff, d0
		bsr	palette_setup_color

		; green palette setup
		lea	PALETTE_RAM_START+(PALETTE_SIZE*4), a0
		move.w	#$ff00, d0
		bsr	palette_setup_color

		; blue palette setup
		lea	PALETTE_EXT_RAM_START+(PALETTE_SIZE*7), a0
		move.w	#$ff, d0
		bsr	palette_setup_color

		; combined/all palette setup
		lea	PALETTE_RAM_START+(PALETTE_SIZE*10), a0
		move.w	#$ffff, d0
		bsr	palette_setup_color

		; combined/all palette setup
		lea	PALETTE_EXT_RAM_START+(PALETTE_SIZE*10), a0
		move.w	#$ff, d0
		bsr	palette_setup_color

		bsr	generate_tiles_table
		bsr	draw_colors

	.loop_input:
		bsr	input_update
		move.b	INPUT_EDGE, d0

		btst	#INPUT_B2_BIT, d0
		bne	.test_exit

		btst	#INPUT_B1_BIT, d0
		beq	.loop_input

		bsr	full_screen
		bra	video_dac_test

	.test_exit:
		rts

; In full screen mode we fill the entire tile1 ram with a single
; tile/color bit to allow isolating it for testing
MAX_COLOR_INDEX		equ (VD_NUM_COLORS - 1)
MAX_COLOR_BIT_INDEX	equ (VD_NUM_BITS_PER_COLOR - 1)
full_screen:

		; Treat TILES_TABLE as a multidimensional array of
		;  long[VD_NUM_COLORS][VD_NUM_BITS_PER_COLOR]
		; where:
		;  d3 is the first index (color)
		;  d2 is the second index (color bit for that color)
		lea	TILES_TABLE, a1

		; start at [0][0], red bit 0
		moveq	#0, d2
		moveq	#0, d3

	.draw_full_screen:
		; convert the d2/d3 array index numbers into the correct offset
		; in TILES_TABLE
		move.w	d2, d4
		mulu	#SCREEN_BYTES_PER_TILE, d4
		move.l	d3, d5
		mulu	#(SCREEN_BYTES_PER_TILE * VD_NUM_BITS_PER_COLOR), d5
		add.w	d5, d4

		move.w	(a1, d4.w), d1
		lea	TILE1_RAM_START, a0
		move.l	#(TILE1_RAM_SIZE / 2) - 1, d0

	.loop_next_address:
		move.w	d1, (a0)+
		dbra	d0, .loop_next_address

	.loop_input:
		bsr	input_update
		move.b	INPUT_EDGE, d0

		btst	#INPUT_DOWN_BIT, d0
		beq	.down_not_pressed
		add.w	#1, d3				; goto next color in table
		cmp.w	#MAX_COLOR_INDEX, d3		; past end of table?
		ble	.draw_full_screen
		moveq	#0, d3				; yes? wrap around to first color
		bra	.draw_full_screen
	.down_not_pressed:

		btst	#INPUT_UP_BIT, d0
		beq	.up_not_pressed
		sub.w	#1, d3				; goto previous color in table
		bpl	.draw_full_screen		; negative color index?
		move.w	#MAX_COLOR_INDEX, d3		; yes? wrap around to last color
		bra	.draw_full_screen
	.up_not_pressed:

		btst	#INPUT_RIGHT_BIT, d0
		beq	.right_not_pressed
		addq.w	#1, d2				; goto next color bit in table
		cmp.b	#MAX_COLOR_BIT_INDEX, d2	; past end of color bits for this color?
		ble	.draw_full_screen
		moveq	#0, d2				; yes? wrap around to first color bit for this color
		bra	.draw_full_screen
	.right_not_pressed:

		btst	#INPUT_LEFT_BIT, d0
		beq	.left_not_pressed
		subq.w	#1, d2				; goto previous color bit in table
		bpl	.draw_full_screen		; negative color bit index?
		moveq	#MAX_COLOR_BIT_INDEX, d2	; yes? wrap around to last color bit for this color
		bra	.draw_full_screen
	.left_not_pressed:

		btst	#INPUT_B2_BIT, d0
		bne	.full_screen_exit
		bra	.loop_input
	.full_screen_exit:

		rts

; Given the raw tile numbers, generate a table that has
; the required tile+palette number for each color/color bit
;
; Tile Layout
;  PPPP TTTT TTTT TTTT
; where
;  P = palette number
;  T = tile number
generate_tiles_table:
		lea	TILES_TABLE, a1
		move.w	#(1<<12), d5			; start with palette #1
		moveq	#(VD_NUM_COLORS - 1), d4

	.loop_next_color:
		moveq	#2, d6				; # raw tiles

	.loop_next_group_of_three:
		lea	TILES_RAW, a0
		moveq	#2, d1

	.loop_next_raw_tile:
		move.w	(a0)+, d0			; take the raw tile
		or.w	d5, d0				; add in the palette #
		move.w	d0, (a1)+			; save to TILES_TABLE
		dbra	d1, .loop_next_raw_tile

		add.w	#(1<<12), d5			; next palette
		dbra	d6, .loop_next_group_of_three

		dbra	d4, .loop_next_color
		rts

	ifd _PRINT_COLUMN_
COLOR_BLOCK_START_X	equ 1
COLOR_BLOCK_START_Y	equ 8
	else
COLOR_BLOCK_START_X	equ 2
COLOR_BLOCK_START_Y	equ 6
	endif

draw_colors:
		lea	TILES_TABLE, a0
		moveq	#COLOR_BLOCK_START_Y, d6
		moveq	#(VD_NUM_COLORS - 1), d3

	.loop_next_color:
		moveq	#COLOR_BLOCK_START_X, d5
		moveq	#(VD_NUM_BITS_PER_COLOR - 1), d4

	.loop_next_color_bit:
		move.b	d5, d0
		move.b	d6, d1
		RSUB	screen_seek_xy			; seek upper-left x, y (normal) or lower-left x,y (column)

		move.w	(a0)+, d0
		bsr	draw_color_bit

		add.b	#VD_COLOR_BLOCK_WIDTH, d5	; next bit over (+x offset)
		dbra	d4, .loop_next_color_bit

		add.b	#VD_COLOR_BLOCK_HEIGHT, d6	; next color down (+y offset)
		dbra	d3, .loop_next_color
		rts

; draws an individual color bit
; params:
;  d0 = tile
; Note: in _PRINT_COLUMN_ mode the color block is being written
; by column instead of row.
draw_color_bit:
		moveq	#(VD_COLOR_BLOCK_HEIGHT - 1), d1
		moveq	#0, d2				; row offset
	.loop_next_row:
		move.w	d0, (a6, d2.w)
		move.w	d0, 2(a6, d2.w)
		move.w	d0, 4(a6, d2.w)
		add.w	#SCREEN_BYTES_PER_LINE, d2	; next row
		dbra	d1, .loop_next_row
		rts

; params:
;  a0 = palette start address
;  d0 = color's bits set to 1's (word)
palette_setup_color:

		moveq	#2, d6				; 3 groups of three tiles
		move.w	#$101, d4			; bit mask

	.loop_next_group_of_three:
		lea	PALETTE_OFFSETS, a1
		moveq	#2, d5

	.loop_next_offset:
		move.w	(a1)+, d1
		move.w	d0, d2
		and.w	d4, d2
		move.w	d2, (a0, d1.w)			; individual b0 to b3
		lsl.w	#1, d4				; shift bit mask to get the next bit
		dbra	d5, .loop_next_offset

	ifd _ROMSET_HBARREL_
		; hbarrel only has 2x solid color tiles, so we have to use
		; a single dual color tile.  This is a hack to also apply
		; the color to the 2nd offset in the palette
		move.w	d2, (VD_TILE_B25A_PAL_OFFSET2, a0)
	endif

		add.l	#PALETTE_SIZE, a0
		dbra	d6, .loop_next_group_of_three

		sub.l	#PALETTE_SIZE, a0		; rewrite the last one to be without the mask
		move.w	d0, (a0, d1.w)

	ifd _ROMSET_HBARREL_
		move.w	d0, (VD_TILE_B25A_PAL_OFFSET2, a0)
	endif
		rts

	section data

	align 2

PALETTE_OFFSETS:
	dc.w	VD_TILE_B036_PAL_OFFSET, VD_TILE_B147_PAL_OFFSET, VD_TILE_B25A_PAL_OFFSET
TILES_RAW:
	dc.w	VD_TILE_B036_NUM, VD_TILE_B147_NUM, VD_TILE_B25A_NUM

SCREEN_XYS_LIST:
	ifd _PRINT_COLUMN_
		XY_STRING 8, 2, "VIDEO DAC TEST"
		XY_STRING 2, 5, "0  1  2  3  4  5  6  7 ALL"
	else
		XY_STRING 9, 2, "VIDEO DAC TEST"
		XY_STRING 3, 5, "0  1  2  3  4  5  6  7 ALL"
	endif
	XY_STRING 3, 24, "B1 - FULL SCREEN"
	XY_STRING 3, 25, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

	section bss

	align 2

TILES_TABLE:
	dcb.w	VD_NUM_COLORS*VD_NUM_BITS_PER_COLOR
