	include "cpu/68000/include/common.inc"

	global video_dac_test

	section code

video_dac_test:

		move.b	#$f, r_brightness

	.loop_main:
		RSUB	screen_init


		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list
		jsr	print_b2_return_to_menu

		bsr	palette_setup
		bsr	generate_tiles_table
		bsr	draw_colors

	.loop_input:
		SEEK_XY	(SCREEN_START_X + 18), (SCREEN_START_Y + 17)
		move.b	r_brightness, d0
		RSUB	print_hex_nibble

		bsr	input_update
		move.b	r_input_edge, d0

		btst	#INPUT_LEFT_BIT, d0
		beq	.left_not_pressed
		move.b	r_brightness, d1
		subq.b	#1, d1
		bra	.brightness_adjusted
	.left_not_pressed:

		btst	#INPUT_RIGHT_BIT, d0
		beq	.right_not_pressed
		move.b	r_brightness, d1
		addq.b	#1, d1
		bra	.brightness_adjusted
	.right_not_pressed:

		btst	#INPUT_B1_BIT, d0
		beq	.b1_not_pressed
		bsr	full_screen
		bra	.loop_main
	.b1_not_pressed:

		btst	#INPUT_B2_BIT, d0
		beq	.loop_input
		rts

	.brightness_adjusted:
		and.b	#$f, d1
		move.b	d1, r_brightness
		bsr	palette_setup
		bra	.loop_input

; In full screen mode we fill the entire scroll1 ram with a single
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

		move.w	(a1, d4.w), d1
		lea	FIX_TILE, a0
		move.l	#(FIX_TILE_SIZE / 2) - 1, d0

		move.w	d1, d5
		lsr.w	#$8, d5
	.loop_next_address:
		move.b	d1, ($1, a0)
		move.b	d5, ($801, a0)
		addq.l	#$2, a0
		dbra	d0, .loop_next_address

	.loop_input:
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
;  TTTT TTTT
;  TTPP PPPP (at +$800)
; where
;  P = palette number
;  T = tile number
generate_tiles_table:
		lea	r_tiles_table, a1
		moveq	#1, d5				; start with palette #1
		moveq	#((VD_NUM_COLORS*VD_NUM_BITS_PER_COLOR / 4) - 1), d4

	.loop_next_rg:
		move.w	d5, d0
		lsl.w	#$8, d0
		or.w	#VD_TILE1_NUM, d0
		move.w	d0, (a1)
		and.w	#$ff00, d0
		or.w	#VD_TILE2_NUM, d0
		move.w	d0, ((VD_NUM_COLORS + 1) * 2, a1)
		addq.l	#2, a1
		addq.l	#1, d5				; next palette
		dbra	d4, .loop_next_rg

		adda.l	#(VD_NUM_COLORS + 1) * 2, a1
		moveq	#((VD_NUM_COLORS*VD_NUM_BITS_PER_COLOR / 4) - 1), d4
	.loop_next_bw:
		move.w	d5, d0
		lsl.w	#$8, d0
		or.w	#VD_TILE1_NUM, d0
		move.w	d0, (a1)
		and.w	#$ff00, d0
		or.w	#VD_TILE2_NUM, d0
		move.w	d0, ((VD_NUM_COLORS + 1) * 2, a1)
		addq.l	#2, a1
		addq.l	#1, d5				; next palette
		dbra	d4, .loop_next_bw
		rts

COLOR_BLOCK_START_X	equ SCREEN_START_X
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
; Note: scroll ram is layed out as columns on the screen, so
; the next tile in memory is actually below the current tile
; instead of to the right.
draw_color_bit:
		move.w	d0, d2
		lsr.w	#$8, d2
		moveq	#(VD_COLOR_BLOCK_HEIGHT - 1), d1
	.loop_next_column:
		move.b	d0, ($1,a6)
		move.b	d2, ($801, a6)
		move.b	d0, ($3,a6)
		move.b	d2, ($803, a6)
		move.b	d0, ($5, a6)
		move.b	d2, ($805, a6)
		move.b	d0, ($7, a6)
		move.b	d2, ($807, a6)
		adda.w	#SCREEN_BYTES_PER_ROW, a6
		dbra	d1, .loop_next_column
		rts

; Palette Layout
;  RRRR GGGG BBBB bbbb
; where
;  b = brightness value (applies to all colors)
palette_setup:
		; red palette setup
		lea	r_palette_data, a0
		move.w	#$f000, d0
		move.w	#VD_TILE1_PAL_OFFSET, d1
		bsr	palette_setup_color

		; green palette setup
		lea	r_palette_data, a0
		move.w	#$f00, d0
		move.w	#VD_TILE2_PAL_OFFSET, d1
		bsr	palette_setup_color

		; blue palette setup
		lea	r_palette_data + (FIX_TILE_PALETTE_SIZE * VD_NUM_BITS_PER_COLOR), a0
		move.w	#$f0, d0
		move.w	#VD_TILE1_PAL_OFFSET, d1
		bsr	palette_setup_color

		; combined/all palette setup
		lea	r_palette_data + (FIX_TILE_PALETTE_SIZE * VD_NUM_BITS_PER_COLOR), a0
		move.w	#$fff0, d0
		move.w	#VD_TILE2_PAL_OFFSET, d1
		bsr	palette_setup_color

		CPU_INTS_ENABLE

		move.l	#r_palette_data, r_vblank_copy_src
		move.l	#(FIX_TILE_PALETTE + FIX_TILE_PALETTE_SIZE), r_vblank_copy_dst
		move.w	#(FIX_TILE_PALETTE_SIZE * VD_NUM_COLORS * VD_NUM_BITS_PER_COLOR / 2), r_vblank_copy_size
		jsr	wait_vblank_copy

		CPU_INTS_DISABLE
		rts

; params:
;  a0 = palette start address
;  d0 = color's bits set to 1's (word)
;  d1 = palette color offset
palette_setup_color:
		move.w	d1, d6
		moveq	#(VD_NUM_BITS_PER_COLOR - 2), d5; number of bits (not including all/combined)
		move.w	#$1110, d4			; bit mask

		move.b	r_brightness, d3			; brightness will be the upper nibble of the high byte
		and.w	#$f, d3

	.loop_next_offset:
		move.w	d0, d2
		and.w	d4, d2
		or.w	d3, d2				; add in brightness value
		move.w	d2, (a0, d6.w)	; individual b0 to b3
		lsl.w	#1, d4				; shift bit mask to get the next bit
		adda.l	#FIX_TILE_PALETTE_SIZE, a0
		dbra	d5, .loop_next_offset

		or.w	d3, d0				; add in brightness value
		move.w	d0, (a0, d6.w)
		rts

	section data
	align 1

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "VIDEO DAC TEST"
	XY_STRING (SCREEN_START_X + 1), (SCREEN_START_Y + 2), "B0  B1  B2  B3  ALL"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 17), "BRIGHTNESS LEVEL:"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "LR - ADJUST BRIGHTNESS"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - FULL SCREEN"
	XY_STRING_LIST_END

	section bss
	align 1

r_tiles_table:		dcb.w VD_NUM_COLORS*VD_NUM_BITS_PER_COLOR
r_palette_data:		dcb.b FIX_TILE_PALETTE_SIZE*VD_NUM_COLORS*VD_NUM_BITS_PER_COLOR
r_brightness:		dcb.b 1
