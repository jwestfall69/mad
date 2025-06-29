	include "cpu/6x09/include/macros.inc"

	include "cpu/6309/include/dsub.inc"

	include "machine.inc"

	global memory_address_test_dsub
	global memory_data_test_dsub
	global memory_march_test_dsub
	global memory_output_test_dsub
	global memory_output_behind_245_test_dsub
	global memory_write_test_dsub

	section code


; Write an incrementing value at each address line, then
; read them back checking for any differences
; params:
;  a = number of address lines to test
;  x = start address
; returns:
;  a = 0 (pass), 1 (fail)
;  b = actual value
;  y = expected value
;  x = failed address
memory_address_test_dsub:

		inca			; bump up for 0 address and # loops
		inca
		tfr	a, f		; # of address lines
		tfr	a, y		; # of address lines (will need on re-read)
		lde	#$1		; value being written
		ste	0, x		; 0 address requires special processing

		ldd	#$1		; address line being tested
		ince

	.loop_next_write_address:
		ste	d, x
		lsld
		ince
		cmpr	e, f
		bne	.loop_next_write_address
		WATCHDOG

		clrd
		lde	#$1
		ldf	d, x
		cmpr	e, f
		bne	.test_failed

		ldd	#$1
		ince

	.loop_next_read_address:
		ldf	d, x
		cmpr	e, f
		bne	.test_failed
		lsld
		ince
		tfr	y, f		; restore # of address lines
		cmpr	e, f
		bne	.loop_next_read_address
		WATCHDOG
		clra
		DSUB_RETURN

	.test_failed:
		WATCHDOG
		leax	d, x
		tfr	f, b
		tfr	e, y
		lda	#$1
		DSUB_RETURN


; params:
;  d = length
;  e = pattern
;  x = start address
; returns:
;  a = 0 (pass), 1 (fail)
;  b = actual value
;  y = expected value
;  x = failed address
memory_data_test_dsub:

		tfr	d, y
	.loop_next_write_address:
		ste	, x+
		decd
		bne	.loop_next_write_address
		WATCHDOG

		tfr	y, d
		subr	d, x

	.loop_next_read_address:
		ldf	, x+
		cmpr	f, e
		bne	.test_failed
		decd
		bne	.loop_next_read_address
		WATCHDOG
		clra
		DSUB_RETURN

	.test_failed:
		WATCHDOG
		tfr	f, b
		tfr	e, y
		leax	-1, x
		lda	#$1
		DSUB_RETURN


; params:
;  d = length
;  x = start address
; returns:
;  a = 0 (pass), 1 (fail)
;  b = actual value
;  y = expected value
;  x = failed address
memory_march_test_dsub:

		tfr	d, y

	.loop_fill_zero:
		clr	, x+
		decd
		bne	.loop_fill_zero
		WATCHDOG

		tfr	y, d
		subr	d, x

		lde	#$ff
	.loop_up_test:
		ldf	, x
		cmpf	#$0
		bne	.test_failed
		ste	, x+
		decd
		bne	.loop_up_test
		WATCHDOG

		tfr	y, d
		leax	-1, x

	.loop_down_test:
		ldf	0, x
		cmpf	#$ff
		bne	.test_failed
		clr	0, x
		leax	-1, x
		decd
		bne	.loop_down_test
		WATCHDOG
		clra
		DSUB_RETURN

	.test_failed:
		WATCHDOG
		clre
		tfr	f, b
		tfr	e, y
		lda	#$1
		DSUB_RETURN


; This is testing for dead output from whatever
; is directly connected to the CPU when talking
; to the memory.  This maybe the memory itself
; or there could be some IC in between (ie 74LS245)
; When the memory location has dead output the
; 6809 will fill the destination register with
; the first byte of the next instruction.
; params:
;  x = address
; returns:
;  a = 0 (pass), 1 (fail)
memory_output_test_dsub:
		ldb	#$64

	.loop_next:
		lda	, x
		cmpa	#$81		; $8181
		bne	.loop_pass

		lda	, x
		nop			; $12
		cmpa	#$12
		beq	.test_failed

	.loop_pass:
		decb
		bne	.loop_next
		WATCHDOG
		clra
		DSUB_RETURN

	.test_failed:
		WATCHDOG
		lda	#$1
		DSUB_RETURN


; This test should get used if there is an 74LS245
; between the CPU and the memory being tested.  This
; test will attempt to see if the inputs going into
; the 74LS245 are floating (ie the memory has dead
; output).  When this happens 74LS245 will output
; high on all of its output pins.
; params:
;  x = address
; returns:
;  a = 0 (pass), 1 (fail)
memory_output_behind_245_test_dsub:

		clra
	.loop_next_address:
		sta	, x

		; delay a bit (manual since we can't
		; nest another PSUB)
		ldw	#$1ff
	.loop_delay:
		cmpd	#0
		cmpd	#0
		cmpd	#0
		cmpd	#0
		decw
		bne	.loop_delay
		WATCHDOG

		ldb	, x++
		cmpb	#$ff
		bne	.test_passed

		inca
		cmpa	#$7f
		bne	.loop_next_address
		WATCHDOG
		lda	#$1
		DSUB_RETURN

	.test_passed:
		WATCHDOG
		clra
		DSUB_RETURN


; - reads a byte from the memory address
; - writes !value to memory address
; - re-reads memory address
; - compare re-read with original
; - if they match, test failed
; params:
;  x = address
; returns:
;  a = 0 (pass), 1 (fail)
memory_write_test_dsub:
		WATCHDOG

		lda	, x
		tfr	a, b
		comb
		stb	, x

		ldb	, x
		cmpr	a, b
		beq	.test_failed

		clra
		DSUB_RETURN

	.test_failed:
		lda #$1
		DSUB_RETURN
