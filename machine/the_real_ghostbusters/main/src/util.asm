	include "cpu/6x09/include/macros.inc"

	include "cpu/6309/include/dsub.inc"

	include "machine.inc"

	global sprite_trigger_copy_dsub

	section code

; The sprite ram the cpu uses is a buffer that we need to
; trigger to be copied and made active.  This is done by
; pulsing low to high the CTRL_SPRITE_COPY bit of REG_CONTROL
sprite_trigger_copy_dsub:
		; mame and hardware don't seem to agree on screen flip
		; setting (bit 3 of REG_CONTROL).  The bit set to 1 on
		; hardware is right way up, but mame is upside down and
		; vice versa if set to 0.
		clra
	ifnd _MAME_BUILD_
		ora	#CTRL_SCREEN_FLIP
	endif
		sta	REG_CONTROL

		nop
		nop
		nop
		nop

		lda	#CTRL_SPRITE_COPY
	ifnd _MAME_BUILD_
		ora	#CTRL_SCREEN_FLIP
	endif
		sta	REG_CONTROL
		DSUB_RETURN
