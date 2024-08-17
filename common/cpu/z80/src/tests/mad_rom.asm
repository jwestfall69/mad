	include "cpu/z80/include/error_codes.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/psub.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global mad_rom_crc32_test_psub
	global mad_rom_address_test_psub

	section code

mad_rom_crc32_test_psub:
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
		PSUB_RETURN

	.test_failed:
		ld	a, EC_MAD_ROM_CRC32
		or	a
		PSUB_RETURN


mad_rom_address_test_psub:
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
		PSUB_RETURN

	.test_failed:
		ld	a, EC_MAD_ROM_ADDRESS
		or	a
		PSUB_RETURN
