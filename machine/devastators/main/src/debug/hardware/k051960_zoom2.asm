	include "cpu/6309/include/common.inc"

	global k051960_zoom2_debug

; This test requires you replace the sprite roms (890f04.h4, 890f05.k4)
; with ones filled with 0xff.  On hardware this can be done by using
; blank 27c4100 eproms in place of the sprite mask roms.

	section code

k051960_zoom2_debug:
		clr	r_zoom

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		; sprite palette
		ldx	#SPRITE_PALETTE + (7 * PALETTE_SIZE) + $2
		ldd	#$ffff
		ldw	#$f
		RSUB	memory_fill_word

		ldx	#d_sprite_data
		ldy	#SPRITE_RAM
		ldd	#(4 * 8)
		jsr	memory_copy

		; grid color
		ldx	#FIX_TILE_PALETTE + (2 * PALETTE_SIZE) + $2
		ldd	#$1f
		ldw	#$f
		RSUB	memory_fill_word
		clrd
		std	FIX_TILE_PALETTE + (2 * PALETTE_SIZE) + $18

		ldd	#$8d62
		lde	#SCREEN_START_Y + 3
		ldf	#$12
		jsr	draw_grid

		ldd	#$ad4f
		lde	#SCREEN_START_Y + 2
		ldf	#$1
		jsr	draw_grid

		ldd	#$ad4f
		lde	#SCREEN_START_Y + 9
		ldf	#$1
		jsr	draw_grid

	.write_zoom:
		lda	r_zoom
		anda	#$3f
		sta	r_zoom
		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 1)
		RSUB	print_hex_byte

		lda	r_zoom
		lsla
		lsla
		sta	SPRITE_RAM + 6
		sta	SPRITE_RAM + 14
		sta	SPRITE_RAM + 22
		sta	SPRITE_RAM + 30

		sta	SPRITE_RAM + 4
		sta	SPRITE_RAM + 12
		sta	SPRITE_RAM + 20
		sta	SPRITE_RAM + 28

	.loop_input:
		WATCHDOG
		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		inc	r_zoom
		bra	.write_zoom

	.right_not_pressed:
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		dec	r_zoom
		bra	.write_zoom

	.left_not_pressed:
		bita	#INPUT_B2
		beq	.loop_input
		rts

; d = tile
; e = start y offset
; f = number of rows
draw_grid:
		ste	r_y_offset
		std	r_scratch

		tfr	f, e
	.loop_next_row:
		clra
		ldb	r_y_offset
		RSUB	screen_seek_xy
		leax	$800, x		; jump from fix to layer a

		ldf	#$1c
		ldd	r_scratch
	.loop_next_column:
		sta	-$2000, x
		stb	, x
		leax	-$40, x
		decf
		bne	.loop_next_column

		inc	r_y_offset
		dece
		bne	.loop_next_row
		rts

	section data

d_sprite_data:
	dc.b	$ca, $e0, $00, $07, $00, $96, $00, $b3
	dc.b	$cb, $c0, $00, $07, $00, $e6, $00, $eb
	dc.b	$cc, $60, $00, $07, $00, $ce, $00, $b3
	dc.b	$cd, $00, $00, $07, $00, $e6, $00, $b3


d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 1), "ZOOM"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "LR - DEC/INC ZOOM"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

	section bss

r_y_offset:		dcb.b 1
r_zoom:			dcb.b 1
