	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"
	include "global/include/screen.inc"

	include "input.inc"
	include "mad_rom.inc"
	include "machine.inc"

	global video_dac_test

	section code

video_dac_test:
		PSUB	screen_init

		ldy	#d_screen_xys_list
		PSUB	print_xy_string_list

		; Game only has 4 palettes for tile use, so
		; we are forced to use the palette we also
		; use for text.

		; Palette Layout
		;  xBBB BBGG GGGR RRRR
		; red palette setup
		ldx	#PALETTE_RAM_START
		ldd	#$001f
		jsr	palette_color_setup

		; green palette setup
		ldx	#PALETTE_RAM_START+PALETTE_SIZE
		ldd	#$03e0
		jsr	palette_color_setup

		; blue palette setup
		ldx	#PALETTE_RAM_START+(PALETTE_SIZE*2)
		ldd	#$7c00
		jsr	palette_color_setup

		; combined/all palette setup
		ldx	#PALETTE_RAM_START+(PALETTE_SIZE*3)
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

		; Treat r_tiles_table as a multidimensional array of
		;  word[VD_NUM_COLORS][VD_NUM_BITS_PER_COLOR]
		; where:
		;  f is the first index (color)
		;  e is the second index (color bit for that color)
		ldy	#r_tiles_table

		; start at [0][0], red bit 0
		clrw

	.draw_full_screen:
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

		ldx	#TILE2_RAM_START
		ldw	#TILE2_RAM_SIZE
	.loop_next_address:
		sta	-$2000, x
		stb	, x+
		decw
		bne	.loop_next_address
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
		ble	.draw_full_screen
		ldf	#MAX_COLOR_BIT_INDEX
		bra	.draw_full_screen

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		adde	#1
		cmpe	#MAX_COLOR_BIT_INDEX
		ble	.draw_full_screen
		clre
		bra	.draw_full_screen

	.right_not_pressed:
		bita	#INPUT_B2
		beq	.loop_input
		rts

; Given the raw tile numbers, generate a table that has
; the required tile+palette number for each color/color bit
; The tile number is already in the proper format with the
; 'r' gap in them.
; Tile Layout
;  PP?T TTrT TTTT TTTT
; where
;  P = palette number
;  T = tile number
;  r = reverse tile
generate_tiles_table:
		ldx	#r_tiles_table
		clr	r_generate_tiles_palette_num
		ldf	#VD_NUM_COLORS

	.loop_next_color:
		ldy	#d_tiles_raw
		lde	#$6		; # of raw tiles

	.loop_next_raw_tile:
		ldd	, y++
		adda	r_generate_tiles_palette_num
		std	, x++

		dece
		bne	.loop_next_raw_tile

		lda	r_generate_tiles_palette_num
		adda	#$40		; next palette
		sta	r_generate_tiles_palette_num

		decf
		bne	.loop_next_color
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
		PSUB	screen_seek_xy

		ldd	,y++
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
		sta	-$2000, x
		sta	-($2000 - $40), x
		sta	-($2000 - $80), x
		sta	-($2000 - $c0), x
		stb	0, x
		stb	$40, x
		stb	$80, x
		stb	$c0, x
		leax	1, x		; next row
		dece
		bne	.loop_next_row
		rts

; params:
;  d = color's bits set to 1's
;  x = palette start address
palette_color_setup:
		std	r_palette_color_bits
		ldy	#d_palette_offsets
		ldf	#(VD_NUM_BITS_PER_COLOR - 1)	; number bits (not including all/combined)
		ldd	#$421				; used for mask, bit 0 of each color set
		std	r_palette_color_mask

	.loop_next_offset:
		lde	, y+
		ldd	r_palette_color_bits
		andd	r_palette_color_mask

		std	e, x

		ldd	r_palette_color_mask
		lsld
		std	r_palette_color_mask

		decf
		bne	.loop_next_offset

		; all bits enabled for this individual color
		lde	, y
		ldd	r_palette_color_bits
		std	e, x

		rts

	section data

d_palette_offsets:
	dc.b	VD_TILE_B0_PAL_OFFSET, VD_TILE_B1_PAL_OFFSET, VD_TILE_B2_PAL_OFFSET, VD_TILE_B3_PAL_OFFSET, VD_TILE_B4_PAL_OFFSET, VD_TILE_BA_PAL_OFFSET

d_tiles_raw:
	dc.w	VD_TILE_B0_NUM, VD_TILE_B1_NUM, VD_TILE_B2_NUM, VD_TILE_B3_NUM, VD_TILE_B4_NUM, VD_TILE_BA_NUM

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "VIDEO DAC TEST"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "B0  B1  B2  B3  B4  ALL"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - FULL SCREEN"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

	section bss
r_draw_colors_x_offset:
	dcb.b	1
r_draw_colors_y_offset:
	dcb.b	1
r_generate_tiles_palette_num:
	dcb.b	1
r_palette_color_bits:
	dcb.w	1
r_palette_color_mask:
	dcb.w	1

r_tiles_table:
	dcb.w	VD_NUM_COLORS*VD_NUM_BITS_PER_COLOR

