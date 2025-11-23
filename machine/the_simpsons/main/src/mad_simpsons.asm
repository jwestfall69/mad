	include "cpu/konami2/include/common.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		; allow some time for custom ICs to get started up
		; before we try to adjust their registers.  This
		; fixes issues with sprite ICs not working right.
		clra
	.startup_delay:
		inca
		bne	.startup_delay


		lda	#$13
		sta	$7c00

		lda	#$fb
		sta	$1d00

		clra
		sta	$1fc2
		lda	#$24
		sta	$1fa4
		lda	#$30
		sta	$1fc0
		ldd	#$1032
		sta	$1d80
		stb	$1f00
		clr	$1c80
		clrd
		std	$1fc6

		tst	$1fc4
		clr	$1e80
		std	$1fa0
		std	$1fa2

		lda	#$3f
		sta	$1fb0
		lda	#$04
		sta	$1fb2
		lda	#$28
		sta	$1fb3
		lda	#$18
		sta	$1fb4
		lda	#$17
		sta	$1fb6
		lda	#$27
		sta	$1fb7
		lda	#$37
		sta	$1fb8
		lda	#$13
		sta	$1fb9
		lda	#$2c
		sta	$1fba
		lda	#$00
		sta	$1fbb
		lda	#$05
		sta	$1fbc

		ldd	#$15
		std	$1fa0
		ldd	#$0261
		std	$1fa2


		lda	#$3f
		sta	$1fb9
		lda	#$36
		sta	$1fba

		nop
		nop
		nop
		nop

		lda	#$13
		sta	$1fb9
		lda	#$2c
		sta	$1fba

		lda	#$34
		sta	$1fa5

		clr	REG_CONTROL

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
