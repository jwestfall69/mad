	include "cpu/6809/include/common.inc"

	global _start

	section code

_start:
		CPU_INTS_DISABLE

		DELAY	#$1ff

		DSUB_MODE_PSUB

		lda	#$0
		sta	>REG_CONTROL
		stb	>$0002
		stb	>$0001
		stb	>$0000

		lda	#VID_UNKNOWN_BIT2
		sta	>REG_VIDEO


		lda	#$9f
	.loop_sn76489_init:
		sta	REG_SN76489A_DATA
		sta	REG_SN76489A_TRIGGER_LOAD

		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0

		adda	#$20
		bcc	.loop_sn76489_init

		PSUB	m58715_init
		PSUB	screen_init

		; this wont really do anything because
		; mad rom size == eprom size
		;PSUB	mad_rom_address_test
		PSUB	mad_rom_crc16_test

		SEEK_XY	0, SCREEN_START_Y
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

		;jsr	auto_func_tests

		lda	#SOUND_NUM_SUCCESS
		SOUND_PLAY

		jsr	main_menu
