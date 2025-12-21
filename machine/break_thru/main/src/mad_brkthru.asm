	include "cpu/6809/include/common.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		lda	#$1
		sta	$1803

		lda	#$0
		sta	$1800
		sta	$1801
		sta	$1802
		DSUB_MODE_PSUB

		SOUND_STOP

		PSUB	screen_init

		PSUB	mad_rom_address_test
		PSUB	mad_rom_crc16_test

		PSUB	work_ram_output_test
		PSUB	work_ram_write_test
		PSUB	work_ram_data_test
		PSUB	work_ram_address_test
		PSUB	work_ram_march_test

		DSUB_MODE_RSUB

		jsr	auto_func_tests

		lda	#SOUND_NUM_SUCCESS
		SOUND_PLAY

		jsr	main_menu
