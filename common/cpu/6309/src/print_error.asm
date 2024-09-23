	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/print_error.inc"
	include "global/include/screen.inc"

	include "machine.inc"

	global print_error_address
	global print_error_hex_byte
	global print_error_invalid
	global print_error_memory
	global print_error_string
	global d_ec_print_list
	global d_str_actual
	global d_str_address
	global d_str_expected
	global r_pe_data_a
	global r_pe_data_b
	global r_pe_data_e
	global r_pe_data_x
	global r_pe_string_ptr

	section code

; these are print_error functions that get called by error_handler

; params:
;  r_pe_data_x = address
;  r_pe_string_ptr = error description
print_error_address:

		; error
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	r_pe_string_ptr
		PSUB	print_string

		; address
		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 2)
		ldd	r_pe_data_x
		PSUB	print_hex_word

		SEEK_XY	SCREEN_START_Y, (SCREEN_START_Y + 2)
		ldy	#d_str_address
		PSUB	print_string
		rts

; params:
;  r_pe_data_b = actual value
;  r_pe_data_e = expected value
;  r_pe_string_ptr = error description
print_error_hex_byte:

		; error
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	r_pe_string_ptr
		PSUB	print_string

		; expected
		SEEK_XY (SCREEN_START_X + 12), (SCREEN_START_Y + 2)
		lda	r_pe_data_e
		PSUB	print_hex_byte

		; actual
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		lda	r_pe_data_a
		PSUB	print_hex_byte

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		ldy	#d_str_expected
		PSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 3)
		ldy	#d_str_actual
		PSUB	print_string
		rts

; params:
;  r_pe_data_a = error code
;  r_pe_data_b = function id
print_error_invalid:

		; error code
		SEEK_XY	(SCREEN_START_X + 16), (SCREEN_START_Y + 2)
		lda	r_pe_data_a
		PSUB	print_hex_byte

		; function id
		SEEK_XY	(SCREEN_START_X + 16), (SCREEN_START_Y + 3)
		lda	r_pe_data_b
		PSUB	print_hex_byte

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_invalid_error
		PSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		ldy	#d_str_error_code
		PSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 3)
		ldy	#d_str_print_function
		PSUB	print_string
		rts

; params:
;  r_pe_data_b = actual value
;  r_pe_data_e = expected value
;  r_pe_data_x = address
;  r_pe_string_ptr = error description
print_error_memory:

		; description
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	r_pe_string_ptr
		PSUB	print_string

		; address
		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 2)
		ldd	r_pe_data_x
		PSUB	print_hex_word

		; expected
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		lda	r_pe_data_e
		PSUB	print_hex_byte

		; actual
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 4)
		lda	r_pe_data_b
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
		rts

; params:
;  r_pe_string_ptr = error description
print_error_string:
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	r_pe_string_ptr
		PSUB	print_string
		rts

	section data

d_ec_print_list:
	EC_PRINT_ENTRY PRINT_ERROR_ADDRESS, print_error_address
	EC_PRINT_ENTRY PRINT_ERROR_HEX_BYTE, print_error_hex_byte
	EC_PRINT_ENTRY PRINT_ERROR_MEMORY, print_error_memory
	EC_PRINT_ENTRY PRINT_ERROR_STRING, print_error_string
	EC_PRINT_LIST_END

d_str_address:		STRING "ADDRESS", CHAR_COLON
d_str_actual:		STRING "ACTUAL", CHAR_COLON
d_str_expected:		STRING "EXPECTED", CHAR_COLON

d_str_invalid_error:	STRING "INVALID ERROR OR PRINT CODE"
d_str_error_code:	STRING "ERROR CODE", CHAR_COLON
d_str_print_function:	STRING "PRINT FUNCTION", CHAR_COLON

	section bss

; error handler will populate these before calling
; the necessary print_error function.
r_pe_data_a:		dc.b $0
r_pe_data_b:		dc.b $0
r_pe_data_e:		dc.b $0
r_pe_data_x:		dc.w $0
r_pe_string_ptr:	dc.w $0
