; Yamaha ym2203 FM
	include "cpu/z80/include/psub.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/yamaha/ym2203.inc"

	include "machine.inc"
	include "error_codes.inc"

	global ym2203_busy_bit_test
	global ym2203_timera_irq_test
	global ym2203_timerb_irq_test

	section code


; we haven't done anything with the ym2203, so the
; busy bit shouldn't be set
; params:
;  h = ym2203 data io
; returns:
;  a = (0 = pass, 1 = fail)
ym2203_busy_bit_test:
		ld	c, h
		in	a, (c)

		and	YM2203_BUSY_BIT
		jr	nz, .test_failed
		xor	a
		ret

	.test_failed:
		xor	a
		inc	a
		ret

; timera is a 10 bit timer
; params:
;  a = upper 8 bits of timer data (lower 2 will be 0)
;  h = ym2203 data io
;  l = ym2203 address io
; returns:
;  a = (0 = pass, 1 = fail)
ym2203_timera_irq_test:
		; set upper 8 bits
		ld	b, YM2203_REG_CLKA1
		ld	c, a
		call	ym2203_write_register

		; set lower 2 bits
		ld	b, YM2203_REG_CLKA2
		ld	c, $0
		call	ym2203_write_register

		; enable irq, reset and load of timera
		ld	b, YM2203_REG_TIMER
		ld	c, $15
		call	ym2203_write_register

		xor	a
		ld	(IRQ_SEEN), a

		ei

		ld	bc, $ffff
		PSUB	delay

		di

		; disable timer
		ld	b, YM2203_REG_TIMER
		ld	c, $0
		call	ym2203_write_register

		ld	a, (IRQ_SEEN)
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
;  h = ym2203 data io
;  l = ym2203 address io
; returns:
;  a = (0 = pass, 1 = fail)
ym2203_timerb_irq_test:
		ld	b, YM2203_REG_CLKB
		ld	c, a
		call	ym2203_write_register

		; enable irq, reset and load of timera
		ld	b, YM2203_REG_TIMER
		ld	c, $2a
		call	ym2203_write_register

		xor	a
		ld	(IRQ_SEEN), a

		ei

		ld	bc, $ffff
		PSUB	delay

		di

		; disable timer
		ld	b, YM2203_REG_TIMER
		ld	c, $0
		call	ym2203_write_register

		ld	a, (IRQ_SEEN)
		cp	0
		jr	z, .test_failed

		xor	a
		ret

	.test_failed:
		xor	a
		inc 	a
		ret

; params:
;  h = ym2203 data io
;  l = ym2203 address io
;   b = register
;   c = value
ym2203_write_register:
		call	ym2203_wait_busy
		ld	a, b
		ld	b, c
		ld	c, l
		out	(c), a

		call	ym2203_wait_busy
		ld	a, b
		ld	c, h
		out	(c), a

		ret

; Waits until ym2203 is not busy. If it takes to long
; trigger a EC_ym2203_BUSY_TIMEOUT error address jump
; params:
;  h = ym2203 data register
ym2203_wait_busy:
	ifd _YM2203_NO_READ_
		nop
		nop
		nop
		ret
	else
		push bc
		push af

		ld	bc, $1ff

		WATCHDOG

	.loop_try_again:
		push	bc
		ld	c, h
		in	a, (c)
		pop	bc
		and	YM2203_BUSY_BIT
		jr	z, .not_busy

		dec	bc
		ld	a, b
		or	c
		jr	nz, .loop_try_again

		ld	a, EC_YM2203_BUSY_TIMEOUT
		jp	error_address

	.not_busy:
		pop	af
		pop	bc
		ret
	endif