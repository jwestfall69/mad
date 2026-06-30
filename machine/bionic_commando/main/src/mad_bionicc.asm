	include "cpu/68000/include/common.inc"

	global _start

	section code

_start:
		CPU_INTS_DISABLE

		move.w	#$0, REG_BG_SCROLL_X
		move.w	#$0, REG_BG_SCROLL_Y
		move.w	#$0, REG_FG_SCROLL_X
		move.w	#$0, REG_FG_SCROLL_Y

		DSUB_MODE_PSUB
		PSUB	screen_init
		PSUB	palette_init_no_irq
		PSUB	auto_test_dsub_handler

		DSUB_MODE_RSUB

		move.w	#$0, r_vblank_copy_size
		move.w	#$0, r_vblank_fill_size
		move.b	#$0, r_sprite_dma_req

		jsr	palette_init_irq
		jsr	sprite_ram_clear
		bsr	auto_func_tests

	;	move.w	#SOUND_NUM_SUCCESS, d0
	;	SOUND_PLAY

		clr.b	r_menu_cursor
		bra	main_menu
