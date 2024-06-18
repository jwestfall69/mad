	include "cpu/z80/include/psub.inc"

	global delay_psub

	section code


; params:
;  bc = loops
delay_psub:
		exx
	.loop:
		dec	bc		; 6 cycles
		ld	a, c		; 4 cycles
		or	b		; 4 cycles
		jr	nz, .loop	; 12 cycles
	PSUB_RETURN
