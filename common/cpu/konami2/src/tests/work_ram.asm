	include "cpu/konami2/include/common.inc"

	global manual_work_ram_tests
	global work_ram_address_test_dsub
	global work_ram_data_test_dsub
	global work_ram_march_test_dsub
	global work_ram_output_test_dsub
	global work_ram_write_test_dsub

	section code

manual_work_ram_tests:
		SEEK_LN	SCREEN_START_Y
		RSUB	print_clear_line

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

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
		bita	#INPUT_B2
		beq	.test_exit

		ldd	R_WORK_RAM_PASSES
		addd	#$1
		std	R_WORK_RAM_PASSES
		bra	.loop_next_pass

	.test_exit:
		DSUB_MODE_RSUB

		clr	r_menu_cursor
		jmp	main_menu

; Write an incrementing value at each address line, then
; read them back checking for any differences.  Have to do
; a bit of juggling because of limited registers and lack of
; useful opcodes (ie ldx d,x).
work_ram_address_test_dsub:
		ldd	#$1		; offset
		ldy	#$1		; counter (lower byte)

		ldx	#WORK_RAM
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
		ldx	#WORK_RAM
		leax	d, x

		cmpx	#(WORK_RAM + WORK_RAM_SIZE)
		blt	.loop_next_write_address


		; reset and re-read/test
		ldd	#$1
		ldy	#$1

		ldx	#WORK_RAM
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
		ldx	#WORK_RAM
		leax	d, x

		cmpx	#(WORK_RAM + WORK_RAM_SIZE)
		blt	.loop_next_read_address
		DSUB_RETURN

	.test_failed:
		SEEK_LN SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_address
		PSUB	print_string

		lda	#EC_WORK_RAM_ADDRESS
		PSUB	sound_play_byte

		lda	#EC_WORK_RAM_ADDRESS
		jmp	error_address

work_ram_data_test_dsub:
		ldy	#d_data_patterns

	.loop_next_pattern:
		WATCHDOG
		lda	,y+

		ldx	#WORK_RAM
	.loop_next_write_address:
		sta	,x+
		cmpx	#(WORK_RAM + WORK_RAM_SIZE)
		bne	.loop_next_write_address

		ldx	#WORK_RAM
	.loop_next_read_address:
		cmpa	,x+
		bne	.test_failed
		cmpx	#(WORK_RAM + WORK_RAM_SIZE)
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
		PSUB	sound_play_byte

		lda	#EC_WORK_RAM_DATA
		jmp	error_address

; This is testing for dead output from whatever
; is directly connected to the CPU when talking
; to the memory.  This maybe the memory itself
; or there could be some IC in between (ie 74LS245)
; Lack of output will usually result the register be
; filled with the contents of the ld's optarg.  So
; we loop $64 times trying to catch 2 different
; optargs being placed into 'a' in a row.
work_ram_output_test_dsub:
		ldx	#WORK_RAM
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
		DSUB_RETURN

	.test_failed:
		SEEK_LN SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_output
		PSUB	print_string

		lda	#EC_WORK_RAM_OUTPUT
		PSUB	sound_play_byte

		lda	#EC_WORK_RAM_OUTPUT
		jmp	error_address

work_ram_march_test_dsub:
		ldx	#WORK_RAM
		lda	#$0

	.loop_fill_zero:
		sta	, x+
		cmpx	#(WORK_RAM + WORK_RAM_SIZE)
		bne	.loop_fill_zero
		WATCHDOG

		lda	#$0
		ldb	#$ff
		ldx	#WORK_RAM

	.loop_up_test:
		cmpa	, x
		bne	.test_failed

		stb	, x+
		cmpx	#(WORK_RAM + WORK_RAM_SIZE)
		bne	.loop_up_test
		WATCHDOG

		leax	-1, x

	.loop_down_test:
		cmpb	, x
		bne	.test_failed
		leax	-1, x
		cmpx	#(WORK_RAM - 1)
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
		PSUB	sound_play_byte

		lda	#EC_WORK_RAM_MARCH
		jmp	error_address

; - reads a byte from the memory address
; - writes !value to memory address
; - re-reads memory address
; - compare re-read with original
; - if they match, test failed
work_ram_write_test_dsub:
		WATCHDOG

		ldx	#WORK_RAM
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
		PSUB	sound_play_byte

		lda	#EC_WORK_RAM_WRITE
		jmp	error_address

	.test_passed:
		DSUB_RETURN


	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "TESTING WORK RAM"
	XY_STRING SCREEN_START_X, SCREEN_PASSES_Y, "PASSES"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

d_data_patterns:	dc.b $00, $55, $aa, $ff

; These are padded so we fully overwrite "TESTING WORK RAM"
d_str_work_ram_address:		STRING "WORK RAM ADDRESS"
d_str_work_ram_data:		STRING "WORK RAM DATA   "
d_str_work_ram_march:		STRING "WORK RAM MARCH  "
d_str_work_ram_output:		STRING "WORK RAM OUTPUT "
d_str_work_ram_write:		STRING "WORK RAM WRITE  "
