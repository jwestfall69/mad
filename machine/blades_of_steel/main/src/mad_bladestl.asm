	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"
	include "mad.inc"

	global _start

	section code

_start:
		INTS_DISABLE

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

		PSUB	screen_init

		PSUB	auto_mad_rom_address_test
		PSUB	auto_mad_rom_crc32_test
		PSUB	auto_work_ram_tests

		lds	#(WORK_RAM + WORK_RAM_SIZE - 2)
		jsr	auto_func_tests

		lda	#SOUND_NUM_SUCCESS
		SOUND_PLAY

		jsr	main_menu
