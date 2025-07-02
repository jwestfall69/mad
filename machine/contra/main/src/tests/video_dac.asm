	include "cpu/6309/include/common.inc"

	global video_dac_test

	section code

video_dac_test:
		RSUB	screen_init

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		jsr	palette_setup
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

		; Treat r_tiles_table as a multidimensional array of
		;  word[VD_NUM_COLORS][VD_NUM_BITS_PER_COLOR]
		; where:
		;  f is the first index (color)
		;  e is the second index (color bit for that color)
		ldy	#r_tiles_table

		; start at [0][0], red bit 0
		clrw

	.draw_full_screen:

		; re-init the palette since we might have corrupted it below
		pshs	y
		pshsw
		jsr	palette_setup
		pulsw
		puls	y

		; convert e/f array index numbers into the correct offset
		; in r_tiles_table
		pshsw
		tfr	w, d
		lsla		; 2 bytes per tile in r_tiles_table
				; (2 bytes per tile * VD_NUM_BITS_PER_COLOR) = 12
		lslb		; *2
		tfr	b, e	; backup 2
		lslb		; *4
		lslb		; *8
		addr	e, b	; +2
		addr	e, b	; +2

		addr	b, a
		ldd	a, y

		bitd	#$30
		bne	.tile_a_10e

		; this ends up be a bit annoying as there is no way
		; for 18e tiles to fully override all of the screen
		; because of 10e's first 5 lines of tile_b are always
		; on top.  So we are copying over the palette used for
		; 18e to 10e then draw the correct tile in both 10e
		; tile layers to fill the screen with the blue or white
		; color
		pshs	y
		ldf	#PALETTE_SIZE
		ldx	#K007121_10E_TILE_A_PALETTE
		ldy	#K007121_18E_TILE_A_PALETTE

	.loop_next_palette_byte:
		lde	, y+
		ste	, x+
		decf
		bne	.loop_next_palette_byte
		puls	y

		ord	#$30

	.tile_a_10e:
		ldx	#K007121_10E_TILE_A
		jsr	fill_tile_layer

		ldx	#K007121_10E_TILE_B
		jsr	fill_tile_layer
		pulsw

	.loop_input:
		WATCHDOG
		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_UP
		beq	.up_not_pressed
		subf	#1
		bpl	.draw_full_screen
		ldf	#MAX_COLOR_INDEX
		bra	.draw_full_screen

	.up_not_pressed:
		bita	#INPUT_DOWN
		beq	.down_not_pressed
		addf	#1
		cmpf	#MAX_COLOR_INDEX
		ble	.draw_full_screen
		clrf
		bra	.draw_full_screen

	.down_not_pressed:
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		sube	#1
		lbpl	.draw_full_screen
		lde	#MAX_COLOR_BIT_INDEX
		lbra	.draw_full_screen

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		adde	#1
		cmpe	#MAX_COLOR_BIT_INDEX
		lble	.draw_full_screen
		clre
		lbra	.draw_full_screen

	.right_not_pressed:
		bita	#INPUT_B2
		beq	.loop_input
		rts

; params:
;  x = layer x start address
;  a = data for LAYER_X_TILE_ATTR
;  b = data for LAYER_X_TILE
fill_tile_layer:
		ldw	#K007121_10E_TILE_A_SIZE
	.loop_next_address:
		sta	-$400, x
		stb	, x+
		decw
		bne	.loop_next_address
		rts

; Given the raw tile numbers, generate a table that has
; the required tiles. Both 007121 have tiles that are
; a row of solid colors and corresponding palette locations
; 10e are $30 to $3f
; 18e are $01 to $0f
;  d_tiles_raw list contains the 18e list, so we need to or
; in $30 for 10e tiles
generate_tiles_table:
		ldx	#r_tiles_table
		ldy	#d_tiles_raw
		lde	#12		; # of raw tiles

	.loop_next_raw_tile_10e:
		ldd	, y++
		orb	#$30
		std	, x++
		dece
		bne	.loop_next_raw_tile_10e


		ldy	#d_tiles_raw
		lde	#12		; # of raw tiles

	.loop_next_raw_tile_18e:
		ldd	, y++
		std	, x++
		dece
		bne	.loop_next_raw_tile_18e
		rts


COLOR_BLOCK_START_X	equ SCREEN_START_X + 2
COLOR_BLOCK_START_Y	equ SCREEN_START_Y + 3
draw_colors:
		ldy	#r_tiles_table
		lda	#COLOR_BLOCK_START_Y
		sta	r_draw_colors_y_offset

		lde	#VD_NUM_COLORS

	.loop_next_color:
		lda	#COLOR_BLOCK_START_X
		sta	r_draw_colors_x_offset
		ldf	#VD_NUM_BITS_PER_COLOR


	.loop_next_color_bit:
		lda	r_draw_colors_x_offset
		ldb	r_draw_colors_y_offset
		RSUB	screen_seek_xy

		ldd	,y++

		bitd	#$30
		bne	.tile_a_10e

		 ; convert to layer a to layer b
		leax	$2000, x

	.tile_a_10e:
		pshsw
		bsr	draw_color_bit
		pulsw

		lda	r_draw_colors_x_offset
		adda	#VD_COLOR_BLOCK_WIDTH		; next bit over (+x offset)
		sta	r_draw_colors_x_offset

		decf
		bne	.loop_next_color_bit

		lda	r_draw_colors_y_offset
		adda	#VD_COLOR_BLOCK_HEIGHT		; next color down (+y offset)
		sta	r_draw_colors_y_offset

		dece
		bne	.loop_next_color
		rts

; draws an individual color bit
; params:
;  d = tile
;  x = upper left loction in tile ram to start at
draw_color_bit:
		lde	#VD_COLOR_BLOCK_HEIGHT

	.loop_next_row:
		sta	-$400, x
		sta	-($400 - 1), x
		sta	-($400 - 2), x
		sta	-($400 - 3), x
		stb	0, x
		stb	1, x
		stb	2, x
		stb	3, x
		leax	SCREEN_BYTES_PER_ROW, x
		dece
		bne	.loop_next_row
		rts

palette_setup:
		; The game only has 1 palette per tile layer and
		; only 2 layers.  So we have to double up the number
		; of color tiles per palette.
		; Palette Layout
		;  xBBB BBGG GGGR RRRR
		; red palette setup
		ldx	#K007121_10E_TILE_A_PALETTE
		ldy	#d_palette_offsets_color0
		ldd	#$001f
		jsr	palette_color_setup

		; green palette setup
		ldx	#K007121_10E_TILE_A_PALETTE
		ldy	#d_palette_offsets_color1
		ldd	#$03e0
		jsr	palette_color_setup

		; blue palette setup
		ldx	#K007121_18E_TILE_A_PALETTE
		ldy	#d_palette_offsets_color0
		ldd	#$7c00
		jsr	palette_color_setup

		; combined/all palette setup
		ldx	#K007121_18E_TILE_A_PALETTE
		ldy	#d_palette_offsets_color1
		ldd	#$7fff
		jsr	palette_color_setup
		rts

; params:
;  d = color's bits set to 1's
;  x = palette start address
palette_color_setup:
		std	r_palette_color_bits
		ldf	#(VD_NUM_BITS_PER_COLOR - 1)	; number bits (not including all/combined)
		ldd	#$421				; used for mask, bit 0 of each color set
		std	r_palette_color_mask

	.loop_next_offset:
		lde	, y+
		ldd	r_palette_color_bits
		andd	r_palette_color_mask

		stb	e, x
		ince
		sta	e, x

		ldd	r_palette_color_mask
		rold
		std	r_palette_color_mask

		decf
		bne	.loop_next_offset

		; all bits enabled for this individual color
		lde	, y
		ldd	r_palette_color_bits
		stb	e, x
		ince
		sta	e, x

		rts

	section data

d_palette_offsets_color0:
	dc.b	VD_TILE_C0B0_PAL_OFFSET, VD_TILE_C0B1_PAL_OFFSET, VD_TILE_C0B2_PAL_OFFSET, VD_TILE_C0B3_PAL_OFFSET, VD_TILE_C0B4_PAL_OFFSET, VD_TILE_C0BA_PAL_OFFSET
d_palette_offsets_color1:
	dc.b	VD_TILE_C1B0_PAL_OFFSET, VD_TILE_C1B1_PAL_OFFSET, VD_TILE_C1B2_PAL_OFFSET, VD_TILE_C1B3_PAL_OFFSET, VD_TILE_C1B4_PAL_OFFSET, VD_TILE_C1BA_PAL_OFFSET

d_tiles_raw:
	dc.w	VD_TILE_C0B0_NUM, VD_TILE_C0B1_NUM, VD_TILE_C0B2_NUM, VD_TILE_C0B3_NUM, VD_TILE_C0B4_NUM, VD_TILE_C0BA_NUM
	dc.w	VD_TILE_C1B0_NUM, VD_TILE_C1B1_NUM, VD_TILE_C1B2_NUM, VD_TILE_C1B3_NUM, VD_TILE_C1B4_NUM, VD_TILE_C1BA_NUM

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "VIDEO DAC TEST"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "B0  B1  B2  B3  B4  ALL"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - FULL SCREEN"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

	section bss

r_draw_colors_x_offset:		dcb.b 1
r_draw_colors_y_offset:		dcb.b 1
r_palette_color_bits:		dcb.w 1
r_palette_color_mask:		dcb.w 1
r_tiles_table:			dcb.w VD_NUM_COLORS*VD_NUM_BITS_PER_COLOR

