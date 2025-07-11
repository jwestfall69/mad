	include "cpu/6x09/include/common.inc"
	include "global/include/sprite/konami/k007420.inc"

	global sprite_k007420_viewer_handler

	section code

; sprite attributes
SA_NUM			equ $0
SA_SIZE			equ $1
SA_ZOOM			equ $2
SA_POS_X		equ $3
SA_POS_Y		equ $4
SA_MAX			equ SA_POS_Y

SA_SIZE_MASK		equ $7
SA_ZOOM_MASK		equ $3ff
SA_POS_X_MASK		equ $1ff
SA_POS_Y_MASK		equ $ff

; params:
;  d = sprite num mask
;  x = address of sprite struct
;  y = address of draw_sprite callback
sprite_k007420_viewer_handler:
		std	r_sprite_num_mask
		stx	r_sprite_struct
		sty	r_draw_sprite_cb

		clr	r_cursor
		clr	r_cursor_old

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list
		jsr	print_b2_return_to_menu

	.loop_sprite_update:
		jsr	sprite_update

	.loop_cursor_update:
		jsr	cursor_update

	.loop_input:
		WATCHDOG
		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_UP
		beq	.up_not_pressed
		dec	r_cursor
		bpl	.loop_cursor_update
		lda	#SA_MAX
		sta	r_cursor
		bra	.loop_cursor_update

	.up_not_pressed:
		bita	#INPUT_DOWN
		beq	.down_not_pressed
		inc	r_cursor
		lda	r_cursor
		cmpa	#SA_MAX
		ble	.loop_cursor_update
		clr	r_cursor
		bra	.loop_cursor_update

	.down_not_pressed:
		bita	#INPUT_B2
		beq	.b2_not_pressed
		rts

	.b2_not_pressed:
		; handle joystick input for the currently
		; selected attribute/cursor
		ldy	r_sprite_struct
		lda	r_cursor
		cmpa	#SA_NUM
		bne	.not_sa_sprite_num
		ldd	r_sprite_num_mask
		ldx	#r_input_edge
		leay	s_se_num, y
		bra	.joystick_lr_update_word

	.not_sa_sprite_num:
		cmpa	#SA_SIZE
		bne	.not_sa_sprite_size
		lda	#SA_SIZE_MASK
		ldx	#r_input_edge
		leay	s_se_size, y
		bra	.joystick_lr_update_byte

	.not_sa_sprite_size:
		cmpa	#SA_ZOOM
		bne	.not_sa_sprite_zoom
		ldd	#SA_ZOOM_MASK
		ldx	#r_input_edge
		leay	s_se_zoom, y
		bra	.joystick_lr_update_word

	.not_sa_sprite_zoom:
		cmpa	#SA_POS_X
		bne	.not_sa_pos_x
		ldd	#SA_POS_X_MASK
		ldx	#r_input_raw
		leay	s_se_pos_x, y
		bra	.joystick_lr_update_word

	.not_sa_pos_x:
		cmpa	#SA_POS_Y
		bne	.not_sa_pos_y
		lda	#SA_POS_Y_MASK
		ldx	#r_input_raw
		leay	s_se_pos_y, y
		bra	.joystick_lr_update_byte

	.not_sa_pos_y:
		STALL	; should never get reached

	.joystick_lr_update_byte:
		jsr	joystick_lr_update_byte
		bra	.check_value_change

	.joystick_lr_update_word:
		jsr	joystick_lr_update_word

	; joystick_lr_* will return a = 1 if the
	; value was changed.  Only redraw the sprite
	; if it does
	.check_value_change:
		cmpa	#$0
		lbeq	.loop_input
		jmp	.loop_sprite_update

CURSOR_START_X		equ (SCREEN_START_X - 1)
CURSOR_START_Y		equ (SCREEN_START_Y + 2)
cursor_update:
		lda	#CURSOR_START_X
		ldb	r_cursor_old
		addb	#CURSOR_START_Y
		RSUB	screen_seek_xy
		lda	#CURSOR_CLEAR_CHAR
		RSUB	print_char

		lda	#CURSOR_START_X
		ldb	r_cursor
		stb	r_cursor_old
		addb	#CURSOR_START_Y
		RSUB	screen_seek_xy
		lda	#CURSOR_CHAR
		RSUB	print_char
		rts

sprite_update:
		jsr	[r_draw_sprite_cb]

		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 2)
		ldy	r_sprite_struct
		ldd	s_se_num, y
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		ldy	r_sprite_struct
		ldd	s_se_size, y
		RSUB	print_hex_nibble

		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 4)
		ldy	r_sprite_struct
		ldd	s_se_zoom, y
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 5)
		ldy	r_sprite_struct
		ldd	s_se_pos_x, y
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 11), (SCREEN_START_Y + 6)
		ldy	r_sprite_struct
		ldd	s_se_pos_y, y
		RSUB	print_hex_byte
		rts

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SIZE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "ZOOM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 2), "UD - SWITCH ATTRIBUTE"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "LR - ADJUST VALUE"
	ifd _SCREEN_TATE_
		XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - HOLD TO ADJUST 10X"
	else
		XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - HOLD TO ADJUST TIMES 10"
	endif
	XY_STRING_LIST_END

	section bss

r_cursor:		dcb.b 1
r_cursor_old:		dcb.b 1
r_draw_sprite_cb:	dcb.w 2
r_sprite_num_mask:	dcb.w 2
r_sprite_struct:	dcb.w 2
