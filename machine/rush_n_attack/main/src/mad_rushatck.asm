	include "cpu/z80/include/common.inc"

	global _start

	section code

_start:
		di
		im 1

		WATCHDOG

		ld	a, $0
		ld	($e044), a
		ld	($f000), a
		ld	a, $82
		ld	($e043), a

		; tell the sn76489 to be quiet
		ld	a, $9f
		ld	b, $4
	.loop_next_sn76489_tone_volume:
		ld	(REG_SOUND_LATCH), a
		ld	(REG_SOUND_TRIGGER), a
		add	$20
		nop
		nop
		nop
		nop
		nop
		nop
		djnz	.loop_next_sn76489_tone_volume

		DSUB_MODE_PSUB

		PSUB	screen_init

		PSUB	mad_rom_crc32_test
		PSUB	mad_rom_address_test
		PSUB	auto_work_ram_tests

		DSUB_MODE_RSUB

		;call	auto_func_tests

		jp	main_menu
