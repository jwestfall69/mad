	include "cpu/6x09/include/macros.inc"

	include "cpu/6309/include/dsub.inc"

	include "machine.inc"

	global crc32

	section code

CRC32_POLY		equ $edb88320
CRC32_POLY_MSW		equ ((CRC32_POLY >> 16 ) & $ffff)
CRC32_POLY_LSW		equ (CRC32_POLY & $ffff)

; crc32 uses all registers except for v.  Because
; of this it requires making a hard jmp in/out of
; the function.  jsr is not possible since work
; ram could be bad.
; params:
;  d = length
;  x = start address
; returns:
;  q = crc32 value
crc32:
		tfr	d, y
		tfr	x, u
		ldq	#$ffffffff

	.loop_next_byte:
		WATCHDOG
		eorb	, u+
		ldx	#$8

	.loop_next_bit:
		lsrw
		rord
		bcc	.is_carry

		eord	#CRC32_POLY_LSW
		; no eorw opcode
		exg	w, d
		eord	#CRC32_POLY_MSW
		exg	d, w

	.is_carry:
		leax	-1, x
		bne	.loop_next_bit

		leay	-1, y
		bne	.loop_next_byte

		comd
		comw
		exg	d, w
		jmp	crc32_return
