	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/macros.inc"

	include "input.inc"
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

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_delay_for_sound
		PSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		ldy	#d_str_press_b1_to_skip
		PSUB	print_string

		ldx	#$7ff
	.loop_sound_init_delay:
		WATCHDOG
		lda	REG_INPUT
		bita	#INPUT_B1
		beq	.skip_sound_init_delay

		ldd	#$1ff
	.loop_inner_delay:
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		subd	#$1
		bne	.loop_inner_delay
		dxjnz	.loop_sound_init_delay


	.skip_sound_init_delay:
		SEEK_LN	(SCREEN_START_Y + 2)
		PSUB	print_clear_line

		WATCHDOG
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

		lda	#SOUND_NUM_SUCCESS
		SOUND_PLAY

		jsr	main_menu

	section data

d_str_testing_work_ram:		STRING "TESTING WORK RAM"
d_str_delay_for_sound:		STRING "DELAY FOR SOUND CPU INIT"
d_str_press_b1_to_skip:		STRING "PRESS B1 TO SKIP"
