	include "cpu/konami2/include/macros.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global delay
	global joystick_update_byte
	global joystick_update_word
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


; Looking at input data, adjust the byte in memory by
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

; Looking at input data, adjust the word in memory by
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
