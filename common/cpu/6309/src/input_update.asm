	include "cpu/6309/include/psub.inc"

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
		pshsw
		ldw	#$1ff
		PSUB	delay
		pulsw

		lda	REG_INPUT
		coma
		ldb	r_input_raw

		eorr	a, b
		andr	a, b
		stb	r_input_edge
		sta	r_input_raw
		rts

	section bss

r_input_edge:	dcb.b 1
r_input_raw:	dcb.b 1
