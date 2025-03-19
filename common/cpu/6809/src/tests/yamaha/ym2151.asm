; Yamaha YM2151 FM
	include "global/include/yamaha/ym2151.inc"
	include "cpu/6809/include/macros.inc"
	include "cpu/6809/include/psub.inc"

	include "machine.inc"
	include "error_codes.inc"

	global ym2151_busy_bit_test

	section code

; we haven't done anything with the ym2151, so the
; busy bit shouldn't be set
; params:
;  x = ym2151 data register
; returns:
;  a = (0 = pass, 1 = fail)
ym2151_busy_bit_test:
		lda	, x
		anda	#YM2151_BUSY_BIT
		bne	.test_failed

		clra
		rts

	.test_failed:
		lda	#$1
		rts
