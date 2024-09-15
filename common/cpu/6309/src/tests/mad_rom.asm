	include "cpu/6309/include/error_codes.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global auto_mad_rom_address_test_psub
	global auto_mad_rom_crc32_test_psub
	global crc32_return

	section code

; The running copy of mad is at the end of
; address space.  Its mirror 0, then we have
; to work our ways backwards for the additional
; mirrors.
auto_mad_rom_address_test_psub:

		SEEK_LN	4
		PSUB	print_clear_line

		SEEK_XY	3, 4
		ldy	#d_str_testing_mad_rom_address
		PSUB	print_string

		ldy	#MAD_ROM_MIRROR_ADDRESS
		lda	#(ROM_SIZE / MAD_ROM_SIZE)
		clrb		; expected mirror #

	.loop_next_mirror:
		ldf	, y
		cmpr	b, f
		bne	.test_failed

		leay	-MAD_ROM_SIZE, y

		incb
		deca
		bne	.loop_next_mirror
		PSUB_RETURN

	.test_failed:

		; expected
		SEEK_XY	14, 10
		tfr	b, a
		PSUB	print_hex_byte

		; actual
		SEEK_XY	14, 8
		tfr	f, a
		PSUB	print_hex_byte

		SEEK_LN	4
		PSUB	print_clear_line

		SEEK_XY	4, 4
		ldy	#d_str_mad_rom_address
		PSUB	print_string

		SEEK_XY	4, 8
		ldy	#d_str_actual
		PSUB	print_string

		SEEK_XY	4, 10
		ldy	#d_str_expected
		PSUB	print_string

		lda	#EC_MAD_ROM_ADDRESS
		PSUB	sound_play_byte

		lda	#EC_MAD_ROM_ADDRESS
		; jmp	error_address
		STALL



auto_mad_rom_crc32_test_psub:

		SEEK_LN	4
		PSUB	print_clear_line

		SEEK_XY	3, 4
		ldy	#d_str_testing_mad_rom_crc32
		PSUB	print_string

		; vasm doesnt seem to like doing
		; ldd	#(MAD_ROM_MIRROR_ADDRESS - MAD_ROM_START)
		ldd	#MAD_ROM_MIRROR_ADDRESS
		subd	#MAD_ROM_START
		ldx	#MAD_ROM_START

		; crc32 uses all registers except for v, making it
		; impossible for us to do a nested psub to it. We can
		; however backup our psub return address.
		tfr	u, v
		jmp	crc32
crc32_return:
		tfr	v, u

		cmpd	MAD_ROM_CRC32_ADDRESS
		bne	.test_failed

		cmpw	MAD_ROM_CRC32_ADDRESS+2
		bne	.test_failed

		PSUB_RETURN

	.test_failed:
		tfr	w, y

		SEEK_XY	14, 10
		PSUB	print_hex_word

		SEEK_XY	18, 10
		tfr	y, d
		PSUB	print_hex_word

		SEEK_XY	14, 8
		ldd	MAD_ROM_CRC32_ADDRESS
		PSUB	print_hex_word

		SEEK_XY	18, 8
		ldd	MAD_ROM_CRC32_ADDRESS+2
		PSUB	print_hex_word

		SEEK_LN	4
		PSUB	print_clear_line

		SEEK_XY	4, 4
		ldy	#d_str_mad_rom_crc32
		PSUB	print_string

		SEEK_XY 4, 10
		ldy	#d_str_actual
		PSUB	print_string

		SEEK_XY 4, 8
		ldy	#d_str_expected
		PSUB	print_string

		lda	#EC_MAD_ROM_CRC32
		PSUB	sound_play_byte

		lda	#EC_MAD_ROM_CRC32
		;jmp	error_address
		STALL

	section data

d_str_mad_rom_crc32:		STRING "MAD ROM CRC32 ERROR"
d_str_mad_rom_address:		STRING "MAD ROM ADDRESS ERROR"

d_str_testing_mad_rom_address:	STRING "TESTING MAD ROM ADDRESS"
d_str_testing_mad_rom_crc32:	STRING "TESTING MAD ROM CRC32"

