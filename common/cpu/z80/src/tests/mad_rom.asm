	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/z80/include/error_codes.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/dsub.inc"

	include "machine.inc"
	include "mad.inc"

	global mad_rom_crc32_test_dsub
	global mad_rom_address_test_dsub

	section code

mad_rom_crc32_test_dsub:

	ifnd _HEADLESS_
		SEEK_LN	SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_testing_mad_rom_crc32
		PSUB	print_string
	endif

		ld	bc, ROM_START
		exx
		ld	bc, MAD_ROM_SIZE - 5
		exx
		PSUB	crc32

		ld	hl, (MAD_ROM_CRC32_ADDRESS)
		sbc	hl, bc
		jr	nz, .test_failed

		ld	hl, (MAD_ROM_CRC32_ADDRESS + 2)
		sbc	hl, de
		jr	nz, .test_failed

		xor	a
		DSUB_RETURN

	.test_failed:

	ifnd _HEADLESS_

		; backup de to bc'
		ld	a, d
		exx
		ld	b, a
		exx
		ld	a, e
		exx
		ld	c, a

		; actual
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		PSUB	print_hex_word

		; restore and already in bc
		SEEK_XY	(SCREEN_START_X + 16), (SCREEN_START_Y + 3)
		exx
		PSUB	print_hex_word

		; expected
		SEEK_XY	(SCREEN_START_X + 16), (SCREEN_START_Y + 2)
		ld	bc, (MAD_ROM_CRC32_ADDRESS)
		PSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 2)
		ld	bc, (MAD_ROM_CRC32_ADDRESS + 2)
		PSUB	print_hex_word

		SEEK_LN	SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_mad_rom_crc32
		PSUB	print_string

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 2)
		ld	de, d_str_expected
		PSUB	print_string

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 3)
		ld	de, d_str_actual
		PSUB	print_string

	;	ld	b, EC_MAD_ROM_CRC32
	;	PSUB	sound_play_byte

	endif
		ld	a, EC_MAD_ROM_CRC32
		jp	error_address


mad_rom_address_test_dsub:

	ifnd _HEADLESS_
		SEEK_LN	SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_testing_mad_rom_address
		PSUB	print_string
	endif

		ld	hl, MAD_ROM_MIRROR_ADDRESS
		ld	de, MAD_ROM_SIZE
		ld	b, ROM_SIZE / MAD_ROM_SIZE
		xor	a

	.loop_next_mirror:
		ld	c, (hl)
		cp	c
		jr	nz, .test_failed
		inc	a
		add	hl, de
		djnz	.loop_next_mirror

		xor	a
		DSUB_RETURN

	.test_failed:

	ifnd _HEADLESS_
		ld	b, a

		; actual
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		PSUB	print_hex_byte

		ld	c, b
		; expected
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 2)
		PSUB	print_hex_byte

		SEEK_LN	SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_mad_rom_address
		PSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		ld	de, d_str_expected
		PSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 3)
		ld	de, d_str_actual
		PSUB	print_string

	;	ld	b, #EC_MAD_ROM_ADDRESS
	;	PSUB	sound_play_byte
	endif

		ld	a, EC_MAD_ROM_ADDRESS
		jp	error_address

	ifnd _HEADLESS_

	section data

d_str_mad_rom_crc32:		STRING "MAD ROM CRC32 ERROR"
d_str_mad_rom_address:		STRING "MAD ROM ADDRESS ERROR"

d_str_testing_mad_rom_address:	STRING "TESTING MAD ROM ADDRESS"
d_str_testing_mad_rom_crc32:	STRING "TESTING MAD ROM CRC32"

	endif
