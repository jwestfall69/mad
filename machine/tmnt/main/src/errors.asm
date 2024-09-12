	include "cpu/68000/include/error_codes.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/print_error.inc"
	include "cpu/68000/include/handlers/error.inc"

	include "error_codes.inc"

	global d_ec_list

	section data
	align 2

d_ec_list:
	EC_ENTRY EC_WORK_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_work_ram_address
	EC_ENTRY EC_WORK_RAM_DATA_LOWER, PRINT_ERROR_MEMORY, d_str_work_ram_data_lower
	EC_ENTRY EC_WORK_RAM_DATA_UPPER, PRINT_ERROR_MEMORY, d_str_work_ram_data_upper
	EC_ENTRY EC_WORK_RAM_DATA_BOTH, PRINT_ERROR_MEMORY, d_str_work_ram_data_both
	EC_ENTRY EC_WORK_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY, d_str_work_ram_march_lower
	EC_ENTRY EC_WORK_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY, d_str_work_ram_march_upper
	EC_ENTRY EC_WORK_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY, d_str_work_ram_march_both
	EC_ENTRY EC_WORK_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS, d_str_work_ram_output_lower
	EC_ENTRY EC_WORK_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS, d_str_work_ram_output_upper
	EC_ENTRY EC_WORK_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS, d_str_work_ram_output_both
	EC_ENTRY EC_WORK_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS, d_str_work_ram_write_lower
	EC_ENTRY EC_WORK_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS, d_str_work_ram_write_upper
	EC_ENTRY EC_WORK_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS, d_str_work_ram_write_both

	EC_ENTRY EC_PALETTE_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_palette_ram_address
	EC_ENTRY EC_PALETTE_RAM_DATA, PRINT_ERROR_MEMORY, d_str_palette_ram_data
	EC_ENTRY EC_PALETTE_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_palette_ram_march
	EC_ENTRY EC_PALETTE_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_palette_ram_output
	EC_ENTRY EC_PALETTE_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_palette_ram_write

	EC_ENTRY EC_TILE_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_tile_ram_address
	EC_ENTRY EC_TILE_RAM_DATA_LOWER, PRINT_ERROR_MEMORY, d_str_tile_ram_data_lower
	EC_ENTRY EC_TILE_RAM_DATA_UPPER, PRINT_ERROR_MEMORY, d_str_tile_ram_data_upper
	EC_ENTRY EC_TILE_RAM_DATA_BOTH, PRINT_ERROR_MEMORY, d_str_tile_ram_data_both
	EC_ENTRY EC_TILE_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY, d_str_tile_ram_march_lower
	EC_ENTRY EC_TILE_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY, d_str_tile_ram_march_upper
	EC_ENTRY EC_TILE_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY, d_str_tile_ram_march_both
	EC_ENTRY EC_TILE_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS, d_str_tile_ram_output_lower
	EC_ENTRY EC_TILE_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS, d_str_tile_ram_output_upper
	EC_ENTRY EC_TILE_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS, d_str_tile_ram_output_both
	EC_ENTRY EC_TILE_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS, d_str_tile_ram_write_lower
	EC_ENTRY EC_TILE_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS, d_str_tile_ram_write_upper
	EC_ENTRY EC_TILE_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS, d_str_tile_ram_write_both

	EC_ENTRY EC_MAD_ROM_CRC32, PRINT_ERROR_CRC32, d_str_mad_rom_crc32
	EC_ENTRY EC_MAD_ROM_ADDRESS, PRINT_ERROR_HEX_BYTE, d_str_mad_rom_address
	EC_LIST_END

d_str_work_ram_address:			STRING "WORK RAM ADDRESS"
d_str_work_ram_data_lower:		STRING "WORK RAM DATA (LOWER)"
d_str_work_ram_data_upper:		STRING "WORK RAM DATA (UPPER)"
d_str_work_ram_data_both:		STRING "WORK RAM DATA (BOTH)"
d_str_work_ram_march_lower:		STRING "WORK RAM MARCH (LOWER)"
d_str_work_ram_march_upper:		STRING "WORK RAM MARCH (UPPER)"
d_str_work_ram_march_both:		STRING "WORK RAM MARCH (BOTH)"
d_str_work_ram_output_lower:		STRING "WORK RAM DEAD OUTPUT (LOWER)"
d_str_work_ram_output_upper:		STRING "WORK RAM DEAD OUTPUT (UPPER)"
d_str_work_ram_output_both:		STRING "WORK RAM DEAD OUTPUT (BOTH)"
d_str_work_ram_write_lower:		STRING "WORK RAM WRITE (LOWER)"
d_str_work_ram_write_upper:		STRING "WORK RAM WRITE (UPPER)"
d_str_work_ram_write_both:		STRING "WORK RAM WRITE (BOTH)"

d_str_palette_ram_address:		STRING "PALETTE RAM ADDRESS"
d_str_palette_ram_data:			STRING "PALETTE RAM DATA"
d_str_palette_ram_march:		STRING "PALETTE RAM MARCH"
d_str_palette_ram_output:		STRING "PALETTE RAM DEAD OUTPUT"
d_str_palette_ram_write:		STRING "PALETTE RAM WRITE"

d_str_tile_ram_address:			STRING "TILE RAM ADDRESS"
d_str_tile_ram_data_lower:		STRING "TILE RAM DATA (LOWER)"
d_str_tile_ram_data_upper:		STRING "TILE RAM DATA (UPPER)"
d_str_tile_ram_data_both:		STRING "TILE RAM DATA (BOTH)"
d_str_tile_ram_march_lower:		STRING "TILE RAM MARCH (LOWER)"
d_str_tile_ram_march_upper:		STRING "TILE RAM MARCH (UPPER)"
d_str_tile_ram_march_both:		STRING "TILE RAM MARCH (BOTH)"
d_str_tile_ram_output_lower:		STRING "TILE RAM DEAD OUTPUT (LOWER)"
d_str_tile_ram_output_upper:		STRING "TILE RAM DEAD OUTPUT (UPPER)"
d_str_tile_ram_output_both:		STRING "TILE RAM DEAD OUTPUT (BOTH)"
d_str_tile_ram_write_lower:		STRING "TILE RAM WRITE (LOWER)"
d_str_tile_ram_write_upper:		STRING "TILE RAM WRITE (UPPER)"
d_str_tile_ram_write_both:		STRING "TILE RAM WRITE (BOTH)"

d_str_mad_rom_crc32:			STRING "MAD ROM CRC32 ERROR"
d_str_mad_rom_address:			STRING "MAD ROM ADDRESS ERROR"
