	include "cpu/68000/dsub.inc"

	include "machine.inc"
	include "diag_rom.inc"

	global delay_dsub
	global memory_rewrite_word_dsub
	global sound_play_byte_dsub

	section code

; fix me to have proper timings
; params:
;  d0 = # of loops
delay_dsub:
		subq.l	#1, d0		;  4 cycles
		bne	delay_dsub	; 10 cycles
		DSUB_RETURN

; writes a region of memory (mainly just used to force
; mame to consider the memorry dirty, causing it to update
; its state/redraw the screen)
; params:
;  a0 = start address
;  d0 = number of words
memory_rewrite_word_dsub:
		subq.w #1, d0
	.loop_next_address:
		move.w	(a0), d1
		move.w	d1, (a0)+
		dbra	d0, .loop_next_address
		DSUB_RETURN

; play the bits of the passed byte to the sound cpu/latch
; params:
;  d0 = byte to play
sound_play_byte_dsub:
		move.b	d0, d3
		moveq	#7, d2

	.loop_next_bit:
		lsl.b	d3
		bcc	.is_zero
		move.b	#SOUND_NUM_BIT_ONE, d0
		bra	.sound_play

	.is_zero:
		move.b	#SOUND_NUM_BIT_ZERO, d0

	.sound_play:
		SOUND_PLAY
		SOUND_BIT_DELAY

		dbra	d2, .loop_next_bit
		DSUB_RETURN
