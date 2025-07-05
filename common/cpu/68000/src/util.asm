	include "cpu/68000/include/common.inc"

	global delay_dsub
	global joystick_lr_update_byte
	global joystick_lr_update_word
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


; Looking at joystick left/right, adjust the byte in memory
; -$1 for LEFT
; +$1 for RIGHT
; If b1 is held down, then inc/dec is $10
; Then apply the mask to the byte
; params:
;  d.b = mask
;  a0 = #r_input_edge|#r_input_raw
;  a1 = address of byte to update
; returns:
;  a = 0 no change, 1 = chan
joystick_lr_update_byte:
		move.b	d0, d2
		moveq	#$1, d1		; inc/dec amount

		; don't allow $10 inc/dec mount if mask wouldn't allow
		; a value of >= $10
		cmp.b	#$10, d2
		blo	.b1_not_pressed

		move.b	r_input_raw, d0
		btst	#INPUT_B1_BIT, d0
		beq	.b1_not_pressed
		add.b	#$f, d1

	.b1_not_pressed:
		move.b	(a0), d0
		btst	#INPUT_LEFT_BIT, d0
		beq	.left_not_pressed
		sub.b	d1, (a1)
		bra	.apply_mask_return

	.left_not_pressed:
		btst	#INPUT_RIGHT_BIT, d0
		beq	.return_no_change
		add.b	d1, (a1)

	.apply_mask_return:
		and.b	d2, (a1)
		moveq	#$1, d0
		rts

	.return_no_change:
		clr	d0
		rts

; Looking at joystick left/right, adjust the byte in memory
; -$1 for LEFT
; +$1 for RIGHT
; If b1 is held down, then inc/dec is $10
; Then apply the mask to the byte
; params:
;  d.w = mask
;  a0 = #r_input_edge|#r_input_raw
;  a1 = address of byte to update
; returns:
;  a = 0 no change, 1 = chan
joystick_lr_update_word:
		move.w	d0, d2
		moveq	#$1, d1		; inc/dec amount

		move.b	r_input_raw, d0
		btst	#INPUT_B1_BIT, d0
		beq	.b1_not_pressed
		add.w	#$f, d1

	.b1_not_pressed:
		move.b	(a0), d0
		btst	#INPUT_LEFT_BIT, d0
		beq	.left_not_pressed
		sub.w	d1, (a1)
		bra	.apply_mask_return

	.left_not_pressed:
		btst	#INPUT_RIGHT_BIT, d0
		beq	.return_no_change
		add.w	d1, (a1)

	.apply_mask_return:
		and.w	d2, (a1)
		moveq	#$1, d0
		rts

	.return_no_change:
		clr	d0
		rts


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
