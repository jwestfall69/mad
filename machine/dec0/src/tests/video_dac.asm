	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/menu_input.inc"
	include "cpu/68000/include/xy_string.inc"

	include "mad_rom.inc"
	include "machine.inc"

	global video_dac_test

	section code

video_dac_test:

		RSUB	screen_clear

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

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

	ifd _PRINT_COLUMN_
		SEEK_XY	1, 6
	else
		SEEK_XY	2, 6
	endif
		bsr	draw_color_cubes

	.loop_input:
		bsr	menu_input_generic

		btst	#MENU_EXIT_BIT, d0
		bne	.test_exit

		btst	#MENU_BUTTON_BIT, d0
		beq	.loop_input

		bsr	full_screen
		bra	video_dac_test

	.test_exit:
		rts

; In full screen mode we fill the entire tile1 ram with a single
; tile/color bit to allow isolating it for testing
full_screen:

		lea	TILES_TABLE, a1
		moveq	#0, d2		; color bit per color
		moveq	#0, d3		; color

	.draw_full_screen:
		move.w	d2, d4
		add.w	d3, d4
		move.w	(a1, d4.w), d1
		lea	TILE1_RAM_START, a0
		move.w	#(TILE1_RAM_SIZE / 2) - 1, d0

	.loop_next_address:
		move.w	d1, (a0)+
		dbra	d0, .loop_next_address

	.loop_input:
		bsr	menu_input_generic

		btst	#MENU_DOWN_BIT, d0
		beq	.down_not_pressed
		add.w	#9*2, d3		; goto next color in array
		cmp.w	#9*2*4, d3		; past end of array?
		bne	.draw_full_screen
		moveq	#0, d3
		bra	.draw_full_screen
	.down_not_pressed:

		btst	#MENU_UP_BIT, d0
		beq	.up_not_pressed
		sub.w	#9*2, d3		; goto previous color in array
		bpl	.draw_full_screen	; before start of array?
		move.w	#9*2*3, d3
		bra	.draw_full_screen
	.up_not_pressed:

		btst	#MENU_RIGHT_BIT, d0
		beq	.right_not_pressed
		addq.w	#2, d2			; goto next color bit in array
		cmp.b	#9*2, d2		; past end of color bits for this color?
		bne	.draw_full_screen
		moveq	#0, d2
		bra	.draw_full_screen
	.right_not_pressed:

		btst	#MENU_LEFT_BIT, d0
		beq	.left_not_pressed
		subq.w	#2, d2			; goto previous color bit in array
		bpl	.draw_full_screen	; before start of color bits for this color?
		moveq	#8*2, d2
		bra	.draw_full_screen
	.left_not_pressed:

		btst	#MENU_EXIT_BIT, d0
		bne	.full_screen_exit
		bra	.loop_input
	.full_screen_exit:

		rts

	section	data

; This generates a TILES_TILE containing the needed 36x TILE+PALETTE#
; tile layout
; PPPP TTTT TTTT TTTT
; where
;  P = palette numern
;  T = tile number
generate_tiles_table:
		move.w	#$1000, d0		; start palette
		lea	TILES_TABLE, a0

		moveq	#3, d1			; 4 colors (rgb+all)
	.loop_next_color:

		moveq	#2, d2			; 3 chunks of 3
	.loop_next_chunk_of_3:
		move.w	#TILE_B036_NUM, d3
		or.w	d0, d3
		move.w	d3, (a0)+

		move.w	#TILE_B147_NUM, d3
		or.w	d0, d3
		move.w	d3, (a0)+

		move.w	#TILE_B25A_NUM, d3
		or.w	d0, d3
		move.w	d3, (a0)+

		add.w	#$1000, d0		; next palette
		dbra	d2, .loop_next_chunk_of_3

		dbra	d1, .loop_next_color

		rts

	ifd _PRINT_COLUMN_
draw_color_cubes:
		lea	TILES_TABLE, a0
		moveq	#3, d0			; 4 colors
	.loop_next_color:
		move.l	a6, a5
		moveq	#8, d1			; 9 cubes per color
	.loop_next_color_block:
		move.w	(a0)+, d2		; tile

		; draws an individual cube
		move.w	d2, (a6)
		move.w	d2, ($40, a6)
		move.w	d2, ($80, a6)
		move.w	d2, (-$2, a6)
		move.w	d2, ($40-$2, a6)
		move.w	d2, ($80-$2, a6)
		move.w	d2, (-$4, a6)
		move.w	d2, ($40-$4, a6)
		move.w	d2, ($80-$4, a6)

		lea	($c0, a6), a6		; start of next block in on screen
		dbra	d1, .loop_next_color_block

		move.l	a5, a6
		lea	(-$6, a6), a6		; goto next color start location
		dbra	d0, .loop_next_color
		rts

	else
draw_color_cubes:
		lea	TILES_TABLE, a0
		moveq	#3, d0			; 4 colors
	.loop_next_color:

		moveq	#8, d1			; 9 cubes per color
	.loop_next_color_block:
		move.w	(a0)+, d2		; tile

		; draws an individual cube
		move.w	d2, (a6)
		move.w	d2, ($2, a6)
		move.w	d2, ($4, a6)
		move.w	d2, ($40, a6)
		move.w	d2, ($40+$2, a6)
		move.w	d2, ($40+$4, a6)
		move.w	d2, ($80, a6)
		move.w	d2, ($80+$2, a6)
		move.w	d2, ($80+$4, a6)

		lea	($6, a6), a6		; start of next block in on screen
		dbra	d1, .loop_next_color_block

		lea	($80+$a, a6), a6	; goto next color start location
		dbra	d0, .loop_next_color
		rts
	endif
; params:
;  a0 = palette start address
;  d0 = color bits set to 1's (word)
palette_setup_color:

		moveq	#2, d6
		move.w	#$101, d4	; bit mask

	.loop_next_palette:
		lea	PALETTE_OFFSETS, a1
		moveq	#2, d5

	.loop_next_offset:
		move.w	(a1)+, d1
		move.w	d0, d2
		and.w	d4, d2
		move.w	d2, (a0, d1.w)
		lsl.w	#1, d4
		dbra	d5, .loop_next_offset

	; hbarrel only has 2x solid color tiles, so we have to use
	; a single dual color tile.  This is a hack to also apply
	; the color to the 2nd offset in the palette
	ifd _ROMSET_HBARREL_
		move.w	d2, (TILE_B25A_PAL_OFFSET2, a0)
	endif

		add.l	#PALETTE_SIZE, a0
		dbra	d6, .loop_next_palette

		;move.w	(a1), d1	; all/combined
		sub.l	#PALETTE_SIZE, a0
		move.w	d0, (a0, d1.w)

	ifd _ROMSET_HBARREL_
		move.w	d0, (TILE_B25A_PAL_OFFSET2, a0)
	endif


		rts

	section data

	align 2

PALETTE_OFFSETS:
	dc.w	TILE_B036_PAL_OFFSET, TILE_B147_PAL_OFFSET, TILE_B25A_PAL_OFFSET

SCREEN_XYS_LIST:
	ifd _PRINT_COLUMN_
		XY_STRING 8,  2, "VIDEO DAC TEST"
		XY_STRING 2,  5, "0  1  2  3  4  5  6  7 ALL"
	else
		XY_STRING 9,  2, "VIDEO DAC TEST"
		XY_STRING 3,  5, "0  1  2  3  4  5  6  7 ALL"
	endif
	XY_STRING 3, 24, "B1 - FULL SCREEN"
	XY_STRING 3, 25, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

	section bss

	align 2

TILES_TABLE:
	dcb.w	4*9		; 4 colors (rgb+combined) * 9 color blocks each
