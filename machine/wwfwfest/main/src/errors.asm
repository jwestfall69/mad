	include "cpu/68000/include/error_codes.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/print_error.inc"
	include "cpu/68000/include/handlers/error.inc"

	include "error_codes.inc"

	global EC_LIST

	section data

EC_LIST:
	EC_ENTRY WORK_RAM_ADDRESS, PRINT_ERROR_MEMORY
	EC_ENTRY WORK_RAM_DATA_LOWER, PRINT_ERROR_MEMORY
	EC_ENTRY WORK_RAM_DATA_UPPER, PRINT_ERROR_MEMORY
	EC_ENTRY WORK_RAM_DATA_BOTH, PRINT_ERROR_MEMORY
	EC_ENTRY WORK_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY
	EC_ENTRY WORK_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY
	EC_ENTRY WORK_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY
	EC_ENTRY WORK_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS
	EC_ENTRY WORK_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS
	EC_ENTRY WORK_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS
	EC_ENTRY WORK_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS
	EC_ENTRY WORK_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS
	EC_ENTRY WORK_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS

	EC_ENTRY BG_RAM_ADDRESS, PRINT_ERROR_MEMORY
	EC_ENTRY BG_RAM_DATA_LOWER, PRINT_ERROR_MEMORY
	EC_ENTRY BG_RAM_DATA_UPPER, PRINT_ERROR_MEMORY
	EC_ENTRY BG_RAM_DATA_BOTH, PRINT_ERROR_MEMORY
	EC_ENTRY BG_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY
	EC_ENTRY BG_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY
	EC_ENTRY BG_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY
	EC_ENTRY BG_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS
	EC_ENTRY BG_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS
	EC_ENTRY BG_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS
	EC_ENTRY BG_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS
	EC_ENTRY BG_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS
	EC_ENTRY BG_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS

	EC_ENTRY FG_SPRITE_RAM_ADDRESS, PRINT_ERROR_MEMORY
	EC_ENTRY FG_SPRITE_RAM_DATA, PRINT_ERROR_MEMORY
	EC_ENTRY FG_SPRITE_RAM_MARCH, PRINT_ERROR_MEMORY
	EC_ENTRY FG_SPRITE_RAM_OUTPUT, PRINT_ERROR_ADDRESS
	EC_ENTRY FG_SPRITE_RAM_WRITE, PRINT_ERROR_ADDRESS

	EC_ENTRY PALETTE_RAM_ADDRESS, PRINT_ERROR_MEMORY
	EC_ENTRY PALETTE_RAM_DATA_LOWER, PRINT_ERROR_MEMORY
	EC_ENTRY PALETTE_RAM_DATA_UPPER, PRINT_ERROR_MEMORY
	EC_ENTRY PALETTE_RAM_DATA_BOTH, PRINT_ERROR_MEMORY
	EC_ENTRY PALETTE_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY
	EC_ENTRY PALETTE_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY
	EC_ENTRY PALETTE_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY
	EC_ENTRY PALETTE_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS
	EC_ENTRY PALETTE_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS
	EC_ENTRY PALETTE_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS
	EC_ENTRY PALETTE_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS
	EC_ENTRY PALETTE_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS
	EC_ENTRY PALETTE_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS

	EC_ENTRY MAD_ROM_CRC32, PRINT_ERROR_CRC32
	EC_ENTRY MAD_ROM_ADDRESS, PRINT_ERROR_HEX_BYTE
	EC_LIST_END

STR_WORK_RAM_ADDRESS:		STRING "WORK RAM ADDRESS"
STR_WORK_RAM_DATA_LOWER:	STRING "WORK RAM DATA (LOWER)"
STR_WORK_RAM_DATA_UPPER:	STRING "WORK RAM DATA (UPPER)"
STR_WORK_RAM_DATA_BOTH:		STRING "WORK RAM DATA (BOTH)"
STR_WORK_RAM_MARCH_LOWER:	STRING "WORK RAM MARCH (LOWER)"
STR_WORK_RAM_MARCH_UPPER:	STRING "WORK RAM MARCH (UPPER)"
STR_WORK_RAM_MARCH_BOTH:	STRING "WORK RAM MARCH (BOTH)"
STR_WORK_RAM_OUTPUT_LOWER:	STRING "WORK RAM DEAD OUTPUT (LOWER)"
STR_WORK_RAM_OUTPUT_UPPER:	STRING "WORK RAM DEAD OUTPUT (UPPER)"
STR_WORK_RAM_OUTPUT_BOTH:	STRING "WORK RAM DEAD OUTPUT (BOTH)"
STR_WORK_RAM_WRITE_LOWER:	STRING "WORK RAM WRITE (LOWER)"
STR_WORK_RAM_WRITE_UPPER:	STRING "WORK RAM WRITE (UPPER)"
STR_WORK_RAM_WRITE_BOTH:	STRING "WORK RAM WRITE (BOTH)"

STR_BG_RAM_ADDRESS:		STRING "BG RAM ADDRESS"
STR_BG_RAM_DATA_LOWER:		STRING "BG RAM DATA (LOWER)"
STR_BG_RAM_DATA_UPPER:		STRING "BG RAM DATA (UPPER)"
STR_BG_RAM_DATA_BOTH:		STRING "BG RAM DATA (BOTH)"
STR_BG_RAM_MARCH_LOWER:		STRING "BG RAM MARCH (LOWER)"
STR_BG_RAM_MARCH_UPPER:		STRING "BG RAM MARCH (UPPER)"
STR_BG_RAM_MARCH_BOTH:		STRING "BG RAM MARCH (BOTH)"
STR_BG_RAM_OUTPUT_LOWER:	STRING "BG RAM DEAD OUTPUT (LOWER)"
STR_BG_RAM_OUTPUT_UPPER:	STRING "BG RAM DEAD OUTPUT (UPPER)"
STR_BG_RAM_OUTPUT_BOTH:		STRING "BG RAM DEAD OUTPUT (BOTH)"
STR_BG_RAM_WRITE_LOWER:		STRING "BG RAM WRITE (LOWER)"
STR_BG_RAM_WRITE_UPPER:		STRING "BG RAM WRITE (UPPER)"
STR_BG_RAM_WRITE_BOTH:		STRING "BG RAM WRITE (BOTH)"

STR_FG_SPRITE_RAM_ADDRESS:	STRING "FG/SPRITE RAM ADDRESS"
STR_FG_SPRITE_RAM_DATA:		STRING "FG/SPRITE RAM DATA"
STR_FG_SPRITE_RAM_MARCH:	STRING "FG/SPRITE RAM MARCH"
STR_FG_SPRITE_RAM_OUTPUT:	STRING "FG/SPRITE RAM DEAD OUTPUT"
STR_FG_SPRITE_RAM_WRITE:	STRING "FG/SPRITE RAM WRITE"

STR_PALETTE_RAM_ADDRESS:	STRING "PALETTE RAM ADDRESS"
STR_PALETTE_RAM_DATA_LOWER:	STRING "PALETTE RAM DATA (LOWER)"
STR_PALETTE_RAM_DATA_UPPER:	STRING "PALETTE RAM DATA (UPPER)"
STR_PALETTE_RAM_DATA_BOTH:	STRING "PALETTE RAM DATA (BOTH)"
STR_PALETTE_RAM_MARCH_LOWER:	STRING "PALETTE RAM MARCH (LOWER)"
STR_PALETTE_RAM_MARCH_UPPER:	STRING "PALETTE RAM MARCH (UPPER)"
STR_PALETTE_RAM_MARCH_BOTH:	STRING "PALETTE RAM MARCH (BOTH)"
STR_PALETTE_RAM_OUTPUT_LOWER:	STRING "PALETTE RAM DEAD OUTPUT (LOWER)"
STR_PALETTE_RAM_OUTPUT_UPPER:	STRING "PALETTE RAM DEAD OUTPUT (UPPER)"
STR_PALETTE_RAM_OUTPUT_BOTH:	STRING "PALETTE RAM DEAD OUTPUT (BOTH)"
STR_PALETTE_RAM_WRITE_LOWER:	STRING "PALETTE RAM WRITE (LOWER)"
STR_PALETTE_RAM_WRITE_UPPER:	STRING "PALETTE RAM WRITE (UPPER)"
STR_PALETTE_RAM_WRITE_BOTH:	STRING "PALETTE RAM WRITE (BOTH)"

STR_MAD_ROM_CRC32:		STRING "MAD ROM CRC32 ERROR"
STR_MAD_ROM_ADDRESS:		STRING "MAD ROM ADDRESS ERROR"