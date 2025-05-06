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

		lda	#$11
		sta	$7c00

		lda	#$fb
		sta	$5d00

		lda	#$0
		sta	REG_CONTROL
		sta	$5e80

		lda	#$24
		sta	$5fb4
		lda	#$10
		sta	$5fe0
		lda	#$24
		sta	$5fb5
		sta	$5fb5

		ldd	#$32
		sta	$5c80
		std	$5a00
		std	$7a00
		stb	$580c
		stb	$780c
		;std	$5fe6

		;inca
		;sta	$5fe4
		ldd	#$0135
		std	$5fb0
		ldd	#$02fa
		std	$5fb2


		lda	#$3f
		sta	$5fa0
		lda	#$03
		sta	$5fa2
		lda	#$0c
		sta	$5fa3
		lda	#$08
		sta	$5fa4
		lda	#$3f
		sta	$5fa6
		lda	#$3f
		sta	$5fa7
		lda	#$3f
		sta	$5fa8
		lda	#$13
		sta	$5fa9
		lda	#$34
		sta	$5faa
		lda	#$00
		sta	$5fab
		lda	#$3f
		sta	$5fa1
		lda	#$07
		sta	$5fac

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
