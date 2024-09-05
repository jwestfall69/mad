	include "cpu/6309/include/psub.inc"

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
		pshsw
		ldw	#$1ff
		PSUB	delay
		pulsw

		lda	REG_INPUT
		coma
		ldb	INPUT_RAW

		eorr	a, b
		andr	a, b
		stb	INPUT_EDGE
		sta	INPUT_RAW
		rts

	section bss

INPUT_EDGE:	blk 1
INPUT_RAW:	blk 1
