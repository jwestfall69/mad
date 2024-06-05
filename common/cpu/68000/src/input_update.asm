	include "cpu/68000/include/dsub.inc"

	include "input.inc"
	include "machine.inc"

	global input_update

	global INPUT_EDGE
	global INPUT_RAW

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
		move.b	INPUT_RAW, d1
		eor.b	d0, d1
		and.b	d0, d1
		move.b	d1, INPUT_EDGE
		move.b	d0, INPUT_RAW
		rts

	section bss

INPUT_EDGE:		dc.b $0
INPUT_RAW:		dc.b $0
