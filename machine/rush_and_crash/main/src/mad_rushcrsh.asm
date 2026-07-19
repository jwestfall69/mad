	include "cpu/6809/include/common.inc"

	global _start

	section code

_start:
		CPU_INTS_DISABLE

		; this will cause $5000-$8fff to be banked
		; to ram
		lda	#$14
		sta	REG_BANK

		ldd	#$0
		std	REG_BG_TILE_SCROLL_X
		std	REG_BG_TILE_SCROLL_Y

		DSUB_MODE_PSUB

		SOUND_STOP

		PSUB	screen_init
		PSUB	palette_init_no_irq

;		mad rom address testing not possible because of
;		boards weird rom bank setup
;		PSUB	mad_rom_address_test
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

		ldd	#$0
		std	r_vblank_copy_size
		std	r_vblank_fill_size

		jsr	palette_init_irq
		jsr	sprite_ram_clear

		jsr	auto_func_tests

		lda	#SOUND_NUM_SUCCESS
		SOUND_PLAY

		jsr	main_menu
