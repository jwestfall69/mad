	include "cpu/6809/include/common.inc"

	global work_ram_address_test_dsub
	global work_ram_data_test_dsub
	global work_ram_march_test_dsub
	global work_ram_output_test_dsub
	global work_ram_write_test_dsub

	ifnd _HEADLESS_
		global manual_work_ram_tests
	endif

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
	;	ora	#(WORK_RAM_CHIP >> 8)
		adda	#(WORK_RAM_CHIP >> 8)
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
		;ora	#(WORK_RAM_CHIP >> 8)
		adda	#(WORK_RAM_CHIP >> 8)
		orb	#(WORK_RAM_CHIP & $ff)
		tfr	d, x
		; recover addr offset
		eora	#(WORK_RAM_CHIP >> 8)
		eorb	#(WORK_RAM_CHIP & $ff)

		cmpx	#(WORK_RAM_CHIP + WORK_RAM_CHIP_SIZE)
		blt	.loop_next_read_address
		DSUB_RETURN

	.test_failed:

	ifnd _HEADLESS_
		tfr	x, y
		lda	, x
		PSUB	print_error_work_ram_memory

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_address
		PSUB	print_string

		lda	#EC_WORK_RAM_ADDRESS
		PSUB	sound_play_byte
	endif

		lda	#EC_WORK_RAM_ADDRESS
		jmp	error_address

work_ram_data_test_dsub:
		ldy	#d_data_patterns

	.loop_next_pattern:
		WATCHDOG
		ldb	,y+

		ldx	#WORK_RAM_CHIP
	.loop_next_write_address:
		stb	,x+
		cmpx	#(WORK_RAM_CHIP + WORK_RAM_CHIP_SIZE)
		bne	.loop_next_write_address

		ldx	#WORK_RAM_CHIP
	.loop_next_read_address:
		cmpb	,x+
		bne	.test_failed
		cmpx	#(WORK_RAM_CHIP + WORK_RAM_CHIP_SIZE)
		bne	.loop_next_read_address

		cmpb	#$ff	; last pattern
		beq	.test_passed
		bra	.loop_next_pattern

	.test_passed:
		DSUB_RETURN

	.test_failed:

	ifnd _HEADLESS_
		leax	-1, x
		lda	, x
		tfr	x, y
		PSUB	print_error_work_ram_memory

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_data
		PSUB	print_string

		lda	#EC_WORK_RAM_DATA
		PSUB	sound_play_byte
	endif

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

	ifnd _HEADLESS_
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_output
		PSUB	print_string

		SEEK_XY	0, SCREEN_B2_Y
		PSUB	print_clear_line

		lda	#EC_WORK_RAM_OUTPUT
		PSUB	sound_play_byte
	endif

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
		bne	.test_failed_up

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

	.test_failed_up:
		tfr	a, b

	.test_failed:
		lda	, x
		tfr	x, y

		WATCHDOG
	ifnd _HEADLESS_
		PSUB	print_error_work_ram_memory

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_march
		PSUB	print_string

		lda	#EC_WORK_RAM_MARCH
		PSUB	sound_play_byte
	endif

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

	ifnd _HEADLESS_
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_write
		PSUB	print_string

		SEEK_XY	0, SCREEN_B2_Y
		PSUB	print_clear_line

		lda	#EC_WORK_RAM_OUTPUT
		PSUB	sound_play_byte
	endif

		lda	#EC_WORK_RAM_WRITE
		jmp	error_address

	.test_passed:
		DSUB_RETURN


	ifnd _HEADLESS_

; NOTE: PSUB'ing print_error_work_ram_memory actually makes us nest
; too deep causing us to lose the return point for returning from
; work_ram_xxx_test_dsub. However this doesn't matter because in
; the case of a failed work ram test we won't be returning
;
; params:
;  a = expected
;  b = actual
print_error_work_ram_memory_dsub:
		tfr	b, dp

		; actual
		SEEK_XY (SCREEN_START_X + 12), (SCREEN_START_Y + 4)
		PSUB	print_hex_byte

		; expected
		tfr	dp, a
		SEEK_XY (SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		PSUB	print_hex_byte

		; address
		tfr	y, d
		SEEK_XY (SCREEN_START_X + 10), (SCREEN_START_Y + 2)
		PSUB	print_hex_word

		clra
		tfr	a, dp

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 2)
		ldy	#d_str_address
		PSUB	print_string

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 3)
		ldy	#d_str_expected
		PSUB	print_string

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 4)
		ldy	#d_str_actual
		PSUB	print_string

		SEEK_XY	0, SCREEN_B2_Y
		PSUB	print_clear_line
		DSUB_RETURN


manual_work_ram_tests:
		SEEK_XY	0, SCREEN_START_Y
		RSUB	print_clear_line

		SEEK_XY SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_testing_work_ram
		RSUB	print_string

		jsr	print_passes
		jsr	print_b2_return_to_menu

		ldd	#$0
		std	R_WORK_RAM_PASSES

		DSUB_MODE_PSUB

	.loop_next_pass:
		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		ldd	R_WORK_RAM_PASSES
		PSUB	print_hex_word

		PSUB	work_ram_output_test
		PSUB	work_ram_write_test
		PSUB	work_ram_data_test
		PSUB	work_ram_address_test
		PSUB	work_ram_march_test

		lda	REG_INPUT
		coma
		bita	#INPUT_B2
		bne	.test_exit

		ldd	R_WORK_RAM_PASSES
		addd	#$1
		std	R_WORK_RAM_PASSES
		bra	.loop_next_pass

	.test_exit:
		clr	r_menu_cursor

		DSUB_MODE_RSUB

		jmp	main_menu

	endif

	section data

d_data_patterns:	dc.b $00, $55, $aa, $ff

	ifnd _HEADLESS_

; These are padded so we fully overwrite "TESTING WORK RAM"
d_str_work_ram_address:		STRING "WORK RAM ADDRESS"
d_str_work_ram_data:		STRING "WORK RAM DATA   "
d_str_work_ram_march:		STRING "WORK RAM MARCH  "
d_str_work_ram_output:		STRING "WORK RAM OUTPUT "
d_str_work_ram_write:		STRING "WORK RAM WRITE  "

d_str_testing_work_ram:		STRING "TESTING WORK RAM"

	endif
