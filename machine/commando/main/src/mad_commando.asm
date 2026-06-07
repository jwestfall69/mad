	include "cpu/z80/include/common.inc"

	global _start

	section code

_start:
		di
		im	0
		DELAY	$ffff

		; sound cpu reset
		ld	a, $10
		ld	(REG_CONTROL), a

		DELAY	$1ff

		ld	a, $0
		ld	(REG_CONTROL), a

		SOUND_STOP

		ld	bc, $0
		ld	(REG_BG_SCROLL_X), bc
		ld	(REG_BG_SCROLL_Y), bc

		DSUB_MODE_PSUB

		PSUB	screen_init

		PSUB	mad_rom_crc32_test
		PSUB	mad_rom_address_test
		PSUB	auto_work_ram_tests

		DSUB_MODE_RSUB

		call	wait_sprite_copy_request
		call	auto_func_tests

		ld	a, SOUND_NUM_SUCCESS
		SOUND_PLAY

		jp	main_menu
