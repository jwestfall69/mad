	include "cpu/68000/include/common.inc"

	global auto_mad_rom_crc32_test_dsub
	global auto_mad_rom_address_test_dsub

	section code

auto_mad_rom_crc32_test_dsub:
		lea	ROM_START, a0
		move.l	#MAD_ROM_SIZE, d0
		subq.l	#5, d0

		DSUB	crc32

		move.l	d0, d2
		move.l	MAD_ROM_CRC32_ADDRESS, d1
		cmp.l	d1, d2
		beq	.test_passed

		moveq	#EC_MAD_ROM_CRC32, d0
		DSUB_RETURN

	.test_passed:
		moveq	#0, d0
		DSUB_RETURN

auto_mad_rom_address_test_dsub:
		lea	MAD_ROM_MIRROR_ADDRESS, a0
		moveq	#(ROM_SIZE / MAD_ROM_SIZE) - 1, d0
		moveq	#0, d1

	.loop_next_mirror:
		move.b	(a0), d2
		cmp.b	d1, d2
		bne	.test_failed
		adda.l	#MAD_ROM_SIZE, a0
		addq.b	#1, d1
		dbra	d0, .loop_next_mirror

		moveq	#0, d0
		DSUB_RETURN

	.test_failed:
		moveq	#EC_MAD_ROM_ADDRESS, d0
		DSUB_RETURN
