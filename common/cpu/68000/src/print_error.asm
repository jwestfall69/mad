	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/print_error.inc"
	include "global/include/screen.inc"

	include "machine.inc"

	global print_error_address_dsub
	global print_error_crc32_dsub
	global print_error_hex_byte_dsub
	global print_error_invalid_dsub
	global print_error_memory_dsub
	global print_error_string_dsub
	global d_ec_print_list

	section code
; these are print_error functions that get called by error_handler

; params:
;  a0 = address
;  a1 = error description
print_error_address_dsub:
		; address value
		SEEK_XY	SCREEN_START_Y, (SCREEN_START_Y + 2)
		move.l	a0, d0
		DSUB	print_hex_3_bytes

		; error description
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		movea.l	a1, a0
		DSUB	print_string

		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 2)
		lea	d_str_address, a0
		DSUB	print_string

		DSUB_RETURN

; params:
;  d0 = error
;  d1 = expected crc32
;  d2 = actual crc32
;  a1 = error description
print_error_crc32_dsub:
		move.l	d2, d4

		; expected value
		SEEK_XY (SCREEN_START_X + 12), (SCREEN_START_Y + 2)
		move.l	d1, d0
		DSUB	print_hex_long

		; actual value
		SEEK_XY (SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		move.l	d4, d0
		DSUB	print_hex_long

		SEEK_LN	SCREEN_START_Y
		DSUB	print_clear_line

		; error description
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		movea.l	a1, a0
		DSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		lea	d_str_expected, a0
		DSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 3)
		lea	d_str_actual, a0
		DSUB	print_string
		DSUB_RETURN


; params:
;  d0 = error code
;  d1 = expected data
;  d2 = actual data
;  a1 = error description
print_error_hex_byte_dsub:

		; expected value
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 2)
		move.b	d1, d0
		DSUB	print_hex_byte

		; actual value
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		move.b	d2, d0
		DSUB	print_hex_byte

		SEEK_LN	SCREEN_START_Y
		DSUB	print_clear_line

		; error description
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		movea.l	a1, a0
		DSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		lea	d_str_expected, a0
		DSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 3)
		lea	d_str_actual, a0
		DSUB	print_string
		DSUB_RETURN


; params:
;  d0 = error_code
;  d1 = print dsub id
print_error_invalid_dsub:
		move.b	d1, d4

		; error code
		SEEK_XY	(SCREEN_START_X + 16), (SCREEN_START_Y + 2)
		DSUB	print_hex_byte

		; print dsub id
		SEEK_XY	(SCREEN_START_X + 16), (SCREEN_START_Y + 3)
		move.b	d4, d0
		DSUB	print_hex_byte

		SEEK_LN	SCREEN_START_Y
		DSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		lea	d_str_invalid_error, a0
		DSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		lea	d_str_error_code, a0
		DSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 3)
		lea	d_str_print_function, a0
		DSUB	print_string
		DSUB_RETURN

; params:
;  d0 = error code
;  d1 = expected value
;  d2 = actual value
;  a0 = address
;  a1 = error description
print_error_memory_dsub:
		move.w	d1, d3
		move.w	d2, d4

		; address value
		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 2)
		move.l	a0, d0
		DSUB	print_hex_3_bytes

		; expected value
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 3)
		move.w	d3, d0
		DSUB	print_hex_word

		; actual value
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 4)
		move.w	d4, d0
		DSUB	print_hex_word

		SEEK_LN	SCREEN_START_Y
		DSUB	print_clear_line

		; error description
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		movea.l	a1, a0
		DSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		lea	d_str_address, a0
		DSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 3)
		lea	d_str_expected, a0
		DSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 4)
		lea	d_str_actual, a0
		DSUB	print_string
		DSUB_RETURN

; params:
;  a1 = error description
print_error_string_dsub:
		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		movea.l	a1, a0
		DSUB	print_string
		DSUB_RETURN

	section data
	align 2

d_ec_print_list:
	EC_PRINT_ENTRY PRINT_ERROR_ADDRESS, print_error_address_dsub
	EC_PRINT_ENTRY PRINT_ERROR_CRC32, print_error_crc32_dsub
	EC_PRINT_ENTRY PRINT_ERROR_HEX_BYTE, print_error_hex_byte_dsub
	EC_PRINT_ENTRY PRINT_ERROR_MEMORY, print_error_memory_dsub
	EC_PRINT_ENTRY PRINT_ERROR_STRING, print_error_string_dsub
	EC_PRINT_LIST_END

d_str_address:		STRING <"ADDRESS", CHAR_COLON>
d_str_actual:		STRING <"ACTUAL", CHAR_COLON>
d_str_expected:		STRING <"EXPECTED", CHAR_COLON>

d_str_invalid_error:	STRING "INVALID ERROR OR PRINT CODE"
d_str_error_code:	STRING <"ERROR CODE", CHAR_COLON>
d_str_print_function:	STRING <"PRINT FUNCTION", CHAR_COLON>
