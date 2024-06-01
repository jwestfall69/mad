	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/menu_input.inc"
	include "cpu/68000/include/xy_string.inc"

	include "mad_rom.inc"
	include "machine.inc"

	global video_dac_test

	section code

video_dac_test:
		move.b	#$f, BRIGHTNESS

		RSUB	screen_clear

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		bsr	palette_setup
		bsr	draw_color_cubes

	.loop_input:
		SEEK_XY	32, 20
		move.b	BRIGHTNESS, d0
		RSUB	print_hex_nibble

		bsr	menu_input_generic

		btst	#MENU_RIGHT_BIT, d0
		beq	.right_not_pressed
		move.b	BRIGHTNESS, d1
		addq.b	#1, d1
		and.b	#$f, d1
		move.b	d1, BRIGHTNESS
		bsr	palette_setup
		bra	.loop_input
	.right_not_pressed:

		btst	#MENU_LEFT_BIT, d0
		beq	.left_not_pressed
		move.b	BRIGHTNESS, d1
		subq.b	#1, d1
		and.b	#$f, d1
		move.b	d1, BRIGHTNESS
		bsr	palette_setup
		bra	.loop_input
	.left_not_pressed:

		btst	#MENU_EXIT_BIT, d0
		bne	.test_exit

		btst	#MENU_BUTTON_BIT, d0
		beq	.loop_input

		bsr	full_screen
		bra	video_dac_test

	.test_exit:
		rts

; In full screen mode we fill the entire fg ram with a single
; tile/color bit to allow isolating it for testing
full_screen:

		lea	TILES_ARRAY, a1
		moveq	#0, d2		; color bit per color
		moveq	#0, d3		; color

	.draw_full_screen:
		move.w	d2, d4
		add.w	d3, d4
		move.l	(a1, d4.w), d1
		lea	SCROLL1_RAM_START, a0
		move.l	#(SCROLL1_RAM_SIZE / 4) - 1, d0

	.loop_next_address:
		move.l	d1, (a0)+
		dbra	d0, .loop_next_address

	.loop_input:
		bsr	menu_input_generic

		btst	#MENU_DOWN_BIT, d0
		beq	.down_not_pressed
		add.w	#20, d3			; goto next color in array
		cmp.w	#80, d3			; past end of array?
		bne	.draw_full_screen
		moveq	#0, d3
		bra	.draw_full_screen
	.down_not_pressed:

		btst	#MENU_UP_BIT, d0
		beq	.up_not_pressed
		sub.w	#20, d3			; goto previous color in array
		bpl	.draw_full_screen	; before start of array?
		move.w	#60, d3
		bra	.draw_full_screen
	.up_not_pressed:

		btst	#MENU_RIGHT_BIT, d0
		beq	.right_not_pressed
		addq.w	#4, d2			; goto next color bit in array
		cmp.b	#20, d2			; past end of color bits for this color?
		bne	.draw_full_screen
		moveq	#0, d2
		bra	.draw_full_screen
	.right_not_pressed:

		btst	#MENU_LEFT_BIT, d0
		beq	.left_not_pressed
		subq.w	#4, d2			; goto previous color bit in array
		bpl	.draw_full_screen	; before start of color bits for this color?
		moveq	#16, d2
		bra	.draw_full_screen
	.left_not_pressed:

		btst	#MENU_EXIT_BIT, d0
		bne	.full_screen_exit
		bra	.loop_input
	.full_screen_exit:

		rts

draw_color_cubes:
		SEEK_XY 14, 6
		lea	TILES_ARRAY, a0

		moveq	#3, d0				; 4 colors
	.loop_next_color:
		move.l	a6, a5
		moveq	#4, d1				; 5 cubes per color
	.loop_next_color_block:
		move.l	(a0)+, d2			; tile for this cube

		; draws an individual cube
		move.l	d2, (a6)
		move.l	d2, ($80, a6)
		move.l	d2, ($100, a6)
		move.l	d2, ($180, a6)
		move.l	d2, ($4, a6)
		move.l	d2, ($80+$4, a6)
		move.l	d2, ($100+$4, a6)
		move.l	d2, ($180+$4, a6)
		move.l	d2, ($8, a6)
		move.l	d2, ($80+$8, a6)
		move.l	d2, ($100+$8, a6)
		move.l	d2, ($180+$8, a6)

		lea	($80*$4, a6), a6		; start of next block in on screen
		dbra	d1, .loop_next_color_block

		move.l	a5, a6
		lea 	($c, a6), a6 			; goto next color start location
		dbra	d0, .loop_next_color
		rts

palette_setup:
		; red palette setup
		lea	PALETTE_RAM_START+PALETTE_SIZE, a0
		move.w	#$f00, d0
		bsr	palette_setup_color

		; green palette setup
		lea	PALETTE_RAM_START+(PALETTE_SIZE*2), a0
		move.w	#$f0, d0
		bsr	palette_setup_color

		; blue palette setup
		lea	PALETTE_RAM_START+(PALETTE_SIZE*3), a0
		move.w	#$f, d0
		bsr	palette_setup_color

		; combined/all palette setup
		lea	PALETTE_RAM_START+(PALETTE_SIZE*4), a0
		move.w	#$fff, d0
		bsr	palette_setup_color
		rts

; params:
;  a0 = palette start address
;  d0 = color bits set to 1's (word)
palette_setup_color:

		moveq	#3, d5
		move.w	#$111, d4	; bit mask
		move.b	BRIGHTNESS, d3
		and.l	#$f, d3
		swap	d3
		lsr.l	#4, d3
		lea	PALETTE_OFFSETS, a1

	.loop_next_offset:
		move.w	(a1)+, d1
		move.w	d0, d2
		and.w	d4, d2
		or.w	d3, d2		; add in brightness value
		move.w	d2, (a0, d1.w)	; individual B0 to B3
		lsl.w	#1, d4
		dbra	d5, .loop_next_offset

		; all/combined
		move.w	(a1)+, d1
		or.w	d3, d0
		move.w	d0, (a0, d1.w)

		rts

	section data

	align 2

PALETTE_OFFSETS:
	dc.w	TILE_B0_PAL_OFFSET, TILE_B1_PAL_OFFSET, TILE_B2_PAL_OFFSET, TILE_B3_PAL_OFFSET, TILE_BA_PAL_OFFSET

; fg tile layout
; TTTT TTTT TTTT TTTT ???? ???? ???? PPPP
; where
;  P = palette number
;  T = lower 8 bits of tile number
TILES_ARRAY:
		dc.l (TILE_B0_NUM<<16) | 1, (TILE_B1_NUM<<16) | 1, (TILE_B2_NUM<<16) | 1, (TILE_B3_NUM<<16) | 1, (TILE_BA_NUM<<16) | 1	; red
		dc.l (TILE_B0_NUM<<16) | 2, (TILE_B1_NUM<<16) | 2, (TILE_B2_NUM<<16) | 2, (TILE_B3_NUM<<16) | 2, (TILE_BA_NUM<<16) | 2	; green
		dc.l (TILE_B0_NUM<<16) | 3, (TILE_B1_NUM<<16) | 3, (TILE_B2_NUM<<16) | 3, (TILE_B3_NUM<<16) | 3, (TILE_BA_NUM<<16) | 3	; blue
		dc.l (TILE_B0_NUM<<16) | 4, (TILE_B1_NUM<<16) | 4, (TILE_B2_NUM<<16) | 4, (TILE_B3_NUM<<16) | 4, (TILE_BA_NUM<<16) | 4	; all/combined

SCREEN_XYS_LIST:
	XY_STRING 17,  2, "VIDEO DAC TEST"
	XY_STRING 15,  5, "B0  B1  B2  B3  ALL"
	XY_STRING 14, 20, "BRIGHTNESS LEVEL:"
	XY_STRING  2, 23, "L/R - ADJUST BRIGHTNESS LEVEL"
	XY_STRING  3, 24, "B1 - FULL SCREEN"
	XY_STRING  3, 25, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

	section bss

BRIGHTNESS:
	dc.b	$0
