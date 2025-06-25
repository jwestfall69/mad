	include "cpu/6309/include/dsub.inc"
	include "cpu/6309/include/macros.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global delay_dsub
	global joystick_update_byte
	global joystick_lr_update_byte
	global joystick_update_word
	global joystick_lr_update_word
	global memory_copy_dsub
	global memory_rewrite_dsub
	global sound_play_byte_dsub
	global wait_button_press
	global wait_button_release

	global r_scratch

	section code

; params:
;  w = number of loops
delay_dsub:
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
		bne	 delay_dsub 	; 2 cycles
		DSUB_RETURN

; Looking at joystick input, adjust the byte in memory by
;  +$1 for UP
;  -$1 for DOWN
; -$10 for LEFT
; +$10 for RIGHT
; Then apply the mask to the byte
; params:
;  a = mask
;  x = #r_input_edge|#r_input_raw
;  y = address of byte to update
joystick_update_byte:
		tfr	a, e

		lda	, x
		bita	#INPUT_UP
		beq	.up_not_pressed
		inc	, y

	.up_not_pressed:
		bita	#INPUT_DOWN
		beq	.down_not_pressed
		dec	, y

	.down_not_pressed:
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		ldb	, y
		subb	#$10
		stb	, y

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		ldb	, y
		addb	#$10
		stb	, y
	.right_not_pressed:
		lda	, y
		andr	a, e
		sta	, y
		rts

; Looking at joystick left/right, adjust the byte in memory
; -$1 for LEFT
; +$1 for RIGHT
; If b1 is held down, then inc/dec is $10
; Then apply the mask to the byte
; params:
;  a = mask
;  x = #r_input_edge|#r_input_raw
;  y = address of byte to update
; returns:
;  a = 0 no change, 1 = change
joystick_lr_update_byte:
		tfr	a, e		; mask
		ldf	#$1		; inc/dec mount

		; don't allow $10 inc/dec mount if mask wouldn't allow
		; a value of >= $10
		cmpa	#$10
		blo	.b1_not_pressed

		lda	r_input_raw
		bita	#INPUT_B1
		beq	.b1_not_pressed
		ldf	#$10

	.b1_not_pressed:
		lda	, x
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		ldb	, y
		subr	f, b
		stb	, y
		bra	.apply_mask_return

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.return_no_change
		ldb	, y
		addr	f, b
		stb	, y

	.apply_mask_return:
		lda	, y
		andr	e, a
		sta	, y
		lda	#$1
		rts

	.return_no_change:
		clra
		rts

; Looking at joystick input, adjust the word in memory by
;  +$1 for UP
;  -$1 for DOWN
; -$10 for LEFT
; +$10 for RIGHT
; Then apply the mask to the word
; params:
;  d = mask
;  x = #r_input_edge|#r_input_raw
;  y = address of word to update
joystick_update_word:
		std	r_mask

		lda	, x
		bita	#INPUT_UP
		beq	.up_not_pressed
		ldw	, y
		addw	#$1
		stw	, y

	.up_not_pressed:
		bita	#INPUT_DOWN
		beq	.down_not_pressed
		ldw	, y
		subw	#$1
		stw	, y

	.down_not_pressed:
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		ldw	, y
		subw	#$10
		stw	, y

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		ldw	, y
		addw	#$10
		stw	, y

	.right_not_pressed:
		ldd	, y
		andd	r_mask
		std	, y
		rts

; Looking at joystick left/right, adjust the word in memory
; -$1 for LEFT
; +$1 for RIGHT
; If b1 is held down, then inc/dec is $10
; Then apply the mask to the word
; params:
;  d = mask
;  x = #r_input_edge|#r_input_raw
;  y = address of word to update
; returns:
;  a = 0 no change, 1 = change
joystick_lr_update_word:
		std	r_mask

		ldw	#$1	; inc/dec amount

		lda	r_input_raw
		bita	#INPUT_B1
		beq	.b1_not_pressed
		ldw	#$10

	.b1_not_pressed:
		lda	, x
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		ldd	, y
		subr	w, d
		std	, y
		bra	.apply_mask_return

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.return_no_change
		ldd	, y
		addr	w, d
		std	, y

	.apply_mask_return:
		ldd	, y
		andd	r_mask
		std	, y

		lda	#$1
		rts

	.return_no_change:
		clra
		rts

; params:
;  x = src address
;  y = dst address
;  w = size in bytes
memory_copy_dsub:
		WATCHDOG
		lda	, x+
		sta	, y+
		decw
		bne	memory_copy_dsub
		DSUB_RETURN


; params:
;  w = size
;  x = start address
memory_rewrite_dsub:
		WATCHDOG
		lda	, x
		sta	, x+
		decw
		bne	memory_rewrite_dsub
		DSUB_RETURN


; params:
;  a = byte to play
sound_play_byte_dsub:
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
		DSUB_RETURN

; stall until the passed button is pressed
; params:
;  a = button bit mask
wait_button_press:
		pshs	b
		pshsw

	.loop_input:
		WATCHDOG
		ldb	REG_INPUT
		andr	a, b
		beq	.pressed

		ldw	#$1ff
		RSUB	delay
		bra	.loop_input

	.pressed:
		pulsw
		puls	b
		rts

; stall until the passed button is not being pressed
; params:
;  a = button bit mask
wait_button_release:
		pshs	b
		pshsw

	.loop_input:
		WATCHDOG
		ldb	REG_INPUT
		andr	a, b
		bne	.released

		ldw	#$1ff
		RSUB	delay
		bra	.loop_input

	.released:
		pulsw
		puls	b
		rts


	section bss
; The cpu doesn't support register to register add/sub/cmp/etc
; instructions, this is a global scratch location that can be
; used to help work around this (after work ram is tested good).
; ie:
;		stb	r_scratch
;		adda	r_scratch
r_scratch:		dcb.w 1
r_mask:			dcb.w 1
