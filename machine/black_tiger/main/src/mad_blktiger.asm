	include "cpu/z80/include/common.inc"

	global _start

	section code

_start:
		di
		im	1

		ld	a, $0
		out	(IO_BG_RAM_BANK), a
		out	(IO_CONTROL), a
		out	(IO_VIDEO), a
		out	(IO_SCROLL_X_HIGH), a
		out	(IO_SCROLL_X_LOW), a
		out	(IO_SCROLL_Y_HIGH), a
		out	(IO_SCROLL_Y_LOW), a

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
