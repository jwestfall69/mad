	include "cpu/6309/include/common.inc"

	global sound_test

	section code

sound_test:
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
