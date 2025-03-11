	include "cpu/z80/include/dsub.inc"

	include "machine.inc"

	global memory_fill_dsub
	global memory_fill_word_dsub

	section code

; params:
; hl = start address
; de = size
; c = patterm
memory_fill_dsub:
		exx

	.loop_next_address:
		WATCHDOG
		ld	(hl), c
		inc	hl
		dec	de
		ld	a, d
		or	e
		jr	nz, .loop_next_address
		DSUB_RETURN

; params:
; hl = start address
; de = size
; bc = patterm
memory_fill_word_dsub:
		exx

	.loop_next_address:
		WATCHDOG
		ld	(hl), b
		inc	hl
		ld	(hl), c
		inc	hl
		dec	de
		dec	de
		ld	a, d
		or	e
		jr	nz, .loop_next_address
		DSUB_RETURN
