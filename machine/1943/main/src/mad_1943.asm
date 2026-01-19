	include "cpu/z80/include/common.inc"

	global _start

	section code

_start:
		di
		im 1
		SOUND_BIT_DELAY

		ld	hl, $0
		ld	($d800), hl
		ld	($d802), hl
		ld	a, $0
		ld	($d804), a
		ld	($c804), a
		ld	a, $a0
		ld	($c804), a

		ld	a, $24
		ld	($c807), a

		ld	a, $0
		ld	($d808), a
		ld	($d868), a
		ld	($d888), a
		ld	($d8a8), a

		ld	a, $80
		ld	($c804), a

		DSUB_MODE_PSUB

		PSUB	screen_init

		PSUB	mad_rom_crc32_test
		PSUB	mad_rom_address_test
		PSUB	auto_work_ram_tests

		DSUB_MODE_RSUB

		call	auto_func_tests

		ld	a, SOUND_NUM_SUCCESS
		SOUND_PLAY

		jp	main_menu
