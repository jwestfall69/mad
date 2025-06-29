	include "cpu/6x09/include/dsub.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global delay
	global joystick_update_byte
	global joystick_lr_update_byte
	global joystick_update_word
	global joystick_lr_update_word
	global memory_copy
	global sound_play_byte_dsub
	global wait_button_press
	global wait_button_release

	global r_scratch

	section code

; params:
;  d = number of loops
delay:
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
		subd	#$1
		bne	delay	 	; 2 cycles
		rts

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
		sta	r_mask

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
		anda	r_mask
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
		sta	r_mask

		ldb	#$1
		stb	r_scratch	; using for inc/dec amount

		; don't allow $10 inc/dec mount if mask wouldn't allow
		; a value of >= $10
		cmpa	#$10
		blo	.b1_not_pressed

		lda	r_input_raw
		bita	#INPUT_B1
		beq	.b1_not_pressed
		lda	#$10
		sta	r_scratch

	.b1_not_pressed:
		lda	, x
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		ldb	, y
		subb	r_scratch
		stb	, y
		bra	.apply_mask_return

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.return_no_change
		ldb	, y
		addb	r_scratch
		stb	, y

	.apply_mask_return:
		lda	, y
		anda	r_mask
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
		sta	r_scratch
		ldd	, y
		addd	#$1
		std	, y
		lda	r_scratch

	.up_not_pressed:
		bita	#INPUT_DOWN
		beq	.down_not_pressed
		sta	r_scratch
		ldd	, y
		subd	#$1
		std	, y
		lda	r_scratch

	.down_not_pressed:
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		sta	r_scratch
		ldd	, y
		subd	#$10
		std	, y
		lda	r_scratch

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		sta	r_scratch
		ldd	, y
		addd	#$10
		std	, y
		lda	r_scratch

	.right_not_pressed:
		ldd	, y
		anda	r_mask
		andb	r_mask + 1
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

		lda	#$1
		clr	r_scratch
		sta	r_scratch + 1 	; using for inc/dec amount

		lda	r_input_raw
		bita	#INPUT_B1
		beq	.b1_not_pressed
		lda	#$10
		sta	r_scratch + 1

	.b1_not_pressed:
		lda	, x
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		ldd	, y
		subd	r_scratch
		std	, y
		bra	.apply_mask_return

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.return_no_change
		ldd	, y
		addd	r_scratch
		std	, y

	.apply_mask_return:
		ldd	, y
		anda	r_mask
		andb	r_mask + 1
		std	, y
		lda	#$1
		rts

	.return_no_change:
		clra
		rts

; params:
;  x = src address
;  y = dst address
;  d = size in bytes
memory_copy:
		std	r_scratch
	.loop_next_byte:
		WATCHDOG
		lda	, x+
		sta	, y+
		ldd	r_scratch
		subd	#$1
		std	r_scratch
		bne	.loop_next_byte
		rts

; params:
;  a = byte to play
sound_play_byte_dsub:
		tfr	a, b
		ldx	#$8

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
		tfr	b, y
		SOUND_BIT_DELAY
		tfr	y, b

		leax	-1, x
		bne	.loop_next_bit
		DSUB_RETURN

; stall until the passed button is pressed
; params:
;  a = button bit mask
wait_button_press:
		pshs	b
		tfr	a, b

	.loop_input:
		WATCHDOG
		anda	REG_INPUT
		beq	.pressed

		tfr	b, a

		pshs	d
		ldd	#$1ff
		jsr	delay
		puls	d
		bra	.loop_input

	.pressed:
		puls	b
		rts

; stall until the passed button is not being pressed
; params:
;  a = button bit mask
wait_button_release:
		pshs	b
		tfr	a, b

	.loop_input:
		WATCHDOG
		anda	REG_INPUT
		bne	.released

		tfr	b, a

		pshs	d
		ldd	#$1ff
		jsr	delay
		puls	d
		bra	.loop_input

	.released:
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
