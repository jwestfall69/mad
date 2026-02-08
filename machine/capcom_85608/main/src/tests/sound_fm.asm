	include "cpu/z80/include/common.inc"

	global sound_fm_test

	section code

sound_fm_test:
		ld	a, $1
		ld	b, $ff
		ld	ix, sound_play_cb
		ld	iy, sound_stop_cb
		call	sound_test_handler
		ret

sound_play_cb:
		ld	d, a
		ld	a, $48
		ld	(REG_SOUND_FM), a

		ld	bc, $3ff
		RSUB	delay

		ld	a, d
		ld	(REG_SOUND_FM), a
		ret

sound_stop_cb:
		ld	a, $48
		ld	(REG_SOUND_FM), a
		ret
