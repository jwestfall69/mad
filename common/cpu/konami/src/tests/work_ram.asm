	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami/include/macros.inc"
	include "cpu/konami/include/psub.inc"

	include "error_codes.inc"
	include "machine.inc"

;	global work_ram_address_test_psub
	global work_ram_data_test_psub
	global work_ram_march_test_psub
	global work_ram_output_test_psub
	global work_ram_write_test_psub

	section code

; Write an incrementing value at each address line, then
; read them back checking for any differences.  Have to do
; a bit of juggling because of limited registers and lack of
; useful opcodes (ie ldx d,x).
;work_ram_address_test_psub:
;
;		ldd	#$1
;		tfr	d, y		; d = addr offset, y = counter
;
;		ldx	#WORK_RAM_START
;		stb	, x+		; 0 address requires special processing
;
;	.loop_next_write_address:
;		exg	d, y		; d = counter, y = addr offset
;
;		incb
;		stb	, x
;
;		exg	d, y		; d = addr offset, y = counter
;
;		; shift over to next address bit
;		aslb
;		rola
;
;		; add base work ram address
;		ora	#(WORK_RAM_START >> 8)
;		orb	#(WORK_RAM_START & $ff)
;		tfr	d, x
;		; recover addr offset
;		eora	#(WORK_RAM_START >> 8)
;		eorb	#(WORK_RAM_START & $ff)
;
;		cmpx	#(WORK_RAM_START + WORK_RAM_SIZE)
;		blt	.loop_next_write_address
;
;
;		; reset and re-read/test
;		ldd	#$1
;		tfr	d, y		; d = counter, y = addr offset
;
;		ldx	#WORK_RAM_START
;		cmpb	, x+		; 0 address requires special processing
;		bne	.test_failed
;
;	.loop_next_read_address:
;		exg	d, y		; d = counter, y = addr offset
;
;		incb
;		cmpb	, x
;		bne	.test_failed
;
;		exg	d, y		; d = addr offset, y = counter
;
;		; setup x for the next address
;
;		; shift over to next address bit
;		aslb
;		rola
;
;		; add base work ram address
;		ora	#(WORK_RAM_START >> 8)
;		orb	#(WORK_RAM_START & $ff)
;		tfr	d, x
;		; recover addr offset
;		eora	#(WORK_RAM_START >> 8)
;		eorb	#(WORK_RAM_START & $ff)
;
;		cmpx	#(WORK_RAM_START + WORK_RAM_SIZE)
;		blt	.loop_next_read_address
;		PSUB_RETURN
;
;	.test_failed:
;		lda	#EC_WORK_RAM_ADDRESS
;		jmp	error_address

work_ram_data_test_psub:
		ldy	#d_data_patterns

	.loop_next_pattern:
		WATCHDOG
		lda	,y+

		ldx	#WORK_RAM_START
	.loop_next_write_address:
		sta	,x+
		cmpx	#(WORK_RAM_START + WORK_RAM_SIZE)
		bne	.loop_next_write_address

		ldx	#WORK_RAM_START
	.loop_next_read_address:
		cmpa	,x+
		bne	.test_failed
		cmpx	#(WORK_RAM_START + WORK_RAM_SIZE)
		bne	.loop_next_read_address

		cmpa	#$ff	; last pattern
		beq	.test_passed
		bra	.loop_next_pattern

	.test_passed:
		PSUB_RETURN

	.test_failed:
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_data
		PSUB	print_string

		lda	#EC_WORK_RAM_DATA
		jmp	error_address


work_ram_output_test_psub:
		; the konami does dummy memory reads of 0xffff
		; when its doesnt need to access the address bus.
		; because of this, reads of memory locations with
		; no/dead output will cause the register to be filled
		; with the lower byte of the reset function's address
		; from the vector table.  This is why we have a special
		; RESET section in the linker as it gives us control
		; of what that last byte will be (0x5a)

		ldx	#WORK_RAM_START
		lda	$ffff
		ldb	#$7f
	.loop_next_address:
		cmpa	, x
		bne	.test_passed
		leax	2, x

		decb
		bne	.loop_next_address
		WATCHDOG

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_output
		PSUB	print_string

		lda	#EC_WORK_RAM_OUTPUT
		jmp	error_address

	.test_passed:
		WATCHDOG
		PSUB_RETURN

work_ram_march_test_psub:

		ldx	#WORK_RAM_START

		lda	#$0
	.loop_fill_zero:
		sta	, x+
		cmpx	#(WORK_RAM_START + WORK_RAM_SIZE)
		bne	.loop_fill_zero
		WATCHDOG

		lda	#$0
		ldb	#$ff
		ldx	#WORK_RAM_START

	.loop_up_test:
		cmpa	, x
		bne	.test_failed

		stb	, x+
		cmpx	#(WORK_RAM_START + WORK_RAM_SIZE)
		bne	.loop_up_test
		WATCHDOG

		leax	-1, x

	.loop_down_test:
		cmpb	, x
		bne	.test_failed
		leax	-1, x
		cmpx	#(WORK_RAM_START - 1)
		bne	.loop_down_test
		WATCHDOG
		PSUB_RETURN

	.test_failed:
		WATCHDOG

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_march
		PSUB	print_string

		lda	#EC_WORK_RAM_MARCH
		jmp	error_address

; - reads a byte from the memory address
; - writes !value to memory address
; - re-reads memory address
; - compare re-read with original
; - if they match, test failed
work_ram_write_test_psub:
		WATCHDOG

		ldx	#WORK_RAM_START
		lda	, x
		tfr	a, b
		comb
		stb	, x
		cmpa	, x
		bne	.test_passed

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_write
		PSUB	print_string

		lda	#EC_WORK_RAM_WRITE
		jmp	error_address

	.test_passed:
		PSUB_RETURN


	section data

d_data_patterns:	dc.b $00, $55, $aa, $ff

; These are padded so we fully overwrite "TESTING WORK RAM"
d_str_work_ram_address:		STRING "WORK RAM ADDRESS"
d_str_work_ram_data:		STRING "WORK RAM DATA   "
d_str_work_ram_march:		STRING "WORK RAM MARCH  "
d_str_work_ram_output:		STRING "WORK RAM OUTPUT "
d_str_work_ram_write:		STRING "WORK RAM WRITE  "
