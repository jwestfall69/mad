	include "cpu/z80/include/dsub.inc"
	include "cpu/z80/include/macros.inc"

	include "machine.inc"

	global memory_address_test_dsub
	global memory_data_pattern_test_dsub
	global memory_march_test_dsub
	global memory_output_test_dsub
	global memory_write_test_dsub

	section code

; Write an incrementing data value at incrementing addresses
; params:
;  hl = start address
;  b = number of address lines
; returns:
;  a = 0 (pass), 1 (fail)
;  Z = 1 (pass), 0 (fail)
;  hl = error address
;  b = expected
;  c = actual
memory_address_test_dsub:
		exx

		; backup hl and b to hl' and b'
		ld	a, h
		exx
		ld	h, a
		exx
		ld	a, l
		exx
		ld	l, a
		exx

		ld	a, b
		exx
		ld	b, a
		exx

		ld	a, $1
		ld	de, $1

		ld	(hl), a
		inc	a

	.loop_next_write_address:
		add	hl, de
		ld	(hl), a
		sbc	hl, de

		inc	a
		rl	e
		rl	d
		djnz	.loop_next_write_address

		WATCHDOG

		; switch to our backup copy of hl and b
		; then re-read the data to verify its correct
		exx

		ld	a, $1
		ld	de, $1

		ld	c, (hl)
		cp	c
		jr	nz, .test_failed
		inc	a

	.loop_next_read_address:
		add	hl, de
		ld	c, (hl)
		cp	c
		jr	nz, .test_failed
		sbc	hl, de

		inc	a
		rl	e
		rl	d
		djnz	.loop_next_read_address

		WATCHDOG

		xor a
		DSUB_RETURN

	.test_failed:

		WATCHDOG
		ld	b, a
		xor	a
		inc	a
		DSUB_RETURN

; params:
;  hl = start address
;  de = size
;  b = pattern
; returns:
;  Z = 0 (error), 1 = (pass)
;  a = 0 (pass), 1 = (fail)
;  hl = error address
;  b = expected
;  c = actual
memory_data_pattern_test_dsub:
		exx

	.loop_next_address:
		ld	a, b
		ld	(hl), a
		ld	c, (hl)
		cp	c
		jr	nz, .test_failed_abort
		inc	hl
		dec	de
		ld	a, d
		or	e
		jr	nz, .loop_next_address

		WATCHDOG

		xor	a
		DSUB_RETURN

	.test_failed_abort:

		WATCHDOG

		xor	a
		inc	a
		DSUB_RETURN


; params:
;  hl = start address
;  de = size
; returns
;  Z = 0 (error), 1 = (pass)
;  a = 0 (pass), 1 = (fail)
;  hl = error address
;  b = expected
;  c = actual
memory_march_test_dsub:
		exx

		; backup de to de'
		ld	a, d
		exx
		ld	d, a
		exx
		ld	a, e
		exx
		ld	e, a
		exx

		; fill the region with $0
		ld	b, $0
	.loop_fill_zero:
		ld	(hl), b
		inc	hl
		dec	de
		ld	a, d
		or	e
		jr	nz, .loop_fill_zero

		WATCHDOG

		; restore de from backup
		exx
		ld	a, d
		exx
		ld	d, a
		exx
		ld	a, e
		exx
		ld	e, a

		; s, verify $0, write $ff
		sbc	hl, de

	.loop_up_test:

		xor	a
		ld	c, (hl)
		cp	c
		jr	nz, .test_failed
		ld	(hl), $ff
		inc	hl
		dec	de
		ld	a, d
		or	e
		jr	nz, .loop_up_test

		WATCHDOG

		; march down, verify $ff, write $0
		exx
		ld	a, d
		exx
		ld	d, a
		exx
		ld	a, e
		exx
		ld	e, a
		dec	hl
		ld	b, $ff
	.loop_down_test:
		ld	a, b
		ld	c, (hl)
		cp	c
		jr	nz, .test_failed
		ld	(hl), $0
		dec	hl
		dec	de
		ld	a, d
		or	e
		jr	nz, .loop_down_test

		xor	a
		DSUB_RETURN

	.test_failed:
		xor	a
		inc	a
		DSUB_RETURN

; When a memory address doesn't output anything on a read request it will
; usually result in the target register being filled with the opcode for
; the ld.  Its not 100% and will sometimes results in the register filled
; with $ff or other garbage.  So we we loop $64 times trying to catch
; 2 different opcodes being placed into 'a' in a row.
; params:
;  hl = memory location to test
; returns:
;  Z = 0 (error), 1 = (pass)
;  a = 0 (pass), 1 = (fail)
memory_output_test_dsub:
		exx

		WATCHDOG

		ld	d, h
		ld	e, l

		ld	b, $64
	.loop_next:
		ld	a, (hl)
		cp	$7e		; ld a, (hl) opcode
		jr	nz, .loop_pass

		ld	a, (de)
		cp	$1a		; ld a, (de) opcode
		jr	z, .test_failed

	.loop_pass:
		djnz	.loop_next

		xor	a
		DSUB_RETURN

	.test_failed:
		xor	a
		inc	a
		DSUB_RETURN

; params:
;  hl = memory location to test
; returns:
;  Z = 0 (error), 1 = (pass)
;  a = 0 (pass), 1 = (fail)
memory_write_test_dsub:
		exx

		WATCHDOG

		; read/save a byte from ram, write !byte back to the location,
		; re-read the location and error if it still the original byte
		ld	a, (hl)
		ld	b, a
		xor	$ff
		ld	(hl), a
		ld	a, (hl)
		cp	b
		jr	z, .test_failed

		xor	a
		DSUB_RETURN

	.test_failed:
		xor	a
		inc	a
		DSUB_RETURN
