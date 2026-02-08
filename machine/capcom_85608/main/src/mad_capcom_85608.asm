	include "cpu/z80/include/common.inc"

	global _start

	section code

_start:
		di
		im 1
		SOUND_BIT_DELAY

		ld	a, CTRL_RS_BASE|CTRL_NMI_DISABLE|CTRL_SND_RESET_ON
		ld	(REG_CONTROL), a
		ld	a, $ff
		ld	($f80c), a
		ld	a, $00
		ld	($f802), a
		ld	($f800), a
		ld	($f803), a
		ld	($f801), a
		ld	($f804), a
		ld	a, $3f
		ld	($f805), a

		ld	a, CTRL_RS_BASE|CTRL_NMI_DISABLE|CTRL_SND_RESET_OFF
		ld	(REG_CONTROL), a

		ld	a, $ff
		ld	($f809), a
		ld	($f809), a
		ld	($f809), a
		ld	($f809), a
		ld	($f809), a
		ld	($f809), a
		ld	($f809), a

		DSUB_MODE_PSUB

		PSUB	palette_init_no_nmi
		PSUB	screen_init

		PSUB	mad_rom_crc32_test
		PSUB	mad_rom_address_test
		PSUB	auto_work_ram_tests

		DSUB_MODE_RSUB

		call	palette_init_nmi
		call	auto_func_tests

		ld	a, SOUND_NUM_SUCCESS
		SOUND_PLAY

		jp	main_menu
