	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/print_error.inc"

	include "machine.inc"

	global print_error_address
	global print_error_crc32
	global print_error_hex_byte
	global print_error_invalid
	global print_error_memory
	global print_error_string
	global EC_PRINT_LIST
	global PE_DATA_A
	global PE_DATA_B
	global PE_DATA_E
	global PE_DATA_X
	global PE_STRING_ADDR
	global STR_ACTUAL
	global STR_ADDRESS
	global STR_EXPECTED

	section code

; these are print_error functions that get called by error_handler

; params:
;  PE_DATA_X = address
;  PE_STRING_ADDR = error description
print_error_address:

		; address
		SEEK_XY	14, 8
		ldd	PE_DATA_X
		PSUB	print_hex_word

		; error
		SEEK_XY	4, 5
		ldy	PE_STRING_ADDR
		PSUB	print_string

		SEEK_XY	4, 8
		ldy	#STR_ADDRESS
		PSUB	print_string
		rts

print_error_crc32:
		rts

; params:
;  PE_DATA_B = actual value
;  PE_DATA_E = expected value
;  PE_STRING_ADDR = error description
print_error_hex_byte:

		; expected
		SEEK_XY	14, 10
		lda	PE_DATA_E
		PSUB	print_hex_byte

		; actual
		SEEK_XY	14, 8
		lda	PE_DATA_A
		PSUB	print_hex_byte

		SEEK_XY	4, 8
		ldy	#STR_ACTUAL
		PSUB	print_string

		SEEK_XY	4, 10
		ldy	#STR_EXPECTED
		PSUB	print_string
		rts

; params:
;  PE_DATA_A = error code
;  PE_DATA_B = function id
print_error_invalid:

		; error code
		SEEK_XY	20, 6
		lda	PE_DATA_A
		PSUB	print_hex_byte

		; function id
		SEEK_XY	20, 7
		lda	PE_DATA_B
		PSUB	print_hex_byte

		SEEK_XY	2, 4
		ldy	#STR_INVALID_ERROR
		PSUB	print_string

		SEEK_XY	2, 6
		ldy	#STR_ERROR_CODE
		PSUB	print_string

		SEEK_XY	2, 7
		ldy	#STR_PRINT_FUNCTION
		PSUB	print_string
		rts

; params:
;  PE_DATA_B = actual value
;  PE_DATA_E = expected value
;  PE_DATA_X = address
;  PE_STRING_ADDR = error description
print_error_memory:

		; address
		SEEK_XY	14, 8
		ldd	PE_DATA_X
		PSUB	print_hex_word

		; actual
		SEEK_XY	16, 10
		lda	PE_DATA_B
		PSUB	print_hex_byte

		; expected
		SEEK_XY	16, 12
		lda	PE_DATA_E
		PSUB	print_hex_byte

		; description
		SEEK_XY	4, 5
		ldy	PE_STRING_ADDR
		PSUB	print_string

		SEEK_XY	4, 8
		ldy	#STR_ADDRESS
		PSUB	print_string

		SEEK_XY	4, 10
		ldy	#STR_ACTUAL
		PSUB	print_string

		SEEK_XY	4, 12
		ldy	#STR_EXPECTED
		PSUB	print_string
		rts

; params:
;  PE_STRING_ADDR = error description
print_error_string:
		SEEK_XY	4, 5
		ldy	PE_STRING_ADDR
		PSUB	print_string
		rts

	section data

EC_PRINT_LIST:
	EC_PRINT_ENTRY PRINT_ERROR_ADDRESS, print_error_address
	EC_PRINT_ENTRY PRINT_ERROR_CRC32, print_error_crc32
	EC_PRINT_ENTRY PRINT_ERROR_HEX_BYTE, print_error_hex_byte
	EC_PRINT_ENTRY PRINT_ERROR_MEMORY, print_error_memory
	EC_PRINT_ENTRY PRINT_ERROR_STRING, print_error_string
	EC_PRINT_LIST_END

STR_ADDRESS:		string "ADDRESS", CHAR_COLON
STR_ACTUAL:		string "ACTUAL", CHAR_COLON
STR_EXPECTED:		string "EXPECTED", CHAR_COLON

STR_INVALID_ERROR:	string "INVALID ERROR OR PRINT CODE"
STR_ERROR_CODE:		string "ERROR CODE", CHAR_COLON
STR_PRINT_FUNCTION:	string "PRINT FUNCTION", CHAR_COLON

	section bss

; error handler will populate these before calling
; the necessary print_error function.
PE_DATA_A:		blk	1
PE_DATA_B:		blk	1
PE_DATA_E:		blk	1
PE_DATA_X:		blkw	1
PE_STRING_ADDR:		blkw	1
