	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"

	include "machine.inc"

	section code

	global sound_play_dsub


; d0 = sound to play
sound_play_dsub:

	; cps1's sound code seems to ignore the byte
	; sent to the latch if its the same as the
	; last time, so we tell it to stop first.
	move.b	#SOUND_NUM_STOP, REG_SOUND1
	move.b	d0, d1
	move.w	#$fff,d0
	DSUB	delay

	move.b	d1, REG_SOUND1
	DSUB_RETURN
