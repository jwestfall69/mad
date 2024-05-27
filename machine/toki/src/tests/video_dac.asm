; There is a difference between mame and hardware with the number
; of bits per pixel, at least for tiles.
;   mame     is xxxx BBBB GGGG RRRR
;   hardware is xxxx xBBB xGGG xRRR
; With the upper bit for each color does nothing on hardware.
;
; The video dac test is targetted at hardware so running it in
; mame renders a little weird.  There is a large increase in
; brightness between B2 and ALL.  Whereas on hardware it looks
; as expected.

	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/menu_input.inc"
	include "cpu/68000/include/xy_string.inc"

	include "mad_rom.inc"
	include "machine.inc"
	include "video_dac.inc"

	global video_dac_test

	section code

video_dac_test:

		RSUB	screen_clear

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		; red palette setup
		lea	PALETTE_RAM_START+$200+PALETTE_SIZE, a0
		move.w	#$f, d0
		bsr	palette_setup_color

		; green palette setup
		lea	PALETTE_RAM_START+$200+(PALETTE_SIZE*2), a0
		move.w	#$f0, d0
		bsr	palette_setup_color

		; blue palette setup
		lea	PALETTE_RAM_START+$200+(PALETTE_SIZE*3), a0
		move.w	#$f00, d0
		bsr	palette_setup_color

		; combined/all palette setup
		lea	PALETTE_RAM_START+$200+(PALETTE_SIZE*4), a0
		move.w	#$fff, d0
		bsr	palette_setup_color

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

; In full screen mode we fill the entire fg ram with a single
; tile/color bit to allow isolating it for testing
full_screen:

		lea	TILES_ARRAY, a1
		moveq	#0, d2		; color bit per color
		moveq	#0, d3		; color

	.draw_full_screen:
		move.w	d2, d4
		add.w	d3, d4
		move.w	(a1, d4.w), d1
		lea	FG_RAM_START, a0
		move.l	#(FG_RAM_SIZE / 2) - 1, d0

	.loop_next_address:
		move.w	d1, (a0)+
		dbra	d0, .loop_next_address

	.loop_input:

		; slow down the loop a little, seem to be
		; hitting a button bounce issue sometimes
		;move.l	#$ffff, d0
		;RSUB	delay

		bsr	menu_input_generic

		btst	#MENU_DOWN_BIT, d0
		beq	.down_not_pressed
		add.w	#8, d3			; goto next color in array
		cmp.w	#32, d3			; past end of array?
		bne	.draw_full_screen
		moveq	#0, d3
		bra	.draw_full_screen
	.down_not_pressed:

		btst	#MENU_UP_BIT, d0
		beq	.up_not_pressed
		sub.w	#8, d3			; goto previous color in array
		bpl	.draw_full_screen	; before start of array?
		move.w	#24, d3
		bra	.draw_full_screen
	.up_not_pressed:

		btst	#MENU_RIGHT_BIT, d0
		beq	.right_not_pressed
		addq.w	#2, d2			; goto next color bit in array
		cmp.b	#8, d2			; past end of color bits for this color?
		bne	.draw_full_screen
		moveq	#0, d2
		bra	.draw_full_screen
	.right_not_pressed:

		btst	#MENU_LEFT_BIT, d0
		beq	.left_not_pressed
		subq.w	#2, d2			; goto previous color bit in array
		bpl	.draw_full_screen	; before start of color bits for this color?
		moveq	#6, d2
		bra	.draw_full_screen
	.left_not_pressed:

		btst	#MENU_EXIT_BIT, d0
		bne	.full_screen_exit
		bra	.loop_input
	.full_screen_exit:

		rts

	section	data

; draws the 4x4 color cubes for all colors
draw_color_cubes:
		SEEK_XY 8, 6
		lea	TILES_ARRAY, a0

		moveq	#3, d2		; number of colors - 1
	.loop_next_color:
		movem.l	d2, -(a7)
		move.w	(a0)+, d2	; bit 0
		move.w	(a0)+, d3	; bit 1
		move.w	(a0)+, d4	; bit 2
		move.w	(a0)+, d5	; all
		moveq	#3, d0		; of rows - 1

	.loop_next_row:
		moveq	#3, d1		; number of blocks per bit - 1

	.loop_next_block:
		movem.l	d1, -(a7)
		lsl.l	#1, d1
		move.w	d2, (a6, d1.w)
		move.w	d3, 8(a6, d1.w)
		move.w	d4, 16(a6, d1.w)
		move.w	d5, 24(a6, d1.w)
		movem.l	(a7)+, d1

		dbra	d1, .loop_next_block

		add.l	#$40, a6	; got next line
		dbra	d0, .loop_next_row

		movem.l	(a7)+, d2
		dbra	d2, .loop_next_color

		rts
; params:
;  a0 = palette start address
;  d0 = color bits set to 1's (word)
palette_setup_color:

		moveq	#2, d5
		move.w	#$111, d4	; bit mask
		lea	PALETTE_OFFSETS, a1

	.loop_next_offset:
		move.w	(a1)+, d1
		move.w	d0, d2
		and.w	d4, d2
		move.w	d2, (a0, d1.w)	; individual B0 to B3
		lsl.w	#1, d4
		dbra	d5, .loop_next_offset

		move.w	(a1), d1	; all/combined
		move.w	d0, (a0, d1.w)

		rts

	section data

	align 2

PALETTE_OFFSETS:
	dc.w	TILE_B0_PAL_OFFSET, TILE_B1_PAL_OFFSET, TILE_B2_PAL_OFFSET, TILE_BA_PAL_OFFSET

; fg tile layout
; PPPP TTTT TTTT TTTT
;  P = palette number
;  T = tile number
; The bit shifts below are setting the palette numbers
TILES_ARRAY:
		dc.w TILE_B0_NUM | (1<<12), TILE_B1_NUM | (1<<12), TILE_B2_NUM | (1<<12), TILE_BA_NUM | (1<<12)	; red
		dc.w TILE_B0_NUM | (2<<12), TILE_B1_NUM | (2<<12), TILE_B2_NUM | (2<<12), TILE_BA_NUM | (2<<12)	; green
		dc.w TILE_B0_NUM | (3<<12), TILE_B1_NUM | (3<<12), TILE_B2_NUM | (3<<12), TILE_BA_NUM | (3<<12)	; blue
		dc.w TILE_B0_NUM | (4<<12), TILE_B1_NUM | (4<<12), TILE_B2_NUM | (4<<12), TILE_BA_NUM | (4<<12)	; all/combined

SCREEN_XYS_LIST:
	XY_STRING 9,  2, "VIDEO DAC TEST"
	XY_STRING 9,  5, "B0  B1  B2  ALL"
	XY_STRING 3, 24, "B1 - FULL SCREEN"
	XY_STRING 3, 25, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
