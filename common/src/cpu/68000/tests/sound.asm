	include "cpu/68000/dsub.inc"
	include "cpu/68000/menu_input.inc"
	include "machine.inc"

	global sound_test_handler

	section code

; params:
;  d0 = start value
;  a0 = address of sound register
;  a1 = menu get input function
sound_test_handler:
		move.b	d0, d4
		movea.l	a0, a3
		movea.l	a1, a4

	.update_byte:
		SEEK_XY	14, 10
		move.b	d4, d0
		RSUB	print_hex_byte

	.loop_input:
		jsr	(a4)

		btst	#MENU_DOWN_BIT, d0
		beq	.down_not_pressed
		sub.b	#1, d4
		bra	.update_byte

	.down_not_pressed:
		btst	#MENU_UP_BIT, d0
		beq	.up_not_pressed
		add.b	#1, d4
		bra	.update_byte

	.up_not_pressed:
		btst	#MENU_LEFT_BIT, d0
		beq	.left_not_pressed
		sub.b	#$10, d4
		bra	.update_byte

	.left_not_pressed:
		btst	#MENU_RIGHT_BIT, d0
		beq	.right_not_pressed
		add.b	#$10, d4
		bra	.update_byte

	.right_not_pressed:
		btst	#MENU_BUTTON_BIT, d0
		beq	.button_not_pressed
;		move.b	#$f0, (a3)
;		move.w	#$fff, d0
;		RSUB	delay
		move.b	d4, (a3)
		move.b	#0, (2,a3)
		move.b	#0, ($c,a3)
		move.b	#0, (8,a3)
		bra	.loop_input

	.button_not_pressed:
		btst	#MENU_EXIT_BIT, d0
		beq	.loop_input
		rts