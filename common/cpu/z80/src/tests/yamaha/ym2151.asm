; Yamaha YM2151 FM
	include "cpu/z80/include/psub.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/yamaha/ym2151.inc"

	global ym2151_busy_bit_test

	section code


; we haven't done anything with the ym2151, so the
; busy bit shouldn't be set
; params:
;  hl = ym2151 data register address
; returns:
;  a = (0 = pass, 1 = fail)
ym2151_busy_bit_test:
		ld	a, (hl)

		and	YM2151_BUSY_BIT
		jr	nz, .test_failed
		xor	a
		ret

	.test_failed:
		xor	a
		inc	a
		ret
