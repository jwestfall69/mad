	include "cpu/6x09/include/common.inc"

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
		ldd	#$1ff
		jsr	delay

		ldb	r_input_raw
		lda	REG_INPUT
		coma
		sta	r_input_raw

		eorb	(r_input_raw)
		andb	(r_input_raw)
		stb	r_input_edge
		rts

	section bss

r_input_edge:	dcb.b 1
r_input_raw:	dcb.b 1
