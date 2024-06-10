	include "cpu/z80/include/psub.inc"
	include "cpu/z80/include/macros.inc"

	include "machine.inc"

	global memory_address_test_psub
	global memory_data_test_psub
	global memory_march_test_psub
	global memory_output_test_psub
	global memory_write_test_psub

	section code

memory_address_test_psub:
		xor a
		PSUB_RETURN

memory_data_test_psub:
		xor a
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
;  bc = memory location to test
; returns:
;  Z = 0 (error), 1 = (pass)
;  a = 0 (pass), 1 = (fail)
memory_output_test_psub:
		ld	d,b
		ld	h,b
		ld	e,c
		ld	l,c

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
;  bc = memory location to tess
; returns:
;  Z = 0 (error), 1 = (pass)
;  a = 0 (pass), 1 = (fail)
memory_write_test_psub:
		; read/save a byte from ram, write !byte back to the location,
		; re-read the location and error if it still the original byte
		ld	a, (bc)
		ld	b, a
		xor	$ff
		ld	(bc), a
		ld	a, (bc)
		cp	b
		jr	z, .test_failed

		xor	a
		PSUB_RETURN

	.test_failed:
		xor	a
		inc	a
		PSUB_RETURN

	section data

DATA_PATTERNS:
	byte	$00, $55, $aa, $ff
DATA_PATTERNS_END:
