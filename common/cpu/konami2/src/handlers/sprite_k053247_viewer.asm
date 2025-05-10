	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/macros.inc"
	include "cpu/konami2/include/xy_string.inc"
	include "cpu/konami2/include/handlers/sprite_k053247_viewer.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global sprite_k053247_viewer_handler

	section code

; sprite attributes
SA_SPRITE_NUM		equ $0
SA_SPRITE_WIDTH		equ $1
SA_SPRITE_HEIGHT	equ $2
SA_SPRITE_ZOOM		equ $3
SA_POS_X		equ $4
SA_POS_Y		equ $5
SA_MAX			equ SA_POS_Y

; params:
;  x = address of sprite struct
;  y = address of draw_sprite callback
sprite_k053247_viewer_handler:

		stx	r_sprite_struct
		sty	r_draw_sprite_cb

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		clr	r_cursor
		clrb

	.update_cursor:
		; b should already contain old r_cursor
		lda	#SCREEN_START_X - 1
		addb	#(SCREEN_START_Y + 2)
		RSUB	screen_seek_xy
		lda	#CURSOR_CLEAR_CHAR
		RSUB	print_char

		lda	#SCREEN_START_X - 1
		ldb	r_cursor
		addb	#(SCREEN_START_Y + 2)
		RSUB	screen_seek_xy
		lda	#CURSOR_CHAR
		RSUB	print_char

	.loop_test:
		WATCHDOG
		jsr	[r_draw_sprite_cb]

		jsr	input_update
		lda	r_input_edge
		bita	#INPUT_B1
		beq	.b1_not_pressed
		ldb	r_cursor		; backup old

		inc	r_cursor
		lda	r_cursor
		cmpa	#SA_MAX
		ble	.update_cursor
		clr	r_cursor
		bra	.update_cursor

	.b1_not_pressed:
		bita	#INPUT_B2
		beq	.b2_not_pressed
		rts

	.b2_not_pressed:
		; handle joystick input for the currently
		; selected attribute/cursor
		ldy	r_sprite_struct
		lda	r_cursor
		cmpa	#SA_SPRITE_NUM
		bne	.not_ss_sprite_num
		ldd	#$3ff
		ldx	#r_input_edge
		leay	s_ks_sprite_num, y
		bra	.joystick_update_word

	.not_ss_sprite_num:
		cmpa	#SA_SPRITE_HEIGHT
		bne	.not_ss_sprite_height
		lda	#$3
		ldx	#r_input_edge
		leay	s_ks_sprite_height, y
		bra	.joystick_update_byte

	.not_ss_sprite_height:
		cmpa	#SA_SPRITE_WIDTH
		bne	.not_ss_sprite_width
		lda	#$3
		ldx	#r_input_edge
		leay	s_ks_sprite_width, y
		bra	.joystick_update_byte

	.not_ss_sprite_width:
		cmpa	#SA_SPRITE_ZOOM
		bne	.not_ss_sprite_zoom
		lda	#$ff
		ldx	#r_input_edge
		leay	s_ks_sprite_zoom, y
		bra	.joystick_update_byte

	.not_ss_sprite_zoom:
		cmpa	#SA_POS_X
		bne	.not_ss_pos_x
		ldd	#$3ff
		ldx	#r_input_raw
		leay	s_ks_sprite_pos_x, y
		bra	.joystick_update_word

	.not_ss_pos_x:
		cmpa	#SA_POS_Y
		bne	.not_ss_pos_y
		ldd	#$3ff
		ldx	#r_input_raw
		leay	s_ks_sprite_pos_y, y
		bra	.joystick_update_word

	.not_ss_pos_y:
		rts	; shouldn't happen

	.joystick_update_byte:
		jsr	joystick_update_byte
		bra	.print_values

	.joystick_update_word:
		jsr	joystick_update_word

	.print_values:
		SEEK_XY	(SCREEN_START_X + 14), (SCREEN_START_Y + 2)
		ldy	r_sprite_struct
		ldd	s_ks_sprite_num, y
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 17), (SCREEN_START_Y + 3)
		ldy	r_sprite_struct
		ldd	s_ks_sprite_width, y
		RSUB	print_hex_nibble

		SEEK_XY	(SCREEN_START_X + 17), (SCREEN_START_Y + 4)
		ldy	r_sprite_struct
		ldd	s_ks_sprite_height, y
		RSUB	print_hex_nibble

		SEEK_XY	(SCREEN_START_X + 16), (SCREEN_START_Y + 5)
		ldy	r_sprite_struct
		ldd	s_ks_sprite_zoom, y
		RSUB	print_hex_byte

		SEEK_XY	(SCREEN_START_X + 14), (SCREEN_START_Y + 6)
		ldy	r_sprite_struct
		ldd	s_ks_sprite_pos_x, y
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 14), (SCREEN_START_Y + 7)
		ldy	r_sprite_struct
		ldd	s_ks_sprite_pos_y, y
		RSUB	print_hex_word
		jmp	.loop_test

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "SPRITE VIEWER"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SPRITE WIDTH"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "SPRITE HEIGHT"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "SPRITE ZOOM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "JOY - ADJUST VALUE"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - NEXT ATTRIBUTE"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

	section bss

r_cursor:		dcb.b 1
r_draw_sprite_cb:	dcb.w 2
r_sprite_struct:	dcb.w 2
