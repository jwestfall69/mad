	include "cpu/konami2/include/common.inc"

	global sound_test

	section code

sound_test:
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 14)
		ldy	#d_str_fm_sounds
		RSUB	print_string

		lda	#$1
		ldx	#sound_play_cb
		ldy	#sound_stop_cb
		jsr	sound_test_handler
		rts

sound_play_cb:
		SOUND_PLAY
		rts

sound_stop_cb:
		SOUND_STOP
		rts

	section data

d_str_fm_sounds:
	STRING	"FM SOUNDS STARTS AT 81"
