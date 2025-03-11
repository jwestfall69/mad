	include "cpu/6809/include/error_codes.inc"
	include "cpu/6809/include/macros.inc"
	include "cpu/6809/include/psub.inc"

	include "machine.inc"
	include "mad.inc"

	global mad_rom_address_test_psub
	global mad_rom_crc16_test_psub

	section code

; The running copy of mad is at the end of
; address space.  Its mirror 0, then we have
; to work our ways backwards for the additional
; mirrors.
mad_rom_address_test_psub:
		ldy	#MAD_ROM_MIRROR_ADDRESS
		lda	#(ROM_SIZE / MAD_ROM_SIZE)
		clrb		; expected mirror #

	.loop_next_mirror:
		cmpb	, y
		bne	.test_failed

		leay	-MAD_ROM_SIZE, y

		incb
		deca
		bne	.loop_next_mirror
		PSUB_RETURN

	.test_failed:
		lda	#EC_MAD_ROM_ADDRESS
		jmp	error_address

mad_rom_crc16_test_psub:
		ldy	#MAD_ROM_START

		; vasm doesnt seem to like doing
		; ldx	#(MAD_ROM_MIRROR_ADDRESS - MAD_ROM_START)
		ldd	#MAD_ROM_MIRROR_ADDRESS
		subd	#MAD_ROM_START
		tfr	d, x
		ldd	#$0

	.loop_next_byte:
		WATCHDOG
		eora 	, y+

	; unroll looping over the 8 bits so we can
	; avoid having to use the u register
	rept 8
	inline
		aslb
		rola
		bcc	.skip_poly
		eora	#$10
		eorb	#$21
	.skip_poly:
	einline
	endr

		leax	-1, x
		bne	.loop_next_byte

		; d should contain the crc16 value
		ldy	#MAD_ROM_CRC16_ADDRESS
		cmpa	, y+
		bne	.test_failed
		cmpb	, y
		bne	.test_failed
		PSUB_RETURN

	.test_failed:
		lda	#EC_MAD_ROM_CRC16
		jmp	error_address
