	include "cpu/68000/error_codes.inc"
	include "cpu/68000/error_handler.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/print_error.inc"

	include "error_codes.inc"

	global EC_LIST

	section data

EC_LIST:
	EC_ENTRY FG_RAM_ADDRESS, PRINT_ERROR_MEMORY
	EC_ENTRY FG_RAM_DATA_LOWER, PRINT_ERROR_MEMORY
	EC_ENTRY FG_RAM_DATA_UPPER, PRINT_ERROR_MEMORY
	EC_ENTRY FG_RAM_DATA_BOTH, PRINT_ERROR_MEMORY
	EC_ENTRY FG_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS
	EC_ENTRY FG_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS
	EC_ENTRY FG_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS
	EC_ENTRY FG_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS
	EC_ENTRY FG_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS
	EC_ENTRY FG_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS

	EC_ENTRY WORK_RAM_ADDRESS, PRINT_ERROR_MEMORY
	EC_ENTRY WORK_RAM_DATA_LOWER, PRINT_ERROR_MEMORY
	EC_ENTRY WORK_RAM_DATA_UPPER, PRINT_ERROR_MEMORY
	EC_ENTRY WORK_RAM_DATA_BOTH, PRINT_ERROR_MEMORY
	EC_ENTRY WORK_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS
	EC_ENTRY WORK_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS
	EC_ENTRY WORK_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS
	EC_ENTRY WORK_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS
	EC_ENTRY WORK_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS
	EC_ENTRY WORK_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS
	EC_ENTRY DIAG_ROM_CRC32, PRINT_ERROR_CRC32
	EC_ENTRY DIAG_ROM_ADDRESS, PRINT_ERROR_HEX_BYTE
	EC_LIST_END

STR_FG_RAM_ADDRESS:		STRING "FG RAM ADDRESS"

STR_FG_RAM_DATA_LOWER:		STRING "FG RAM DATA (LOWER)"
STR_FG_RAM_DATA_UPPER:		STRING "FG RAM DATA (UPPER)"
STR_FG_RAM_DATA_BOTH:		STRING "FG RAM DATA (BOTH)"

STR_FG_RAM_OUTPUT_LOWER:	STRING "FG RAM DEAD OUTPUT (LOWER)"
STR_FG_RAM_OUTPUT_UPPER:	STRING "FG RAM DEAD OUTPUT (UPPER)"
STR_FG_RAM_OUTPUT_BOTH:		STRING "FG RAM DEAD OUTPUT (BOTH)"

STR_FG_RAM_WRITE_LOWER:		STRING "FG RAM WRITE (LOWER)"
STR_FG_RAM_WRITE_UPPER:		STRING "FG RAM WRITE (UPPER)"
STR_FG_RAM_WRITE_BOTH:		STRING "FG RAM WRITE (BOTH)"

STR_WORK_RAM_ADDRESS:		STRING "WORK RAM ADDRESS"

STR_WORK_RAM_DATA_LOWER:	STRING "WORK RAM DATA (LOWER)"
STR_WORK_RAM_DATA_UPPER:	STRING "WORK RAM DATA (UPPER)"
STR_WORK_RAM_DATA_BOTH:		STRING "WORK RAM DATA (BOTH)"

STR_WORK_RAM_OUTPUT_LOWER:	STRING "WORK RAM DEAD OUTPUT (LOWER)"
STR_WORK_RAM_OUTPUT_UPPER:	STRING "WORK RAM DEAD OUTPUT (UPPER)"
STR_WORK_RAM_OUTPUT_BOTH:	STRING "WORK RAM DEAD OUTPUT (BOTH)"

STR_WORK_RAM_WRITE_LOWER:	STRING "WORK RAM WRITE (LOWER)"
STR_WORK_RAM_WRITE_UPPER:	STRING "WORK RAM WRITE (UPPER)"
STR_WORK_RAM_WRITE_BOTH:	STRING "WORK RAM WRITE (BOTH)"


STR_DIAG_ROM_CRC32:		STRING "DIAG ROM CRC32 ERROR"
STR_DIAG_ROM_ADDRESS:		STRING "DIAG ROM ADDRESS ERROR"