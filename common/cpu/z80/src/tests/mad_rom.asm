	include "cpu/z80/include/error_codes.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/dsub.inc"

	include "machine.inc"
	include "mad.inc"

	global mad_rom_crc32_test_dsub
	global mad_rom_address_test_dsub

	section code

mad_rom_crc32_test_dsub:
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
		ld	a, EC_MAD_ROM_CRC32
		or	a
		DSUB_RETURN


mad_rom_address_test_dsub:
		ld	hl, MAD_ROM_MIRROR_ADDRESS
		ld	de, MAD_ROM_SIZE
		ld	b, ROM_SIZE / MAD_ROM_SIZE
		xor	a

	.loop_next_mirror:
		cp	(hl)
		jr	nz, .test_failed
		inc	a
		add	hl, de
		djnz	.loop_next_mirror

		xor	a
		DSUB_RETURN

	.test_failed:
		ld	a, EC_MAD_ROM_ADDRESS
		or	a
		DSUB_RETURN
