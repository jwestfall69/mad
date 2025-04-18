	include "global/include/screen.inc"
	include "global/include/macros.inc"
	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/error_codes.inc"
	include "cpu/konami2/include/macros.inc"

	include "machine.inc"
	include "mad.inc"

	global mad_rom_address_test_dsub
	global mad_rom_crc16_test_dsub

	section code

; The running copy of mad is at the end of
; address space.  Its mirror 0, then we have
; to work our ways backwards for the additional
; mirrors.
mad_rom_address_test_dsub:
		WATCHDOG

		SEEK_LN	SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_testing_mad_rom_address
		PSUB	print_string

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
		DSUB_RETURN

	.test_failed:
		lda	, y

		; actual
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		PSUB	print_hex_byte

		; expected
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 2)
		tfr	b, a
		PSUB	print_hex_byte

		SEEK_LN	SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_mad_rom_address
		PSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		ldy	#d_str_expected
		PSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 3)
		ldy	#d_str_actual
		PSUB	print_string

		lda	#EC_MAD_ROM_ADDRESS
		jmp	error_address


mad_rom_crc16_test_dsub:

		SEEK_LN	SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_testing_mad_rom_crc16
		PSUB	print_string

		ldy	#MAD_ROM_START

		; vasm doesnt seem to like doing
		; ldx	#(MAD_ROM_MIRROR_ADDRESS - MAD_ROM_START)
		ldx	#MAD_ROM_MIRROR_ADDRESS
		; and no tfr d
		leax	-MAD_ROM_START/2, x
		leax	-MAD_ROM_START/2, x
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
		DSUB_RETURN

	.test_failed:
		; actual
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		PSUB	print_hex_word

		; expected
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 2)
		ldd	MAD_ROM_CRC16_ADDRESS
		PSUB	print_hex_word

		SEEK_LN	SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_mad_rom_crc16
		PSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		ldy	#d_str_expected
		PSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 3)
		ldy	#d_str_actual
		PSUB	print_string

		jmp	error_address

	section data

d_str_mad_rom_crc16:		STRING "MAD ROM CRC16 ERROR"
d_str_mad_rom_address:		STRING "MAD ROM ADDRESS ERROR"

d_str_testing_mad_rom_address:	STRING "TESTING MAD ROM ADDRESS"
d_str_testing_mad_rom_crc16:	STRING "TESTING MAD ROM CRC16"

