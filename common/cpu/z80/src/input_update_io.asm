	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/dsub.inc"
	include "input.inc"
	include "machine.inc"

	global input_update
	global wait_button_press
	global wait_button_release
	global check_button_press_dsub

	global r_input_edge
	global r_input_raw

	section code

; This is a generic input update that should work so long as
; the machine as all of the player 1's buttons in a single
; register.  Should that not be the case a machine specific
; version of this function should be made.
input_update:
		; small delay to help stop button press bounce
		ld	bc, $1ff
		RSUB	delay

		in	a, (IO_INPUT)
		xor	$ff
		ld	b, a
		ld	a, (r_input_raw)
		xor	b
		and	b
		ld	(r_input_edge), a
		ld	a, b
		ld	(r_input_raw), a
		ret

; See if a button is pressed. This is really only needed
; when we are in PSUB mode and can't use ram/input_update
; params:
;  b = button bit mask
check_button_press_dsub:
		exx

		in	a, (IO_INPUT)
		and	b
		jr	z, .pressed

		ld	a, 0
		jr	.return

	.pressed:
		ld	a, 1
	.return:
		DSUB_RETURN

; stall until the passed button is pressed
; params:
;  b = button bit mask
wait_button_press:
		WATCHDOG
		in	a, (IO_INPUT)
		and	b
		jr	z, .pressed

		push	bc
		ld	bc, $1ff
		RSUB	delay
		pop	bc
		jr	wait_button_press

	.pressed:
		ret

; stall until the passed button is not being pressed
; params:
;  b = button bit mask
wait_button_release:
		WATCHDOG
		in	a, (IO_INPUT)
		and	b
		jr	nz, .released

		push	bc
		ld	bc, $1ff
		RSUB	delay
		pop	bc
		jr	.wait_button_release

	.released:
		ret

	section bss

r_input_edge:	dc.b $0
r_input_raw:	dc.b $0
