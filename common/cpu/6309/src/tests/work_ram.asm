	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global	auto_work_ram_tests_psub
	global	manual_work_ram_tests

	section code

auto_work_ram_tests_psub:

		SEEK_LN	SCREEN_START_Y
		PSUB	print_clear_line

		SEEK_XY SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_testing_work_ram
		PSUB	print_string

		ldx	#WORK_RAM_START
		PSUB	memory_output_test
		tsta
		lbne	.test_failed_output

		ldx	#WORK_RAM_START
		PSUB	memory_write_test
		tsta
		lbne	.test_failed_write

		ldx	#WORK_RAM_START
		ldd	#WORK_RAM_SIZE
		lde	#$00
		PSUB	memory_data_test
		tsta
		lbne	.test_failed_data

		ldx	#WORK_RAM_START
		ldd	#WORK_RAM_SIZE
		lde	#$55
		PSUB	memory_data_test
		tsta
		lbne	.test_failed_data

		ldx	#WORK_RAM_START
		ldd	#WORK_RAM_SIZE
		lde	#$aa
		PSUB	memory_data_test
		tsta
		lbne	.test_failed_data

		ldx	#WORK_RAM_START
		ldd	#WORK_RAM_SIZE
		lde	#$ff
		PSUB	memory_data_test
		tsta
		lbne	.test_failed_data

		ldx	#WORK_RAM_START
		lda	#WORK_RAM_ADDRESS_LINES
		PSUB	memory_address_test
		tsta
		bne	.test_failed_address

		ldx	#WORK_RAM_START
		ldd	#WORK_RAM_SIZE
		PSUB	memory_march_test
		tsta
		bne	.test_failed_march
		PSUB_RETURN

	; NOTE: PSUB'ing print_error_work_ram_memory
	; actually makes us nest too deep causing us to
	; lose the return point for auto_work_ram_tests_psub.
	; However this doesn't matter because in the case
	; of a failed work ram test we won't be returning
	.test_failed_address:
		PSUB	print_error_work_ram_memory

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_address
		PSUB	print_string

		lda	#EC_WORK_RAM_ADDRESS
		bra	.do_error_code

	.test_failed_data:
		PSUB	print_error_work_ram_memory

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_data
		PSUB	print_string

		lda	#EC_WORK_RAM_DATA
		bra	.do_error_code

	.test_failed_march:
		PSUB	print_error_work_ram_memory

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_march
		PSUB	print_string

		lda	#EC_WORK_RAM_MARCH
		bra	.do_error_code

	.test_failed_output:
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_output
		PSUB	print_string

		lda	#EC_WORK_RAM_OUTPUT
		bra	.do_error_code

	.test_failed_write:
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_work_ram_write
		PSUB	print_string
		lda	#EC_WORK_RAM_WRITE

	.do_error_code:

		tfr	a, f		; backup error code
		PSUB	sound_play_byte
		tfr	f, a
		jmp	error_address

; This is a special print error memory function for
; work ram since we are only able to use registers
; during the tests and print errors.
; params:
;  b = actual value
;  e = expected value
;  x = failed address
print_error_work_ram_memory_psub:
		tfr	e, a
		tfr	d, y
		tfr	x, d

		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 2)
		PSUB	print_hex_word

		tfr	y, d
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		PSUB	print_hex_byte

		tfr	y, d
		exg	a, b
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 4)
		PSUB	print_hex_byte

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		ldy	#d_str_address
		PSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 3)
		ldy	#d_str_expected
		PSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 4)
		ldy	#d_str_actual
		PSUB	print_string
		PSUB_RETURN

manual_work_ram_tests:
		ldy	#d_screen_xys_list
		PSUB	print_xy_string_list

		clrd
		std	R_WORK_RAM_PASSES

	.loop_next_pass:
		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		ldd	R_WORK_RAM_PASSES
		PSUB	print_hex_word

		PSUB	auto_work_ram_tests

		lda	REG_INPUT
		bita	#INPUT_B2
		beq	.test_exit

		ldd	R_WORK_RAM_PASSES
		incd
		std	R_WORK_RAM_PASSES
		bra	.loop_next_pass

	.test_exit:
		clr	r_menu_cursor
		jmp	main_menu

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_PASSES_Y, "PASSES"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

; These are padded so we fully overwrite "TESTING WORK RAM"
d_str_work_ram_address:		STRING "WORK RAM ADDRESS"
d_str_work_ram_data:		STRING "WORK RAM DATA   "
d_str_work_ram_march:		STRING "WORK RAM MARCH  "
d_str_work_ram_output:		STRING "WORK RAM OUTPUT "
d_str_work_ram_write:		STRING "WORK RAM WRITE  "

d_str_testing_work_ram: 	STRING "TESTING WORK RAM"
