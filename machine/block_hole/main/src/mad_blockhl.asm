	include "global/include/macros.inc"
	include "global/include/screen.inc"

	include "cpu/6x09/include/macros.inc"

	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/macros.inc"

	include "machine.inc"
	include "mad.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		lda	#$13
		sta	$7c00

		clra
		sta	$1d00

		lda	#$01
		sta	$1f8c
		clrb
		stb	$1f8c
		stb	$1f84
		stb	$1f88
		stb	$1c80
		stb	$1a00
		stb	$1a01
		stb	$3a00
		stb	$3a01
		stb	$180c
		stb	$3809
		stb	$3801
		ldd	#$3210
		stb	$1d80
		sta	$1f94

		;lda	#$80
		;sta	$1f9c

		setln	#(SETLN_WATCHDOG_POLL|SETLN_SELECT_RAM_WORK)

		MEMORY_FILL16 #WORK_RAM, #($2000 / 2), #$0
		WATCHDOG
		DSUB_MODE_PSUB

		PSUB	screen_init

		PSUB	mad_rom_address_test
		PSUB	mad_rom_crc16_test

		SEEK_LN	SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_testing_work_ram
		PSUB	print_string


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

	section data

d_str_testing_work_ram: 	STRING "TESTING WORK RAM"
