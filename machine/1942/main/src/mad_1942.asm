	include "cpu/z80/include/common.inc"

	global _start

	section code

_start:
		di
		im	0
		SOUND_BIT_DELAY

		ld	a, $0
		ld	(REG_CONTROL), a
		ld	(REG_PALETTE_BANK), a
		ld	(REG_ROM_BANK), a
		ld	(REG_SOUND), a
		ld	bc, $0
		ld	(REG_BG_SCROLL_X), bc

		DSUB_MODE_PSUB

		PSUB	screen_init

		PSUB	mad_rom_crc32_test
		PSUB	mad_rom_address_test
		PSUB	auto_work_ram_tests

		DSUB_MODE_RSUB

		call	sprite_ram_clear
		call	auto_func_tests

		ld	a, SOUND_NUM_SUCCESS
		SOUND_PLAY

		jp	main_menu
