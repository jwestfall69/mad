	include "cpu/z80/include/error_codes.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/psub.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global auto_mad_rom_crc32_test_psub
	global auto_mad_rom_address_test_psub

	section code

auto_mad_rom_crc32_test_psub:
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


; Any non-zero value indicates an issue.  There is
; no need to loop looking for the correct values of
; the different mirrors since we can only report a
; back pass/fail
auto_mad_rom_address_test_psub:
		ld	a, (MAD_ROM_MIRROR_ADDRESS)
		or	a
		jr	nz, .test_failed

		xor	a
		PSUB_RETURN

	.test_failed:
		ld	a, EC_MAD_ROM_ADDRESS
		or	a
		PSUB_RETURN
