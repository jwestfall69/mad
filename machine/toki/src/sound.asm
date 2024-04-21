	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"

	include "machine.inc"

	section code

	global sound_play_dsub
	global sound_stop_dsub


; TODO: figure out how to play sounds

; d0 = sound to play
sound_play_dsub:
	DSUB_RETURN

sound_stop_dsub:
	DSUB_RETURN
