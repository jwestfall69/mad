	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/menu_input.inc"

	include "machine.inc"

	global menu_input_generic

	section code

; This translates the inputs of the machine to the
; expected values used by menu systems
; returns:
;  d0 = 0 or MENU_* bits set depending on raw inputs
menu_input_generic:
		move.w	#$1fff, d0
		RSUB	delay

		jsr	input_p1_update

		moveq	#0, d0

		move.b	INPUT_P1_EDGE, d1

		btst	#P1_DOWN_BIT, d1
		beq	.down_not_pressed
		bset	#MENU_DOWN_BIT, d0

	.down_not_pressed:
		btst	#P1_UP_BIT, d1
		beq	.up_not_pressed
		bset	#MENU_UP_BIT, d0

	.up_not_pressed:
		btst	#P1_LEFT_BIT, d1
		beq	.left_not_pressed
		bset	#MENU_LEFT_BIT, d0

	.left_not_pressed:
		btst	#P1_RIGHT_BIT, d1
		beq	.right_not_pressed
		bset	#MENU_RIGHT_BIT, d0

	.right_not_pressed:
		btst	#P1_B1_BIT, d1
		beq	.b1_not_pressed
		bset	#MENU_BUTTON_BIT, d0

	.b1_not_pressed:
		btst	#P1_B2_BIT, d1
		beq	.b2_not_pressed
		bset	#MENU_EXIT_BIT, d0

	.b2_not_pressed:
		rts
