	include "cpu/68000/include/common.inc"
	include "global/include/sprite/konami/k051960.inc"

	global sprite_k051960_viewer_handler

	section code

; sprite attributes
SA_NUM			equ $0
SA_SIZE			equ $1
SA_ZOOM_X		equ $2
SA_ZOOM_Y		equ $3
SA_POS_X		equ $4
SA_POS_Y		equ $5
SA_MAX			equ SA_POS_Y

SA_SIZE_MASK		equ $7
SA_ZOOM_MASK		equ $3f
SA_POS_MASK		equ $1ff

; params:
; d0.w = sprite num mask
;  a0 = address of sprite struct
;  a1 = address of draw_sprite callback
sprite_k051960_viewer_handler:
		move.w	d0, r_sprite_num_mask
		move.l	a0, r_sprite_struct
		move.l	a1, r_draw_sprite_cb

		clr.b	r_cursor
		clr.b	r_cursor_old

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

	.loop_sprite_update:
		jsr	sprite_update

	.loop_cursor_update:
		jsr	cursor_update

	.loop_input:
		WATCHDOG
		jsr	input_update
		move.b	r_input_edge, d0

		btst	#INPUT_UP_BIT, d0
		beq	.up_not_pressed
		subq.b	#$1, r_cursor
		bpl	.loop_cursor_update
		move.b	#SA_MAX, r_cursor
		bra	.loop_cursor_update

	.up_not_pressed:
		btst	#INPUT_DOWN_BIT, d0
		beq	.down_not_pressed
		addq.b	#$1, r_cursor
		move.b	r_cursor, d1
		cmp.b	#SA_MAX, d1
		ble	.loop_cursor_update
		clr.b	r_cursor
		bra	.loop_cursor_update

	.down_not_pressed:
		btst	#INPUT_B2_BIT, d0
		beq	.b2_not_pressed
		rts

	.b2_not_pressed:
		; handle joystick input for the currently
		; selected sprite attribute
		move.l	r_sprite_struct, a0
		move.b	r_cursor, d0
		cmp.b	#SA_NUM, d0
		bne	.not_sa_num
		move.w	r_sprite_num_mask, d0
		lea	s_se_num(a0), a1
		lea	r_input_edge, a0
		bra	.joystick_lr_update_word

	.not_sa_num:
		cmp.b	#SA_SIZE, d0
		bne	.not_sa_size
		move.b	#SA_SIZE_MASK, d0
		lea	s_se_size(a0), a1
		lea	r_input_edge, a0
		bra	.joystick_lr_update_byte

	.not_sa_size:
		cmp.b	#SA_ZOOM_X, d0
		bne	.not_sa_zoom_x
		move.b	#SA_ZOOM_MASK, d0
		lea	s_se_zoom_x(a0), a1
		lea	r_input_edge, a0
		bra	.joystick_lr_update_byte

	.not_sa_zoom_x:
		cmp.b	#SA_ZOOM_Y, d0
		bne	.not_sa_zoom_y
		move.b	#SA_ZOOM_MASK, d0
		lea	s_se_zoom_y(a0), a1
		lea	r_input_edge, a0
		bra	.joystick_lr_update_byte

	.not_sa_zoom_y:
		cmp.b	#SA_POS_X, d0
		bne	.not_sa_pos_x
		move.w	#SA_POS_MASK, d0
		lea	s_se_pos_x(a0), a1
		lea	r_input_edge, a0
		bra	.joystick_lr_update_word

	.not_sa_pos_x:
		cmp.b	#SA_POS_Y, d0
		bne	.not_sa_pos_y
		move.w	#SA_POS_MASK, d0
		lea	s_se_pos_y(a0), a1
		lea	r_input_edge, a0
		bra	.joystick_lr_update_word

	.not_sa_pos_y:
		STALL	; should never get reached

	.joystick_lr_update_byte:
		jsr	joystick_lr_update_byte
		bra	.check_value_change

	.joystick_lr_update_word:
		jsr	joystick_lr_update_word

	.check_value_change:
		cmp.b	#$0, d0
		beq	.loop_input
		bra	.loop_sprite_update


CURSOR_START_X		equ (SCREEN_START_X - 1)
CURSOR_START_Y		equ (SCREEN_START_Y + 2)
cursor_update:
		move.b	#CURSOR_START_X, d0
		move.b	r_cursor_old, d1
		add.b	#CURSOR_START_Y, d1
		RSUB	screen_seek_xy
		move.b	#CURSOR_CLEAR_CHAR, d0
		RSUB	print_char

		move.b	#CURSOR_START_X, d0
		move.b	r_cursor, d1
		add.b	#CURSOR_START_Y, d1
		RSUB	screen_seek_xy
		move.b	#CURSOR_CHAR, d0
		RSUB	print_char

		move.b	r_cursor, r_cursor_old
		rts

sprite_update:
		move.l	r_draw_sprite_cb, a0
		jsr	(a0)

		move.l	r_sprite_struct, a0
		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 2)
		move.w	s_se_num(a0), d0
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		move.b	s_se_size(a0), d0
		RSUB	print_hex_nibble

		SEEK_XY	(SCREEN_START_X + 11), (SCREEN_START_Y + 4)
		move.b	s_se_zoom_x(a0), d0
		RSUB	print_hex_byte

		SEEK_XY	(SCREEN_START_X + 11), (SCREEN_START_Y + 5)
		move.b	s_se_zoom_y(a0), d0
		RSUB	print_hex_byte

		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 6)
		move.w	s_se_pos_x(a0), d0
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 7)
		move.w	s_se_pos_y(a0), d0
		RSUB	print_hex_word
		rts

	section data
	align 1

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SIZE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "ZOOM X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "ZOOM Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 2), "UD - SWITCH ATTRIBUTE"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "LR - ADJUST VALUE"
	ifd _SCREEN_TATE_
		XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - HOLD TO ADJUST 10X"
	else
		XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - HOLD TO ADJUST TIMES 10"
	endif
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

	section bss
	align 1

r_cursor:		dcb.b 1
r_cursor_old:		dcb.b 1
r_draw_sprite_cb:	dcb.l 2
r_sprite_num_mask:	dcb.w 2
r_sprite_struct:	dcb.l 2
