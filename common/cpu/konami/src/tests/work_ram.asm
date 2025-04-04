	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami/include/dsub.inc"
	include "cpu/konami/include/macros.inc"

	include "error_codes.inc"
	include "machine.inc"

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
		SEEK_LN SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_testing_work_ram_address
		PSUB	print_string

		ldd	#$1		; offset
		ldy	#$1		; counter (lower byte)

		ldx	#WORK_RAM_START
		stb	, x+		; 0 address requires special processing

	.loop_next_write_address:
		exg	b, y		; swap in counter

		incb
		stb	, x

		exg	b, y		; swap out counter

		; shift over to next address bit
		aslb
		rola

		; setup x
		ldx	#WORK_RAM_START
		leax	d, x

		cmpx	#(WORK_RAM_START + WORK_RAM_SIZE)
		blt	.loop_next_write_address


		; reset and re-read/test
		ldd	#$1
		ldy	#$1

		ldx	#WORK_RAM_START
		cmpb	, x+		; 0 address requires special processing
		bne	.test_failed

	.loop_next_read_address:
		exg	b, y		; swap in counter

		incb
		cmpb	, x
		bne	.test_failed

		exg	b, y		; swap out counter

		; shift over to next address bit
		aslb
		rola

		; setup x
		ldx	#WORK_RAM_START
		leax	d, x

		cmpx	#(WORK_RAM_START + WORK_RAM_SIZE)
		blt	.loop_next_read_address
		DSUB_RETURN

	.test_failed:
		SEEK_LN SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_address
		PSUB	print_string

		lda	#EC_WORK_RAM_ADDRESS
		jmp	error_address

work_ram_data_test_dsub:
		SEEK_LN SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_testing_work_ram_data
		PSUB	print_string

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
		DSUB_RETURN

	.test_failed:
		SEEK_LN SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_data
		PSUB	print_string

		lda	#EC_WORK_RAM_DATA
		jmp	error_address


work_ram_output_test_dsub:
		SEEK_LN SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_testing_work_ram_output
		PSUB	print_string

		ldx	#WORK_RAM_START
		PSUB	memory_output_test

		cmpa	#$0
		beq	.test_passed

		SEEK_LN SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_output
		PSUB	print_string

		lda	#EC_WORK_RAM_OUTPUT
		jmp	error_address

	.test_passed:
		WATCHDOG
		DSUB_RETURN

work_ram_march_test_dsub:
		SEEK_LN SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_testing_work_ram_march
		PSUB	print_string

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
		DSUB_RETURN

	.test_failed:
		WATCHDOG

		SEEK_LN SCREEN_START_Y
		PSUB	print_clear_line

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
work_ram_write_test_dsub:
		SEEK_LN SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_testing_work_ram_write
		PSUB	print_string

		WATCHDOG

		ldx	#WORK_RAM_START
		lda	, x
		tfr	a, b
		comb
		stb	, x
		cmpa	, x
		bne	.test_passed

		SEEK_LN SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_write
		PSUB	print_string

		lda	#EC_WORK_RAM_WRITE
		jmp	error_address

	.test_passed:
		DSUB_RETURN


	section data

d_data_patterns:	dc.b $00, $55, $aa, $ff

; These are padded so we fully overwrite "TESTING WORK RAM"
d_str_work_ram_address:		STRING "WORK RAM ADDRESS"
d_str_work_ram_data:		STRING "WORK RAM DATA   "
d_str_work_ram_march:		STRING "WORK RAM MARCH  "
d_str_work_ram_output:		STRING "WORK RAM OUTPUT "
d_str_work_ram_write:		STRING "WORK RAM WRITE  "

d_str_testing_work_ram_address:	STRING "TESTING WORK RAM ADDRESS"
d_str_testing_work_ram_data:	STRING "TESTING WORK RAM DATA"
d_str_testing_work_ram_march:	STRING "TESTING WORK RAM MARCH"
d_str_testing_work_ram_output:	STRING "TESTING WORK RAM OUTPUT"
d_str_testing_work_ram_write:	STRING "TESTING WORK RAM WRITE"
