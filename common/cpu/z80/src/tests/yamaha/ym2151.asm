; Yamaha YM2151 FM
	include "cpu/z80/include/psub.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/yamaha/ym2151.inc"

	include "machine.inc"
	include "error_codes.inc"

	global ym2151_busy_bit_test
	global ym2151_timera_irq_test

	section code


; we haven't done anything with the ym2151, so the
; busy bit shouldn't be set
; returns:
;  a = (0 = pass, 1 = fail)
ym2151_busy_bit_test:
		ld	hl, REG_YM2151_DATA
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
; returns:
;  a = (0 = pass, 1 = fail)
ym2151_timera_irq_test:
		xor	a
		ld	(IRQ_SEEN), a

		; set upper 8 bits
		ld	b, YM2151_REG_CLKA1
		ld	c, $1f
		call	ym2151_write_register

		; set lower 2 bits
		ld	b, YM2151_REG_CLKA2
		ld	c, $0
		call	ym2151_write_register

		; enable irq, reset and load of timera
		ld	b, YM2151_REG_TIMER
		ld	c, $15
		call	ym2151_write_register

		ei

		ld	bc, $ffff
		PSUB	delay

		di

		; disable timer
		ld	b, YM2151_REG_TIMER
		ld	c, $0
		call	ym2151_write_register

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
;  b = register
;  c = value
ym2151_write_register:
		call	ym2151_wait_busy
		ld	hl, REG_YM2151_ADDRESS
		ld	(hl), b

		call	ym2151_wait_busy
		ld	hl, REG_YM2151_DATA
		ld	(hl), c

		ret

; Waits until ym2151 is not busy. If it takes to long
; trigger a EC_YM2151_BUSY_TIMEOUT error address jump
ym2151_wait_busy:
		push bc
		push af

		ld	hl, REG_YM2151_DATA
		ld	bc, $1ff

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
