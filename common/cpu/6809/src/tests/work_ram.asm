	include "cpu/6809/include/common.inc"

	global work_ram_address_test_dsub
	global work_ram_data_test_dsub
	global work_ram_march_test_dsub
	global work_ram_output_test_dsub
	global work_ram_write_test_dsub

	section code

; Write an incrementing value at each address line, then
; read them back checking for any differences.  Have to do
; a bit of juggling because of limited registers and lack of
; useful opcodes (ie ldx d,x).
work_ram_address_test_dsub:

		ldd	#$1
		tfr	d, y		; d = addr offset, y = counter

		ldx	#WORK_RAM_CHIP
		stb	, x+		; 0 address requires special processing

	.loop_next_write_address:
		exg	d, y		; d = counter, y = addr offset

		incb
		stb	, x

		exg	d, y		; d = addr offset, y = counter

		; shift over to next address bit
		aslb
		rola

		; add base work ram address
		ora	#(WORK_RAM_CHIP >> 8)
		orb	#(WORK_RAM_CHIP & $ff)
		tfr	d, x
		; recover addr offset
		eora	#(WORK_RAM_CHIP >> 8)
		eorb	#(WORK_RAM_CHIP & $ff)

		cmpx	#(WORK_RAM_CHIP + WORK_RAM_CHIP_SIZE)
		blt	.loop_next_write_address


		; reset and re-read/test
		ldd	#$1
		tfr	d, y		; d = counter, y = addr offset

		ldx	#WORK_RAM_CHIP
		cmpb	, x+		; 0 address requires special processing
		bne	.test_failed

	.loop_next_read_address:
		exg	d, y		; d = counter, y = addr offset

		incb
		cmpb	, x
		bne	.test_failed

		exg	d, y		; d = addr offset, y = counter

		; setup x for the next address

		; shift over to next address bit
		aslb
		rola

		; add base work ram address
		ora	#(WORK_RAM_CHIP >> 8)
		orb	#(WORK_RAM_CHIP & $ff)
		tfr	d, x
		; recover addr offset
		eora	#(WORK_RAM_CHIP >> 8)
		eorb	#(WORK_RAM_CHIP & $ff)

		cmpx	#(WORK_RAM_CHIP + WORK_RAM_CHIP_SIZE)
		blt	.loop_next_read_address
		DSUB_RETURN

	.test_failed:
		lda	#EC_WORK_RAM_ADDRESS
		jmp	error_address

work_ram_data_test_dsub:
		ldy	#d_data_patterns

	.loop_next_pattern:
		WATCHDOG
		lda	,y+

		ldx	#WORK_RAM_CHIP
	.loop_next_write_address:
		sta	,x+
		cmpx	#(WORK_RAM_CHIP + WORK_RAM_CHIP_SIZE)
		bne	.loop_next_write_address

		ldx	#WORK_RAM_CHIP
	.loop_next_read_address:
		cmpa	,x+
		bne	.test_failed
		cmpx	#(WORK_RAM_CHIP + WORK_RAM_CHIP_SIZE)
		bne	.loop_next_read_address

		cmpa	#$ff	; last pattern
		beq	.test_passed
		bra	.loop_next_pattern

	.test_passed:
		DSUB_RETURN

	.test_failed:
		lda	#EC_WORK_RAM_DATA
		jmp	error_address


; When the memory location has dead output the
; 6809 will fill the destination register with
; the first byte of the next instruction
work_ram_output_test_dsub:
		ldx	#WORK_RAM_CHIP
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
		DSUB_RETURN

	.test_failed:
		WATCHDOG
		lda	#EC_WORK_RAM_OUTPUT
		jmp	error_address


work_ram_march_test_dsub:

		ldx	#WORK_RAM_CHIP

		lda	#$0
	.loop_fill_zero:
		sta	, x+
		cmpx	#(WORK_RAM_CHIP + WORK_RAM_CHIP_SIZE)
		bne	.loop_fill_zero
		WATCHDOG

		ldb	#$ff
		ldx	#WORK_RAM_CHIP

	.loop_up_test:
		cmpa	, x
		bne	.test_failed

		stb	, x+
		cmpx	#(WORK_RAM_CHIP + WORK_RAM_CHIP_SIZE)
		bne	.loop_up_test
		WATCHDOG

		leax	-1, x

	.loop_down_test:
		cmpb	, x
		bne	.test_failed
		leax	-1, x
		cmpx	#(WORK_RAM_CHIP - 1)
		bne	.loop_down_test
		WATCHDOG
		DSUB_RETURN

	.test_failed:
		WATCHDOG
		lda	#EC_WORK_RAM_MARCH
		jmp	error_address

; - reads a byte from the memory address
; - writes !value to memory address
; - re-reads memory address
; - compare re-read with original
; - if they match, test failed
work_ram_write_test_dsub:
		WATCHDOG

		ldx	#WORK_RAM_CHIP
		lda	, x
		tfr	a, b
		comb
		stb	, x
		cmpa	, x
		bne	.test_passed

		lda	#EC_WORK_RAM_WRITE
		jmp	error_address

	.test_passed:
		DSUB_RETURN


	section data

d_data_patterns:	dc.b $00, $55, $aa, $ff
