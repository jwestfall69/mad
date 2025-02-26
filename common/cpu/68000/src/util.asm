	include "cpu/68000/include/dsub.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global delay_dsub
	global memory_rewrite_dsub
	global sound_play_byte_dsub
	global wait_button_press_dsub
	global wait_button_release_dsub

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
;  d0 = bytes (long)
memory_rewrite_dsub:
		lsr.l	#1, d0		; convert to words
	.loop_next_address:
		WATCHDOG
		move.w	(a0), d1
		move.w	d1, (a0)+
		subq.l	#1, d0
		bne	.loop_next_address
		DSUB_RETURN

; play the bits of the passed byte to the sound cpu/latch
; params:
;  d0 = byte to play
sound_play_byte_dsub:
		move.b	d0, d3
		moveq	#7, d2

	.loop_next_bit:
		WATCHDOG
		lsl.b	d3
		bcc	.is_zero
		move.w	#SOUND_NUM_BIT_ONE, d0
		bra	.sound_play

	.is_zero:
		move.w	#SOUND_NUM_BIT_ZERO, d0

	.sound_play:
		SOUND_PLAY
		SOUND_BIT_DELAY

		dbra	d2, .loop_next_bit
		DSUB_RETURN

; stall until the passed button is pressed
; params:
;  d0 = input bit to wait on
wait_button_press_dsub:
		WATCHDOG
		btst	d0, REG_INPUT
		beq	.pressed

		; doing our own delay to avoid nesting
		; to deep
		move.l	#$1ff, d1
	.loop_delay:
		subq.l	#$1, d1
		bne	.loop_delay
		bra	wait_button_press_dsub

	.pressed:
		DSUB_RETURN

; stall until the passed button is not being pressed
; params:
;  d0 = input bit to wait on
wait_button_release_dsub:
		WATCHDOG
		btst	d0, REG_INPUT
		bne	.released

		; doing our own delay to avoid nesting
		; to deep
		move.l	#$1ff, d1
	.loop_delay:
		subq.l	#$1, d1
		bne	.loop_delay
		bra	wait_button_release_dsub

	.released:
		DSUB_RETURN
