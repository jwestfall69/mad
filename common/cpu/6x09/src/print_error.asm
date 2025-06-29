	include "global/include/macros.inc"
	include "global/include/screen.inc"

	include "cpu/6x09/include/dsub.inc"
	include "cpu/6x09/include/macros.inc"
	include "cpu/6x09/include/print_error.inc"

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
	global r_pe_data_x
	global r_pe_data_y
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
		RSUB	print_string

		; address
		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 2)
		ldd	r_pe_data_x
		RSUB	print_hex_word

		SEEK_XY	SCREEN_START_Y, (SCREEN_START_Y + 2)
		ldy	#d_str_address
		RSUB	print_string
		rts

; params:
;  r_pe_data_b = actual value
;  r_pe_data_y = expected value (lower byte)
;  r_pe_string_ptr = error description
print_error_hex_byte:

		; error
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	r_pe_string_ptr
		RSUB	print_string

		; expected
		SEEK_XY (SCREEN_START_X + 12), (SCREEN_START_Y + 2)
		lda	r_pe_data_y + 1
		RSUB	print_hex_byte

		; actual
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		lda	r_pe_data_a
		RSUB	print_hex_byte

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		ldy	#d_str_expected
		RSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 3)
		ldy	#d_str_actual
		RSUB	print_string
		rts

; params:
;  r_pe_data_a = error code
;  r_pe_data_b = function id
print_error_invalid:

		; error code
		SEEK_XY	(SCREEN_START_X + 16), (SCREEN_START_Y + 2)
		lda	r_pe_data_a
		RSUB	print_hex_byte

		; function id
		SEEK_XY	(SCREEN_START_X + 16), (SCREEN_START_Y + 3)
		lda	r_pe_data_b
		RSUB	print_hex_byte

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_invalid_error
		RSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		ldy	#d_str_error_code
		RSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 3)
		ldy	#d_str_print_function
		RSUB	print_string
		rts

; params:
;  r_pe_data_b = actual value
;  r_pe_data_x = address
;  r_pe_data_y = expected value (lower byte)
;  r_pe_string_ptr = error description
print_error_memory:

		; description
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	r_pe_string_ptr
		RSUB	print_string

		; address
		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 2)
		ldd	r_pe_data_x
		RSUB	print_hex_word

		; expected
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		lda	r_pe_data_y + 1
		RSUB	print_hex_byte

		; actual
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 4)
		lda	r_pe_data_b
		RSUB	print_hex_byte

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		ldy	#d_str_address
		RSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 3)
		ldy	#d_str_expected
		RSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 4)
		ldy	#d_str_actual
		RSUB	print_string
		rts

; params:
;  r_pe_string_ptr = error description
print_error_string:
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	r_pe_string_ptr
		RSUB	print_string
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
r_pe_data_a:		dcb.b 1
r_pe_data_b:		dcb.b 1
r_pe_data_x:		dcb.w 1
r_pe_data_y:		dcb.w 1
r_pe_string_ptr:	dcb.w 1
