	include "cpu/6309/include/common.inc"

	global _start

	section code

_start:
		CPU_INTS_DISABLE

		clra
		clrb
		stb	$2600
		sta	$2fc0
		std	$2603
		std	$2605

		ldd	#$0c90
		stb	$2601
		sta	$2602

		clra
		sta	$2f40
		WATCHDOG

		DSUB_MODE_PSUB

		PSUB	screen_init

		PSUB	auto_mad_rom_address_test
		PSUB	auto_mad_rom_crc32_test
		PSUB	auto_work_ram_tests

		DSUB_MODE_RSUB

		jsr	auto_func_tests

		lda	#SOUND_NUM_SUCCESS
		SOUND_PLAY

		jsr	main_menu
