
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"

	global	auto_work_ram_tests_psub
	global	manual_work_ram_tests

	section code

; do to the limited number of registers on teh 6309 testing
; work ram require some special processing.
auto_work_ram_tests_psub:

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

		SEEK_XY	3, 4
		ldy	#d_str_work_ram_address
		PSUB	print_string

		lda	#EC_WORK_RAM_ADDRESS
		bra	.do_error_code

	.test_failed_data:
		PSUB	print_error_work_ram_memory

		SEEK_XY	3, 4
		ldy	#d_str_work_ram_data
		PSUB	print_string

		lda	#EC_WORK_RAM_DATA
		bra	.do_error_code

	.test_failed_march:
		PSUB	print_error_work_ram_memory

		SEEK_XY	3, 4
		ldy	#d_str_work_ram_march
		PSUB	print_string

		lda	#EC_WORK_RAM_MARCH
		bra	.do_error_code

	.test_failed_output:
		SEEK_XY	3, 4
		ldy	#d_str_work_ram_output
		PSUB	print_string

		lda	#EC_WORK_RAM_OUTPUT
		bra	.do_error_code

	.test_failed_write:
		SEEK_XY	3, 4
		ldy	#d_str_work_ram_write
		PSUB	print_string
		lda	#EC_WORK_RAM_WRITE

	.do_error_code:

		tfr	a, f		; backup error code
		PSUB	sound_play_byte
		tfr	f, a
		;jmp	error_address
		STALL


; We can't use work ram and we don't have enough
; registers to track the number of passes.  So
; we just blindly using part of palette ram to
; do it.
NUM_PASSES		equ PALETTE_RAM_START + PALETTE_SIZE

manual_work_ram_tests:
		ldy	#d_screen_xys_list
		PSUB	print_xy_string_list

		clrd
		std	NUM_PASSES

	.loop_next_pass:
		SEEK_XY	12, 10
		ldd	NUM_PASSES
		PSUB	print_hex_word

		PSUB	auto_work_ram_tests

		lda	REG_INPUT
		bita	#INPUT_B2
		beq	.test_exit

		ldd	NUM_PASSES
		incd
		std	NUM_PASSES
		bra	.loop_next_pass


	.test_exit:
		clr	r_menu_cursor
		jmp	main_menu

	section data

d_screen_xys_list:
	XY_STRING 3, 10, "PASSES"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

; These are padded so we fully overwrite "TESTING WORK RAM"
d_str_work_ram_address:		string "WORK RAM ADDRESS"
d_str_work_ram_data:		string "WORK RAM DATA   "
d_str_work_ram_march:		string "WORK RAM MARCH  "
d_str_work_ram_output:		string "WORK RAM OUTPUT "
d_str_work_ram_write:		string "WORK RAM WRITE  "
