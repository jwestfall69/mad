	include "cpu/z80/include/dsub.inc"

	include "machine.inc"

	global crc32_dsub

	section code
; params:
;  bc  = start address
;  bc' = length
; returns:
;  bc = upper 16bits of crc32
;  de = lower 16bits of crc32
crc32_dsub:
		exx

		ld	a, c
		exx
		ld	l, a
		exx
		ld	a, b
		exx
		ld	h, a
		ld	d, b
		ld	e, c
		exx
		ld	de, $ffff
		ld	hl, $ffff

	.loop_outer:
		WATCHDOG
		ld	b, $08
		ld	a, e
		exx
		xor	(hl)
		inc	hl
		exx
		ld	e, a

	.loop_inner:
		WATCHDOG
		srl	h
		rr	l
		rr	d
		rr	e
		jr	nc, .loop_inner_inner
		ld 	a, e
		xor	$20
		ld	e, a
		ld	a, d
		xor	$83
		ld	d, a
		ld	a, l
		xor	$b8
		ld	l, a
		ld	a, h
		xor	$ed
		ld	h, a

	.loop_inner_inner:
		WATCHDOG
		djnz	.loop_inner
		exx
		dec	de
		ld	a, e
		or	d
		exx
		jr	nz, .loop_outer
		ld	a, e
		cpl
		ld	c, a
		ld	a, d
		cpl
		ld	b, a
		ld	a, l
		cpl
		ld	e, a
		ld	a, h
		cpl
		ld	d, a
		DSUB_RETURN

