	include "cpu/konami2/include/common.inc"

	global video_dac_test

	section code

video_dac_test:
		RSUB	screen_init

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		; Each layer has 4 palettes, but the text on the
		; fix layer takes up most color indexes, so we are
		; useing layer 'a' for the color blocks.

		; shift over layer a so its the same offset as fix
		lda	#$6
		sta	REG_LAYER_A_SCROLL_X

		; Palette Layout
		;  xBBB BBGG GGGR RRRR
		; red palette setup
		ldx	#LAYER_A_TILE_PALETTE
		ldd	#$001f
		jsr	palette_color_setup

		; green palette setup
		ldx	#LAYER_A_TILE_PALETTE + PALETTE_SIZE
		ldd	#$03e0
		jsr	palette_color_setup

		; blue palette setup
		ldx	#LAYER_A_TILE_PALETTE + (PALETTE_SIZE*2)
		ldd	#$7c00
		jsr	palette_color_setup

		; combined/all palette setup
		ldx	#LAYER_A_TILE_PALETTE + (PALETTE_SIZE*3)
		ldd	#$7fff
		jsr	palette_color_setup

		jsr	generate_tiles_table
		jsr	draw_colors

	.loop_input:
		WATCHDOG
		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_B1
		beq	.b1_not_pressed
		bsr	full_screen
		bra	video_dac_test

	.b1_not_pressed:
		bita	#INPUT_B2
		beq	.loop_input
		rts


; In full screen mode we fill the entire tile ram with a single
; tile/color bit to allow isolating it for testing
MAX_COLOR_INDEX		equ (VD_NUM_COLORS - 1)
MAX_COLOR_BIT_INDEX	equ (VD_NUM_BITS_PER_COLOR - 1)
full_screen:
		; clear fix layer so layer a will show through
		ldy	#FIX_TILE
		ldx	#(FIX_TILE_SIZE / 2)
		ldd	#$1010
	.loop_next_fix_address:
		std	, y++
		dxjnz	.loop_next_fix_address

		; Treat r_tiles_table as a multidimensional array of
		;  word[VD_NUM_COLORS][VD_NUM_BITS_PER_COLOR]
		; where:
		;  r_color_num is the first index (color)
		;  r_color_bit is the second index (color bit for that color)
		ldy	#r_tiles_table

		; start at [0][0], red bit 0
		clr	r_color_num
		clr	r_color_bit

	.draw_full_screen:
		; convert r_color_(num|bit) array index numbers into the
		; correct offset in r_tiles_table

		; (2 bytes per tile * VD_NUM_BITS_PER_COLOR) = 12
		lda	r_color_num
		lsla			; *2
		sta	r_scratch	; backup *2
		lsla			; *4
		lsla			; *8
		adda	r_scratch	; +2
		adda	r_scratch	; +2

		; 2 bytes per tile in r_tiles_table
		ldb	r_color_bit
		lslb
		stb	r_scratch
		adda	r_scratch

		ldd	a, y
		pshs	y

		; fill entire screen with the tile
		ldy	#LAYER_A_TILE
		ldx	#LAYER_A_TILE_SIZE
	.loop_next_address:
		sta	-$2000, y
		stb	, y+
		dxjnz	.loop_next_address
		puls	y

	.loop_input:
		WATCHDOG
		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_UP
		beq	.up_not_pressed
		dec	r_color_num
		bpl	.draw_full_screen
		lda	#MAX_COLOR_INDEX
		sta	r_color_num
		bra	.draw_full_screen

	.up_not_pressed:
		bita	#INPUT_DOWN
		beq	.down_not_pressed
		inc	r_color_num
		lda	r_color_num
		cmpa	#MAX_COLOR_INDEX
		ble	.draw_full_screen
		clr	r_color_num
		bra	.draw_full_screen

	.down_not_pressed:
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		dec	r_color_bit
		bpl	.draw_full_screen
		lda	#MAX_COLOR_BIT_INDEX
		sta	r_color_bit
		bra	.draw_full_screen

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		inc	r_color_bit
		lda	r_color_bit
		cmpa	#MAX_COLOR_BIT_INDEX
		lble	.draw_full_screen
		clr	r_color_bit
		lbra	.draw_full_screen

	.right_not_pressed:
		bita	#INPUT_B2
		beq	.loop_input
		rts

; Given the raw tile numbers, generate a table that has
; the required tile+palette number for each color/color bit
; PPTT ??TT TTTT TTTT
; where
;  P = palette number
;  T = tile number
;  r = reverse tile
generate_tiles_table:
		ldx	#r_tiles_table
		clr	r_generate_tiles_palette_num
		lda	#VD_NUM_COLORS
		sta	r_color_num

	.loop_next_color:
		ldy	#d_tiles_raw
		lda	#VD_NUM_BITS_PER_COLOR
		sta	r_color_bit

	.loop_next_raw_tile:
		ldd	, y++
		adda	r_generate_tiles_palette_num
		std	, x++

		dec	r_color_bit
		bne	.loop_next_raw_tile

		lda	r_generate_tiles_palette_num
		adda	#$40		; next palette
		sta	r_generate_tiles_palette_num

		dec	r_color_num
		bne	.loop_next_color
		rts


COLOR_BLOCK_START_X	equ SCREEN_START_X + 3
COLOR_BLOCK_START_Y	equ SCREEN_START_Y + 3
draw_colors:
		ldy	#r_tiles_table
		lda	#COLOR_BLOCK_START_Y
		sta	r_draw_colors_y_offset

		lda	#VD_NUM_COLORS
		sta	r_color_num

	.loop_next_color:
		lda	#COLOR_BLOCK_START_X
		sta	r_draw_colors_x_offset
		lda	#VD_NUM_BITS_PER_COLOR
		sta	r_color_bit

	.loop_next_color_bit:
		lda	r_draw_colors_x_offset
		ldb	r_draw_colors_y_offset
		RSUB	screen_seek_xy

		ldd	, y++
		pshs	y
		bsr	draw_color_bit
		puls	y

		lda	r_draw_colors_x_offset
		adda	#VD_COLOR_BLOCK_WIDTH		; next bit over (+x offset)
		sta	r_draw_colors_x_offset

		dec	r_color_bit
		bne	.loop_next_color_bit

		lda	r_draw_colors_y_offset
		adda	#VD_COLOR_BLOCK_HEIGHT		; next color down (+y offset)
		sta	r_draw_colors_y_offset

		dec	r_color_num
		bne	.loop_next_color
		rts

; draws an individual color bit
; params:
;  d = tile
;  x = upper left loction in tile ram to start at
draw_color_bit:
		tfr	x, y
		ldx	#VD_COLOR_BLOCK_HEIGHT

		; adjust do be in layer a
		leay	$800, y
	.loop_next_row:
		sta	-$2000, y
		sta	-($2000 - 1), y
		sta	-($2000 - 2), y
		sta	-($2000 - 3), y
		stb	0, y
		stb	1, y
		stb	2, y
		stb	3, y
		leay	SCREEN_BYTES_PER_ROW, y
		dxjnz	.loop_next_row
		rts

; params:
;  d = color's bits set to 1's
;  x = palette start address
palette_color_setup:
		std	r_palette_color_bits

		ldy	#d_palette_offsets
		lda	#(VD_NUM_BITS_PER_COLOR - 1)	; number bits (not including all/combined)
		sta	r_color_bit
		ldd	#$421				; used for mask, bit 0 of each color set
		std	r_palette_color_mask

		setln	#(SETLN_WATCHDOG_POLL|SETLN_SELECT_RAM_PALETTE)

	.loop_next_offset:
		lda	, y+
		pshs	x
		leax	a, x

		ldd	r_palette_color_bits
		anda	r_palette_color_mask
		andb	r_palette_color_mask + 1

		std	, x
		puls	x

		ldd	r_palette_color_mask
		aslb
		rola
		std	r_palette_color_mask

		dec	r_color_bit
		bne	.loop_next_offset

		; all bits enabled for this individual color
		lda	, y
		leax	a, x
		ldd	r_palette_color_bits
		std	, x

		setln	#(SETLN_WATCHDOG_POLL|SETLN_SELECT_RAM_WORK)
		rts

	section data

d_palette_offsets:
	dc.b	VD_TILE_B0_PAL_OFFSET, VD_TILE_B1_PAL_OFFSET, VD_TILE_B2_PAL_OFFSET, VD_TILE_B3_PAL_OFFSET, VD_TILE_B4_PAL_OFFSET, VD_TILE_BA_PAL_OFFSET

d_tiles_raw:
	dc.w	VD_TILE_B0_NUM, VD_TILE_B1_NUM, VD_TILE_B2_NUM, VD_TILE_B3_NUM, VD_TILE_B4_NUM, VD_TILE_BA_NUM

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "VIDEO DAC TEST"
	XY_STRING (SCREEN_START_X + 4), (SCREEN_START_Y + 2), "B0  B1  B2  B3  B4  ALL"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - FULL SCREEN"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

	section bss

r_color_bit:			dcb.b 1
r_color_num:			dcb.b 1
r_draw_colors_x_offset:		dcb.b 1
r_draw_colors_y_offset:		dcb.b 1
r_generate_tiles_palette_num:	dcb.b 1
r_palette_color_bits:		dcb.w 1
r_palette_color_mask:		dcb.w 1
r_tiles_table:			dcb.w VD_NUM_COLORS*VD_NUM_BITS_PER_COLOR

