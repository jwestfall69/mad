	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"

	include "machine.inc"

	section code

	global sound_play_dsub
	global sound_stop_dsub


; d0 = sound to play
sound_play_dsub:
	move.b	d0, REG_SOUND
	DSUB_RETURN

sound_stop_dsub:
	move.b #SOUND_STOP, REG_SOUND
	DSUB_RETURN
