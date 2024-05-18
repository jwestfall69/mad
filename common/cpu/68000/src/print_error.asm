	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/print_error.inc"

	include "machine.inc"

	global print_error_address_dsub
	global print_error_crc32_dsub
	global print_error_hex_byte_dsub
	global print_error_invalid_dsub
	global print_error_memory_dsub
	global print_error_string_dsub
	global EC_PRINT_LIST

	section code
; these are print_error functions that get called by error_handler

; params:
;  a0 = address
;  a1 = error description
print_error_address_dsub:
		; address value
		SEEK_XY	14, 8
		move.l	a0, d0
		DSUB	print_hex_3_bytes

		; error description
		SEEK_XY	4, 5
		movea.l	a1, a0
		DSUB	print_string

		SEEK_XY	4, 8
		lea	STR_ADDRESS, a0
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
		SEEK_XY	14, 10
		move.l	d1, d0
		DSUB	print_hex_long

		; actual value
		SEEK_XY	14, 8
		move.l	d4, d0
		DSUB	print_hex_long

		SEEK_LN	5
		DSUB	print_clear_line

		; error description
		SEEK_XY	4, 5
		movea.l	a1, a0
		DSUB	print_string

		SEEK_XY	4, 8
		lea	STR_ACTUAL, a0
		DSUB	print_string

		SEEK_XY	4, 10
		lea	STR_EXPECTED, a0
		DSUB	print_string
		DSUB_RETURN


; params:
;  d0 = error code
;  d1 = expected data
;  d2 = actual data
;  a1 = error description
print_error_hex_byte_dsub:

		; expected value
		SEEK_XY	14, 10
		move.b	d1, d0
		DSUB	print_hex_byte

		; actual value
		SEEK_XY	14, 8
		move.b	d2, d0
		DSUB	print_hex_byte

		SEEK_LN	5
		DSUB	print_clear_line

		; error description
		SEEK_XY	4, 5
		movea.l	a1, a0
		DSUB	print_string

		SEEK_XY	4, 8
		lea	STR_ACTUAL, a0
		DSUB	print_string

		SEEK_XY	4, 10
		lea	STR_EXPECTED, a0
		DSUB	print_string
		DSUB_RETURN


; params:
;  d0 = error_code
;  d1 = print dsub id
print_error_invalid_dsub:
		move.b	d1, d4

		; error code
		SEEK_XY	20, 6
		DSUB	print_hex_byte

		; print dsub id
		SEEK_XY	20, 7
		move.b	d4, d0
		DSUB	print_hex_byte

		SEEK_LN	5
		DSUB	print_clear_line

		SEEK_XY	2, 4
		lea	STR_INVALID_ERROR, a0
		DSUB	print_string

		SEEK_XY	2, 6
		lea	STR_ERROR_CODE, a0
		DSUB	print_string

		SEEK_XY	2, 7
		lea	STR_PRINT_FUNCTION, a0
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
		SEEK_XY	14, 8
		move.l	a0, d0
		DSUB	print_hex_3_bytes

		; actual value
		SEEK_XY	14, 10
		move.w	d4, d0
		DSUB	print_hex_word

		; expected value
		SEEK_XY	14, 12
		move.w	d3, d0
		DSUB	print_hex_word

		SEEK_LN	5
		DSUB	print_clear_line

		; error description
		SEEK_XY	4, 5
		movea.l	a1, a0
		DSUB	print_string

		SEEK_XY	4, 8
		lea	STR_ADDRESS, a0
		DSUB	print_string

		SEEK_XY	4, 10
		lea	STR_ACTUAL, a0
		DSUB	print_string

		SEEK_XY	4, 12
		lea	STR_EXPECTED, a0
		DSUB	print_string
		DSUB_RETURN

; params:
;  a1 = error description
print_error_string_dsub:
		SEEK_XY	4, 5
		movea.l	a1, a0
		DSUB	print_string
		DSUB_RETURN

	section data

EC_PRINT_LIST:
	EC_PRINT_ENTRY PRINT_ERROR_ADDRESS, print_error_address_dsub
	EC_PRINT_ENTRY PRINT_ERROR_CRC32, print_error_crc32_dsub
	EC_PRINT_ENTRY PRINT_ERROR_HEX_BYTE, print_error_hex_byte_dsub
	EC_PRINT_ENTRY PRINT_ERROR_MEMORY, print_error_memory_dsub
	EC_PRINT_ENTRY PRINT_ERROR_STRING, print_error_string_dsub
	EC_PRINT_LIST_END

STR_ADDRESS:		STRING <"ADDRESS", CHAR_COLON>
STR_ACTUAL:		STRING <"ACTUAL", CHAR_COLON>
STR_EXPECTED:		STRING <"EXPECTED", CHAR_COLON>

STR_INVALID_ERROR:	STRING "INVALID ERROR OR PRINT CODE"
STR_ERROR_CODE:		STRING <"ERROR CODE", CHAR_COLON>
STR_PRINT_FUNCTION:	STRING <"PRINT FUNCTION", CHAR_COLON>
