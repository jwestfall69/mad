	include "cpu/68000/include/common.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		move.l	#$fffff, d0
	.loop_delay:
		dbra	d0, .loop_delay

	ifd _SCREEN_FLIP_
		; hardware init / screen flipped
		; bg layer
		move.w	#$014d, $7a300 ; x offset
		move.w	#$fff0, $7a304 ; y scroll
		move.w	#$00ef, $7a308 ; y offset
		move.w	#$0000, $7a30c ; x scroll
		move.w	#$0004, $7a310 ; 16x16 tiles

		; fg layer
		move.w	#$014d, $7a200 ; x offset
		move.w	#$fff0, $7a204 ; y scroll
		move.w	#$00ef, $7a208 ; y offset
		move.w	#$0000, $7a20c ; x scroll
		move.w	#$0004, $7a210 ; 16x16 tiles

		; txt layer
		move.w	#$004d, $7a100 ; x offset
		move.w	#$0000, $7a104 ; y scroll
		move.w	#$00ef, $7a108 ; y offset
		move.w	#$0000, $7a10c ; x scroll
		move.w	#$0003, $7a110 ; 8x8 tiles

		move.w	#$0001, $7a808 ; screen flip
	else
		; hardware init / screen not flipped
		; bg layer
		move.w	#$ffb2, $7a300 ; x offset
		move.w	#$fff0, $7a304 ; y scroll
		move.w	#$0010, $7a308 ; y offset
		move.w	#$0004, $7a30c ; x scroll
		move.w	#$0004, $7a310 ; 16x16 tiles

		; fg layer
		move.w	#$ffb2, $7a200 ; x offset
		move.w	#$fff0, $7a204 ; y scroll
		move.w	#$0010, $7a208 ; y offset
		move.w	#$0004, $7a20c ; x scroll
		move.w	#$0004, $7a210 ; 16x16 tiles

		; txt layer
		move.w	#$ffb2, $7a100 ; x offset
		move.w	#$0000, $7a104 ; y scroll
		move.w	#$0010, $7a108 ; y offset
		move.w	#$0000, $7a10c ; x scroll
		move.w	#$0003, $7a110 ; 8x8 tiles

		move.w	#$0000, $7a808 ; don't screen flip
	endif

		move.w	#$000f, $7a000 ; ?
		move.w	#$0010, $7a002 ; sprite y offset
		move.w	#$00ef, $7a004 ; ?
		move.w	#$0001, $7a006 ; enable sprite rendering

		SOUND_STOP

		DSUB_MODE_PSUB
		PSUB	screen_init
		PSUB	auto_test_dsub_handler

		DSUB_MODE_RSUB
		bsr	auto_func_tests

		move.w	#SOUND_NUM_SUCCESS, d0
		SOUND_PLAY

		bsr	main_menu
