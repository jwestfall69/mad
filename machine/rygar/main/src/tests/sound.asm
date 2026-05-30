	include "cpu/z80/include/common.inc"

	global sound_test

	section code

sound_test:
		ld	a, $1
		ld	b, $7f
		ld	ix, sound_play_cb
		ld	iy, sound_stop_cb
		call	sound_test_handler
		ret

sound_play_cb:
		SOUND_PLAY
		ret

sound_stop_cb:
		SOUND_STOP
		ret
