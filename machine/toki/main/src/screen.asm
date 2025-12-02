	include "cpu/68000/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub
	global screen_update_dsub

	section code

screen_init_dsub:
		; clear everything but work ram
		lea	NOT_WORK_RAM, a0
		move.l	#NOT_WORK_RAM_SIZE, d0
		moveq	#0, d1
		DSUB	memory_fill

		; text color
		move.w	#$fff, TXT_PALETTE + $16

		; text shadow color
		move.w	#$222, TXT_PALETTE + $8

		; background color
		move.w	#0, PALETTE_RAM + $41c
		move.w	#0, PALETTE_RAM + $61e

		SEEK_XY	5, 0
		lea	d_str_version, a0
		DSUB	print_string

		SEEK_XY	0, 1
		move.l	#'-', d0
		moveq	#SCREEN_NUM_COLUMNS, d1
		DSUB	print_char_repeat

		move.b	#$1, r_sprite_copy_req
		DSUB_RETURN

; in cases where we need to goto x, y location at runtime
; params:
;  d0 = x
;  d1 = y
screen_seek_xy_dsub:
		SEEK_XY	0, 0
		and.l	#$ff, d0
		and.l	#$ff, d1
		lsl.w	#1, d0
		lsl.w	#6, d1
		adda.l	d0, a6
		adda.l	d1, a6
		DSUB_RETURN


; toki only updates the screen when MMIO_UPDATE_SCREEN
; is written to.
screen_update_dsub:
		move.w	sr, d0
		btst	#8, d0
		beq	.skip_update
		SCREEN_UPDATE

	.skip_update:
		DSUB_RETURN
