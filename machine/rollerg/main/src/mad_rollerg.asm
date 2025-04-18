	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/macros.inc"

	include "machine.inc"
	include "mad.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		ldd	#$017f
		std	$0100
		ldd	#$0023
		std	$0102
		ldb	#$1d
		std	$0104
		ldd	#$0273
		sta	$0106
		stb	$010c
		clr	$0107
		ldd	#$0107
		std	$0108
		ldd	#$100f
		sta	$010a
		stb	$010b
		clrd
		sta	$0030
		sta	$0031
		sta	$0040
		std	$020c
		ldb	#$07
		stb	$020e
		ldd	#$f424
		std	$0304
		sta	$0307
		ldd	#$03b2
		std	$0300
		ldd	#$02f8
		std	$0302
		lda	#$10
		sta	$0202
		sta	$020a

		setln	#$0

		DSUB_MODE_PSUB

		PSUB	screen_init

		PSUB	mad_rom_address_test
		PSUB	mad_rom_crc16_test

		SEEK_LN	SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_testing_work_ram
		PSUB	print_string

		PSUB	work_ram_output_test
		PSUB	work_ram_write_test
		PSUB	work_ram_data_test
		PSUB	work_ram_address_test
		PSUB	work_ram_march_test

		DSUB_MODE_RSUB

		jsr	auto_func_tests
		jsr	main_menu

	section data

d_str_testing_work_ram:		STRING "TESTING WORK RAM"
