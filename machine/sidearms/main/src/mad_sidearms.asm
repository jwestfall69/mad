	include "cpu/z80/include/common.inc"

	global _start

	section code

_start:
		di
		im 1
		SOUND_BIT_DELAY

		ld	hl, $0
		ld	($c808), hl
		ld	($c80a), hl
		ld	a, $0
		ld	($c801), a

		;ld	($c802), a
		ld	($c803), a

		ld	a, $02
		ld	($c80c), a

		ld	a, $50
		ld	($c804), a

		ld	a, $4c
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
