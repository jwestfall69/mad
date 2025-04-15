; These memory tests are only valid on non-work ram memory regions
	include "cpu/konami/include/dsub.inc"
	include "cpu/konami/include/macros.inc"

	include "machine.inc"

	global memory_address_test
	global memory_data_test
	global memory_march_test
	global memory_output_test
	global memory_write_test

	section code

; Write an incrementing value at each address line, then
; read them back checking for any differences
; params:
;  a = number of address lines to test
;  x = start address
; returns:
;  a = 0 (pass), 1 (fail)
;  b = actual value
;  x = failed address
;  y = expected value
memory_address_test:

		inca			; bump up for 0 address and # loops
		sta	(r_memory_address_lines)
		stx	(r_memory_start)

		ldd	#$1		; offset
		ldy	#$1		; counter (lower byte)

		stb	, x+

	.loop_next_write_address:
		incb
		stb	, x

		exg	b, y		; swap out counter

		; shift over to next address bit
		aslb
		rola

		; setup x
		ldx	(r_memory_start)
		leax	d, x

		exg	b, y		; swap in counter
		cmpb	(r_memory_address_lines)
		bne	.loop_next_write_address


		; reset and re-read/test
		ldd	#$1
		ldy	#$1

		ldx	(r_memory_start)
		cmpb	, x		; 0 address requires special processing
		bne	.test_failed
		leax	1, x

	.loop_next_read_address:
		incb
		cmpb	, x
		bne	.test_failed

		exg	b, y		; swap out counter

		; shift over to next address bit
		aslb
		rola

		; setup x
		ldx	(r_memory_start)
		leax	d, x

		exg	b, y		; swap in counter
		cmpb	(r_memory_address_lines)
		blt	.loop_next_read_address

		clra
		rts

	.test_failed:
		tfr	b, y
		ldb	, x
		lda	#$1
		rts

; params:
;  a = pattern
;  x = start address
;  y = size
; returns:
;  a = 0 (pass), 1 (fail)
;  b = actual value
;  x = failed address
;  y = expected value
memory_data_test:
		stx	(r_memory_start)
		sty	(r_memory_size)

		exg	x, y
	.loop_next_write_address:
		sta	, y+
		dxjnz	.loop_next_write_address
		WATCHDOG

		ldx	(r_memory_size)
		ldy	(r_memory_start)

	.loop_next_read_address:
		ldb	, y
		cmpa	, y+
		bne	.test_failed
		dxjnz	.loop_next_read_address
		WATCHDOG

		clra
		rts

	.test_failed:
		WATCHDOG
		leay	-1, y
		exg	x, y
		tfr	a, y
		lda	#$1
		rts


; params:
;  x = start address
;  y = size
; returns:
;  a = 0 (pass), 1 (fail)
;  b = actual value
;  x = failed address
;  y = expected value
memory_march_test:

		stx	(r_memory_start)
		sty	(r_memory_size)

		exg	x, y

	.loop_fill_zero:
		clr	, y+
		dxjnz	.loop_fill_zero
		WATCHDOG


		ldy	(r_memory_start)
		ldx	(r_memory_size)

		lda	#$ff
	.loop_up_test:
		ldb	, y
		cmpb	#$0
		bne	.test_failed
		sta	, y+
		dxjnz	.loop_up_test
		WATCHDOG

		ldx	(r_memory_size)
		leay	-1, y

		clra
	.loop_down_test:
		ldb	, y
		cmpb	#$ff
		bne	.test_failed
		clr	, y
		leay	-1, y
		dxjnz	.loop_down_test

		WATCHDOG
		clra
		rts

	.test_failed:
		WATCHDOG
		coma
		exg	x, y
		tfr	a, y
		lda	#$1
		rts


; This is testing for dead output from whatever
; is directly connected to the CPU when talking
; to the memory.  This maybe the memory itself
; or there could be some IC in between (ie 74LS245)
; Lack of output will usually result the register be
; filled with the contents of the ld's optarg.  So
; we loop $64 times trying to catch 2 different
; optargs being placed into 'a' in a row.
; params:
;  x = address
; returns:
;  a = 0 (pass), 1 (fail)
memory_output_test:
		tfr	x, y
		ldb	#$64

	.loop_next:
		lda	, x		; $1226
		cmpa	#$26
		bne	.loop_pass

		lda	, y		; $1236
		cmpa	#$36
		beq	.test_failed

	.loop_pass:
		dbjnz	.loop_next

		WATCHDOG
		clra
		rts

	.test_failed:
		WATCHDOG
		lda	#$1
		rts


; - reads a byte from the memory address
; - writes !value to memory address
; - re-reads memory address
; - compare re-read with original
; - if they match, test failed
; params:
;  x = address
; returns:
;  a = 0 (pass), 1 (fail)
memory_write_test:
		WATCHDOG

		lda	, x
		tfr	a, b
		comb
		stb	, x

		cmpa	, x
		beq	.test_failed

		clra
		rts

	.test_failed:
		lda	#$1
		rts

	section bss

r_memory_start:			dcb.w 1
r_memory_size:			dcb.w 1
r_memory_address_lines:		dcb.b 1
