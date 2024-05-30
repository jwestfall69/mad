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
		lea	PALETTE_RAM_START+PALETTE_SIZE, a0
		move.l	#$1f, d0
		bsr	palette_setup_color

		; green palette setup
		lea	PALETTE_RAM_START+(PALETTE_SIZE*2), a0
		move.l	#$300e0, d0
		bsr	palette_setup_color

		; blue palette setup
		lea	PALETTE_RAM_START+(PALETTE_SIZE*3), a0
		move.l	#$7c0000, d0
		bsr	palette_setup_color

		; combined/all palette setup
		lea	PALETTE_RAM_START+(PALETTE_SIZE*4), a0
		move.l	#$ff00ff, d0
		bsr	palette_setup_color

		bsr	draw_color_cubes

	.loop_input:
		WATCHDOG
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
		move.b	(a1, d4.w), d5
		move.b	1(a1, d4.w), d6
		lea	TILE_RAM_START, a0
		move.l	#($2000 / 2) - 1, d0

	.loop_next_address:
		move.b	d5, (a0)+
		move.b	d6, (a0)+
		dbra	d0, .loop_next_address

	.loop_input:
		WATCHDOG
		bsr	menu_input_generic

		btst	#MENU_DOWN_BIT, d0
		beq	.down_not_pressed
		add.w	#2*6, d3		; goto next color in array
		cmp.w	#2*6*4, d3		; past end of array?
		bne	.draw_full_screen
		moveq	#0, d3
		bra	.draw_full_screen
	.down_not_pressed:

		btst	#MENU_UP_BIT, d0
		beq	.up_not_pressed
		sub.w	#2*6, d3		; goto previous color in array
		bpl	.draw_full_screen	; before start of array?
		move.w	#2*6*3, d3
		bra	.draw_full_screen
	.up_not_pressed:

		btst	#MENU_RIGHT_BIT, d0
		beq	.right_not_pressed
		addq.w	#2, d2			; goto next color bit in array
		cmp.b	#2*6, d2			; past end of color bits for this color?
		bne	.draw_full_screen
		moveq	#0, d2
		bra	.draw_full_screen
	.right_not_pressed:

		btst	#MENU_LEFT_BIT, d0
		beq	.left_not_pressed
		subq.w	#2, d2			; goto previous color bit in array
		bpl	.draw_full_screen	; before start of color bits for this color?
		moveq	#2*5, d2
		bra	.draw_full_screen
	.left_not_pressed:

		btst	#MENU_EXIT_BIT, d0
		bne	.full_screen_exit
		bra	.loop_input
	.full_screen_exit:

		rts

	section	data

draw_color_cubes:
		SEEK_XY	9, 6
		lea	TILES_ARRAY, a0

		move.w	#3, d6			; number of colors
	.loop_next_color:
		move.w	#5, d5			; number of bits

	.loop_next_color_bit:
		move.w	#2, d4			; number of rows per bit
		move.b	(a0)+, d0
		move.b	(a0)+, d1
		moveq	#0, d3
		move.l	a6, a5

	.loop_next_row:
		move.b	d0, (a5)+		; draw a row for this block
		move.b	d1, (a5)+		; need to write as bytes
		move.b	d0, (a5)+
		move.b	d1, (a5)+
		move.b	d0, (a5)+
		move.b	d1, (a5)+
		move.b	d0, (a5)+
		move.b	d1, (a5)+
		lea	($80-$8, a5), a5	; next row for this block
		dbra	d4, .loop_next_row

		lea	($8, a6), a6		; jump to next blocks starting point
		dbra	d5, .loop_next_color_bit

		lea	($180-$30, a6), a6	; jumps down to next color
		dbra	d6, .loop_next_color
		rts

; params:
;  a0 = palette start address
;  d0 = color bits set to 1's (word)
palette_setup_color:

		moveq	#4, d5
		move.l	#$42021, d4	; bit mask
		lea	PALETTE_OFFSETS, a1

	.loop_next_offset:
		move.w	(a1)+, d1
		lsl.l	#1, d1
		move.l	d0, d2
		and.l	d4, d2
		move.l	d2, (a0, d1.w)	; individual B0 to B4
		lsl.l	#1, d4
		dbra	d5, .loop_next_offset

		move.w	(a1), d1	; all/combined
		asl.l	#1, d1
		move.l	d0, (a0, d1.w)

		rts

	section data

	align 2

PALETTE_OFFSETS:
	dc.w	TILE_B0_PAL_OFFSET, TILE_B1_PAL_OFFSET, TILE_B2_PAL_OFFSET, TILE_B3_PAL_OFFSET, TILE_B4_PAL_OFFSET, TILE_BA_PAL_OFFSET

; tile layout
; PPP? ???? TTTT TTTT
; where
;  P = palette number
;  T = tile number
; The bit shifts below are setting the palette numbers
TILES_ARRAY:
		dc.w TILE_B0_NUM | (1<<13), TILE_B1_NUM | (1<<13), TILE_B2_NUM | (1<<13), TILE_B3_NUM | (1<<13), TILE_B4_NUM | (1<<13), TILE_BA_NUM | (1<<13)	; red
		dc.w TILE_B0_NUM | (2<<13), TILE_B1_NUM | (2<<13), TILE_B2_NUM | (2<<13), TILE_B3_NUM | (2<<13), TILE_B4_NUM | (2<<13), TILE_BA_NUM | (2<<13)	; green
		dc.w TILE_B0_NUM | (3<<13), TILE_B1_NUM | (3<<13), TILE_B2_NUM | (3<<13), TILE_B3_NUM | (3<<13), TILE_B4_NUM | (3<<13), TILE_BA_NUM | (3<<13)	; blue
		dc.w TILE_B0_NUM | (4<<13), TILE_B1_NUM | (4<<13), TILE_B2_NUM | (4<<13), TILE_B3_NUM | (4<<13), TILE_B4_NUM | (4<<13), TILE_BA_NUM | (4<<13)	; all/combined

SCREEN_XYS_LIST:
	XY_STRING 13,  2,"VIDEO DAC TEST"
	XY_STRING 10,  5, "B0  B1  B2  B3  B4  ALL"
	XY_STRING 3, 24, "B1 - FULL SCREEN"
	XY_STRING 3, 25, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
