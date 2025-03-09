	include "cpu/z80/include/dsub.inc"

	include "machine.inc"

	global delay_dsub

	section code


; params:
;  bc = loops
delay_dsub:
		exx
	.loop:
		WATCHDOG
		dec	bc		; 6 cycles
		ld	a, c		; 4 cycles
		or	b		; 4 cycles
		jr	nz, .loop	; 12 cycles
	DSUB_RETURN
