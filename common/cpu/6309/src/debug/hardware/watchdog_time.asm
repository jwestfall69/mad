	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/error_codes.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global watchdog_time

; The purpose of this is to make it possible to measure how much
; time can pass between pinging the watchdog address and the watchdog
; resetting the cpu.
;
; The test requires the use of a logic analyzer with 2 probes that
; can capture about a seconds worth of 30+Mhz of samples.  The probes
; should be hooked up to following pins:
;
;  HD6309 PIN 32 (R/W)
;  HD6309 PIN 37 (RESET)
;
; The goal of the capture/test is to see the last write to the
; watchdog, then measure the between that and the RESET line going
; low.
;
; You will want to setup a trigger for when the R/W pin goes low.
; Activate the capture and press button 1.  In the captured data
; you will want to look for the RESET line going low then work
; backwards to the last time the R/W pin pulsed down.  This should
; be the last time the we wrote to the watchdog.  More details below.

	section code

watchdog_time:
		ldy	#d_screen_xys_list
		PSUB	print_xy_string_list

	; Wait for the user to release button b1 from when they
	; pressed it to select the this menu item
	.loop_wait_b1_release:
		WATCHDOG
		lda	REG_INPUT
		coma
		bita	#INPUT_B1
		bne	.loop_wait_b1_release


	; The 3 WATCHDOGs in a row are to make it easy to identify
	; being in the input loop on captured data.  The R/W pin will
	; have a consistent repeat of 3 quick low pulses then a small
	; delay
	.loop_input:
		WATCHDOG
		WATCHDOG
		WATCHDOG
		lda	REG_INPUT
		coma

		bita	#INPUT_B1
		beq	.b1_not_pressed
		bra	.run_test

	.b1_not_pressed:
		bita	#INPUT_B2
		beq	.loop_input
		rts


	; The print in addition to letting the user know the test was
	; started also provides a way to distinguish between the 3
	; WATCHDOGs above and our last WATCHDOG. There will be 9
	; evenly spaced R/W pulses from the print function writing
	; "TRIGGERED" to the screen.  Then the final R/W pulse from
	; the WATCHDOG before we go into the stall loop.  The R/W pin
	; should remain high until to REST pin goes low.
	.run_test:
		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 12)
		ldy	#d_str_triggered
		PSUB	print_string

		WATCHDOG
	.stall:
		bra	.stall


	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "THIS TEST IS USED IN"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "CONJUNCTION WITH A"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "LOGIC ANALYZER"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - WATCHDOG THEN STALL"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

d_str_triggered:	STRING "TRIGGERED"
