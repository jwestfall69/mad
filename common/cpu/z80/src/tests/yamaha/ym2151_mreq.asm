; Yamaha YM2151 FM
	include "cpu/z80/include/common.inc"
	include "global/include/yamaha/ym2151.inc"

	global ym2151_busy_bit_test
	global ym2151_timera_irq_test
	global ym2151_timerb_irq_test

	section code


; we haven't done anything with the ym2151, so the
; busy bit shouldn't be set
; params:
;  hl = ym2151 data register
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

; timera is a 10 bit timer
; params:
;   a = upper 8 bits of timer data (lower 2 will be 0)
;  hl = ym2151 data register
;  de = ym2151 address register
; returns:
;  a = (0 = pass, 1 = fail)
ym2151_timera_irq_test:
		; set upper 8 bits
		ld	b, YM2151_REG_CLKA1
		ld	c, a
		call	ym2151_write_register

		; set lower 2 bits
		ld	b, YM2151_REG_CLKA2
		ld	c, $0
		call	ym2151_write_register

		; enable irq, reset and load of timera
		ld	b, YM2151_REG_TIMER
		ld	c, $15
		call	ym2151_write_register

		xor	a
		ld	(r_irq_seen), a

		ei

		ld	bc, $ffff
		RSUB	delay

		di

		; disable timer
		ld	b, YM2151_REG_TIMER
		ld	c, $0
		call	ym2151_write_register

		ld	a, (r_irq_seen)
		cp	0
		jr	z, .test_failed

		xor	a
		ret

	.test_failed:
		xor	a
		inc 	a
		ret

; timerb is a 8 bit timer
; params:
;   a = timer data
;  hl = ym2151 data register
;  de = ym2151 address register
; returns:
;  a = (0 = pass, 1 = fail)
ym2151_timerb_irq_test:
		ld	b, YM2151_REG_CLKB
		ld	c, a
		call	ym2151_write_register

		; enable irq, reset and load of timera
		ld	b, YM2151_REG_TIMER
		ld	c, $2a
		call	ym2151_write_register

		xor	a
		ld	(r_irq_seen), a

		ei

		ld	bc, $ffff
		RSUB	delay

		di

		; disable timer
		ld	b, YM2151_REG_TIMER
		ld	c, $0
		call	ym2151_write_register

		ld	a, (r_irq_seen)
		cp	0
		jr	z, .test_failed

		xor	a
		ret

	.test_failed:
		xor	a
		inc 	a
		ret

; params:
;  hl = ym2151 data register
;  de = ym2151 address register
;   b = register
;   c = value
ym2151_write_register:
		call	ym2151_wait_busy
		ld	a, b
		ld	(de), a

		call	ym2151_wait_busy
		ld	(hl), c

		ret

; Waits until ym2151 is not busy. If it takes to long
; trigger a EC_YM2151_BUSY_TIMEOUT error address jump
; params:
;  hl = ym2151 data register
ym2151_wait_busy:
		push bc
		push af

		ld	bc, $1ff

		WATCHDOG

	.loop_try_again:
		ld	a, (hl)
		and	YM2151_BUSY_BIT
		jr	z, .not_busy

		dec	bc
		ld	a, b
		or	c
		jr	nz, .loop_try_again

		ld	a, EC_YM2151_BUSY_TIMEOUT
		jp	error_address

	.not_busy:
		pop	af
		pop	bc
		ret
