	include "cpu/6809/include/common.inc"

	global sound_sn76489a_test

	section code

sound_sn76489a_test:
		lda	#$4
		ldx	#sound_play_cb
		ldy	#sound_stop_cb
		jsr	sound_test_handler
		rts

; params:
; a = sound byte
sound_play_cb:
		tfr	a, b
		lsra
		lsra
		lsra
		lsra
		ora	#$80
		sta	REG_SN76489A_DATA
		sta	REG_SN76489A_TRIGGER_LOAD

		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0

		tfr	b, a
		anda	#$f
		sta	REG_SN76489A_DATA
		sta	REG_SN76489A_TRIGGER_LOAD

		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0

		lda	#$93
		sta	REG_SN76489A_DATA
		sta	REG_SN76489A_TRIGGER_LOAD
		rts

sound_stop_cb:
		lda	#$9f
		sta	REG_SN76489A_DATA
		sta	REG_SN76489A_TRIGGER_LOAD
		rts
