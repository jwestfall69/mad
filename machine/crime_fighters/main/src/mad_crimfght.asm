	include "cpu/konami2/include/common.inc"

	global _start

	section code

_start:
		CPU_INTS_DISABLE

		lda	#$12
		sta	$7c00

		lda	#$80
		sta	$3f9c

		setln	#(SETLN_WATCHDOG_POLL|SETLN_SELECT_RAM_WORK)

		DSUB_MODE_PSUB

		PSUB	screen_init

		PSUB	mad_rom_address_test
		PSUB	mad_rom_crc16_test

		SEEK_XY	0, SCREEN_START_Y
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

d_str_testing_work_ram:		STRING "TESTING WORK RAM"
