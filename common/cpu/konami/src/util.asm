	include "cpu/konami/include/macros.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global delay
	global wait_button_press
	global wait_button_release

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

;		decd			; 3 cycles (crashes cpu)
		subd	#$1
		bne	 delay	 	; 2 cycles
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
