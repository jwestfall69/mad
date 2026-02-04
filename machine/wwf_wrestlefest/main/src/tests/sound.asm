	include "cpu/68000/include/common.inc"

	global sound_test

	section code

sound_test:
		moveq	#$01, d0
		lea	sound_play_cb, a0
		lea	sound_stop_cb, a1
		jsr	sound_test_handler
		rts

sound_play_cb:
		SOUND_PLAY
		rts

sound_stop_cb:
		SOUND_STOP
		rts
