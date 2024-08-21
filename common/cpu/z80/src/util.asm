	include "cpu/z80/include/psub.inc"

	include "machine.inc"

	global delay_psub

	section code


; params:
;  bc = loops
delay_psub:
		exx
	.loop:
		WATCHDOG
		dec	bc		; 6 cycles
		ld	a, c		; 4 cycles
		or	b		; 4 cycles
		jr	nz, .loop	; 12 cycles
	PSUB_RETURN
