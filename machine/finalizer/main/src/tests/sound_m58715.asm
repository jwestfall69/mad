	include "cpu/6809/include/common.inc"

	global sound_m58715_test

	section code

sound_m58715_test:
		lda	#$4
		ldx	#sound_play_cb
		ldy	#sound_stop_cb
		jsr	sound_test_handler
		rts

sound_play_cb:
		sta	REG_M58715
		sta	REG_M58715_IRQ_TRIGGER
		rts

sound_stop_cb:
		clra
		sta	REG_M58715
		sta	REG_M58715_IRQ_TRIGGER
		rts
