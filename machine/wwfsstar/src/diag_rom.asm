	include "cpu/68000/dsub.inc"
	include "cpu/68000/error_codes.inc"
	include "cpu/68000/macros.inc"

	include "diag_rom.inc"
	include "error_codes.inc"
	include "machine.inc"

	global auto_diag_rom_crc32_test_dsub
	global auto_diag_rom_address_test_dsub

	section code

auto_diag_rom_crc32_test_dsub:
		lea	ROM_START, a0
		move.l	#DIAG_ROM_SIZE, d0
		subq.l	#5, d0

		DSUB	crc32

		move.l	d0, d2
		move.l	DIAG_ROM_CRC32_ADDRESS, d1
		cmp.l	d1, d2
		beq	.test_passed

		moveq	#EC_DIAG_ROM_CRC32, d0
		DSUB_RETURN

	.test_passed:
		moveq	#0, d0
		DSUB_RETURN

auto_diag_rom_address_test_dsub:
		lea	DIAG_ROM_MIRROR_ADDRESS, a0
		moveq	#(ROM_SIZE / DIAG_ROM_SIZE) - 1, d0
		moveq	#0, d2

	.loop_next_mirror:
		move.b	(a0), d1
		cmp.b	d2, d1
		bne	.test_failed
		adda.l	#DIAG_ROM_SIZE, a0
		addq.b	#1, d2
		dbra	d0, .loop_next_mirror

		moveq	#0, d0
		DSUB_RETURN

	.test_failed:
		moveq	#EC_DIAG_ROM_ADDRESS, d0
		DSUB_RETURN
