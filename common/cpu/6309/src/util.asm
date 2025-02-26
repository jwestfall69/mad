	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"
	include "mad.inc"

	global delay_psub
	global memory_rewrite_psub
	global sound_play_byte_psub
	global wait_button_release

	section code

; params:
;  w = number of loops
delay_psub:
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		decw			; 3 cycles
		bne	 delay_psub 	; 2 cycles
		PSUB_RETURN

; params:
;  w = size
;  x = start address
memory_rewrite_psub:
		WATCHDOG
		lda	,x
		sta	,x+
		decw
		bne	memory_rewrite_psub
		PSUB_RETURN

; params:
;  a = byte to play
sound_play_byte_psub:
		tfr	a, b
		lde	#$8

	.loop_next_bit:
		WATCHDOG

		lslb
		bcc	.is_zero

		lda	#SOUND_NUM_BIT_ONE
		bra	.sound_play

	.is_zero:
		lda	#SOUND_NUM_BIT_ZERO

	.sound_play:
		SOUND_PLAY
		tfr	d, x
		tfr	w, y
		SOUND_BIT_DELAY
		tfr	x, d
		tfr	y, w

		dece
		bne	.loop_next_bit
		PSUB_RETURN

; stall until the passed button is not being pressed
; params:
;  a = button bit mask
wait_button_release:
		pshs	b
		pshsw

	.loop_input:
		WATCHDOG
		ldb	REG_INPUT_P1
		andr	a, b
		bne	.released

		ldw	#$1ff
		PSUB	delay
		bra	.loop_input

	.released:
		pulsw
		puls	b
		rts
