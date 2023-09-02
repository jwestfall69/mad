	include "cpu/68000/dsub.inc"

	global delay_dsub

	section code

; fix me to have proper timings
; params:
;  d0 = # of loops
delay_dsub:
		subq.l	#1, d0		;  4 cycles
		bne	delay_dsub	; 10 cycles
		DSUB_RETURN
