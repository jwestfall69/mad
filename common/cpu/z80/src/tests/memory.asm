	include "cpu/z80/include/psub.inc"
	include "cpu/z80/include/macros.inc"

	include "machine.inc"

	global memory_address_test_psub
	global memory_data_pattern_test_psub
	global memory_march_test_psub
	global memory_output_test_psub
	global memory_write_test_psub

	section code

; Write an incrementing data value at incrementing addresses
; params:
;  hl = start address
;  b = number of address lines
; returns:
;  a = 0 (pass), 1 (fail)
;  Z = 1 (pass), 0 (fail)
memory_address_test_psub:
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

		; switch to our backup copy of hl and b
		; then re-read the data to verify its correct
		exx

		ld	a, $1
		ld	de, $1

		cp	(hl)
		jr	nz, .test_failed
		inc	a

	.loop_next_read_address:
		add	hl, de
		cp	(hl)
		jr	nz, .test_failed
		sbc	hl, de

		inc	a
		rl	e
		rl	d
		djnz	.loop_next_read_address

		xor a
		PSUB_RETURN

	.test_failed:
		xor	a
		inc	a
		PSUB_RETURN

; params:
;  hl = start address
;  de = size
;  c = pattern
; returns:
;  Z = 0 (error), 1 = (pass)
;  a = 0 (pass), 1 = (fail)
memory_data_pattern_test_psub:
		exx

	.loop_next_address:
		ld	a, c
		ld	(hl), a
		cp	(hl)
		jr	nz, .test_failed_abort
		inc	hl
		dec	de
		ld	a, d
		or	e
		jr	nz, .loop_next_address

		xor	a
		PSUB_RETURN

	.test_failed_abort:
		xor	a
		inc	a
		PSUB_RETURN


memory_march_test_psub:
		xor a
		PSUB_RETURN

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
memory_output_test_psub:
		exx

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
		PSUB_RETURN

	.test_failed:
		xor	a
		inc	a
		PSUB_RETURN

; params:
;  hl = memory location to test
; returns:
;  Z = 0 (error), 1 = (pass)
;  a = 0 (pass), 1 = (fail)
memory_write_test_psub:
		exx

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
		PSUB_RETURN

	.test_failed:
		xor	a
		inc	a
		PSUB_RETURN
