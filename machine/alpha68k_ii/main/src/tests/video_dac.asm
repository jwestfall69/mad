	include "cpu/68000/include/common.inc"

	global video_dac_test

	section code

video_dac_test:
		RSUB	screen_init

		moveq	#$2, d0
		bsr	fg_set_bank

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		; Palette Layout
		;  xxxx RRRR GGGG BBBB
		; red palette setup
		lea	PALETTE_RAM+PALETTE_SIZE, a0
		move.w	#$f00, d0
		bsr	palette_setup_color

		; green palette setup
		lea	PALETTE_RAM+(PALETTE_SIZE*2), a0
		move.w	#$f0, d0
		bsr	palette_setup_color

		; blue palette setup
		lea	PALETTE_RAM+(PALETTE_SIZE*3), a0
		move.w	#$f, d0
		bsr	palette_setup_color

		; combined/all palette setup
		lea	PALETTE_RAM+(PALETTE_SIZE*4), a0
		move.w	#$fff, d0
		bsr	palette_setup_color

		bsr	generate_tiles_table
		bsr	draw_colors

	.loop_input:
		WATCHDOG

		bsr	input_update
		move.b	r_input_edge, d0

		btst	#INPUT_B1_BIT, d0
		beq	.b1_not_pressed
		bsr	full_screen
		bra	video_dac_test

	.b1_not_pressed:
		btst	#INPUT_B2_BIT, d0
		beq	.loop_input

		moveq	#0, d0
		bsr	fg_set_bank
		rts

; In full screen mode we fill the entire fg ram with a single
; tile/color bit to allow isolating it for testing
MAX_COLOR_INDEX		equ (VD_NUM_COLORS - 1)
MAX_COLOR_BIT_INDEX	equ (VD_NUM_BITS_PER_COLOR - 1)
full_screen:

		; Treat r_tiles_table as a multidimensional array of
		;  long[VD_NUM_COLORS][VD_NUM_BITS_PER_COLOR]
		; where:
		;  d3 is the first index (color)
		;  d2 is the second index (color bit for that color)
		lea	r_tiles_table, a1

		; start at [0][0], red bit 0
		moveq	#0, d2
		moveq	#0, d3

	.draw_full_screen:
		; convert the d2/d3 array index numbers into the correct offset
		; in r_tiles_table
		move.w	d2, d4
		mulu	#SCREEN_BYTES_PER_TILE, d4
		move.l	d3, d5
		mulu	#(SCREEN_BYTES_PER_TILE * VD_NUM_BITS_PER_COLOR), d5
		add.w	d5, d4

		move.l	(a1, d4.w), d5
		move.l	d5, d4
		swap	d4
		lea	TILE_RAM, a0
		move.l	#(TILE_RAM_SIZE / 4) - 1, d0

	.loop_next_address:
		move.w	d5, (a0)+
		move.w	d4, (a0)+
		dbra	d0, .loop_next_address

	.loop_input:
		WATCHDOG

		bsr	input_update
		move.b	r_input_edge, d0

		btst	#INPUT_UP_BIT, d0
		beq	.up_not_pressed
		sub.w	#1, d3				; goto previous color in table
		bpl	.draw_full_screen		; negative color index?
		move.w	#MAX_COLOR_INDEX, d3		; yes? wrap around to last color
		bra	.draw_full_screen
	.up_not_pressed:

		btst	#INPUT_DOWN_BIT, d0
		beq	.down_not_pressed
		add.w	#1, d3				; goto next color in table
		cmp.w	#MAX_COLOR_INDEX, d3		; past end of table?
		ble	.draw_full_screen
		moveq	#0, d3				; yes? wrap around to first color
		bra	.draw_full_screen
	.down_not_pressed:

		btst	#INPUT_LEFT_BIT, d0
		beq	.left_not_pressed
		subq.w	#1, d2				; goto previous color bit in table
		bpl	.draw_full_screen		; negative color bit index?
		moveq	#MAX_COLOR_BIT_INDEX, d2	; yes? wrap around to last color bit for this color
		bra	.draw_full_screen
	.left_not_pressed:

		btst	#INPUT_RIGHT_BIT, d0
		beq	.right_not_pressed
		addq.w	#1, d2				; goto next color bit in table
		cmp.b	#MAX_COLOR_BIT_INDEX, d2	; past end of color bits for this color?
		ble	.draw_full_screen
		moveq	#0, d2				; yes? wrap around to first color bit for this color
		bra	.draw_full_screen
	.right_not_pressed:

		btst	#INPUT_B2_BIT, d0
		bne	.full_screen_exit
		bra	.loop_input
	.full_screen_exit:

		rts

; Given the raw tile numbers, generate a table that has
; the required tile+palette number for each color/color bit
;
; Tile Layout
;  xxxx xxxx xPPP TTTT xxxx xxxx TTTT TTTT
; where
;  P = palette number
;  T = tile number
generate_tiles_table:
		lea	r_tiles_table, a1
		move.l	#(1<<16), d5			; start with palette #1
		moveq	#(VD_NUM_COLORS - 1), d4

	.loop_next_color:
		lea	d_tiles_raw, a0
		moveq	#4, d1				; # raw tiles

	.loop_next_raw_tile:
		moveq	#$0, d0
		move.w	(a0)+, d0			; take the raw tile
		or.l	d5, d0				; add in the palette #
		move.l	d0, (a1)+			; save to r_tiles_table
		dbra	d1, .loop_next_raw_tile

		add.l	#(1<<16), d5			; next palette
		dbra	d4, .loop_next_color
		rts

COLOR_BLOCK_START_X	equ SCREEN_START_X + 1
COLOR_BLOCK_START_Y	equ SCREEN_START_Y + 3
draw_colors:
		lea	r_tiles_table, a0
		moveq	#COLOR_BLOCK_START_Y, d6
		moveq	#(VD_NUM_COLORS - 1), d3

	.loop_next_color:
		moveq	#COLOR_BLOCK_START_X, d5
		moveq	#(VD_NUM_BITS_PER_COLOR - 1), d4

	.loop_next_color_bit:
		move.b	d5, d0
		move.b	d6, d1
		RSUB	screen_seek_xy			; seek upper-left x, y for this color bit

		move.l	(a0)+, d0
		bsr	draw_color_bit

		add.b	#VD_COLOR_BLOCK_WIDTH, d5	; next bit over (+x offset)
		dbra	d4, .loop_next_color_bit

		add.b	#VD_COLOR_BLOCK_HEIGHT, d6	; next color down (+y offset)
		dbra	d3, .loop_next_color
		rts

; draws an individual color bit
; params:
;  d0 = tile
draw_color_bit:
		moveq	#(VD_COLOR_BLOCK_HEIGHT - 1), d1
		moveq	#0, d2				; row offset

	.loop_next_row:
		move.w	d0, -4(a6, d2.w)
		move.w	d0, -8(a6, d2.w)
		move.w	d0, -12(a6, d2.w)
		move.w	d0, -16(a6, d2.w)
		swap	d0
		move.w	d0, -2(a6, d2.w)
		move.w	d0, -6(a6, d2.w)
		move.w	d0, -10(a6, d2.w)
		move.w	d0, -14(a6, d2.w)
		swap	d0
		add.w	#SCREEN_BYTES_PER_ROW, d2	; next row
		dbra	d1, .loop_next_row
		rts

; params:
;  a0 = palette start address
;  d0 = color's bits set to 1's (word)
palette_setup_color:

		lea	d_palette_offsets, a1
		moveq	#(VD_NUM_BITS_PER_COLOR - 2), d5; number of bits (not including all/combined)
		move.w	#$111, d4			; bit mask

	.loop_next_offset:
		move.w	(a1)+, d1
		move.w	d0, d2
		and.w	d4, d2
		move.w	d2, (a0, d1.w)			; individual b0 to b3
		lsl.w	#1, d4				; shift bit mask to get the next bit
		dbra	d5, .loop_next_offset

		move.w	(a1), d1			; all bits enabled for this individual color
		move.w	d0, (a0, d1.w)
		rts

	section data
	align 1

d_palette_offsets:
	dc.w	VD_TILE_B0_PAL_OFFSET, VD_TILE_B1_PAL_OFFSET, VD_TILE_B2_PAL_OFFSET, VD_TILE_B3_PAL_OFFSET, VD_TILE_BA_PAL_OFFSET

d_tiles_raw:
	dc.w	VD_TILE_B0_NUM, VD_TILE_B1_NUM, VD_TILE_B2_NUM, VD_TILE_B3_NUM, VD_TILE_BA_NUM

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "VIDEO DAC TEST"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 2), "B0  B1  B2  B3  ALL"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - FULL SCREEN"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

	section bss
	align 1

r_tiles_table:		dcb.l VD_NUM_COLORS*VD_NUM_BITS_PER_COLOR
