	include "cpu/68000/include/dsub.inc"

	include "input.inc"
	include "machine.inc"

	global input_update

	global r_input_edge
	global r_input_raw

	section code

; This is a generic input update that should work so long as
; the machine as all of the player 1's buttons in a single
; register.  Should that not be the case a machine specific
; version of this function should be made.
input_update:
		; small delay to help stop button press bounce
		move.l	#$1fff, d0
		RSUB	delay

		move.b	REG_INPUT, d0
		not.b	d0
		move.b	r_input_raw, d1
		eor.b	d0, d1
		and.b	d0, d1
		move.b	d1, r_input_edge
		move.b	d0, r_input_raw
		rts

	section bss
	align 1

r_input_edge:		dcb.b 1
r_input_raw:		dcb.b 1
