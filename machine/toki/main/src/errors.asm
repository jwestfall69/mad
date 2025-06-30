	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/print_error.inc"
	include "cpu/68000/include/handlers/error.inc"

	global d_ec_list

	section data
	align 1

d_ec_list:
	EC_ENTRY EC_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_ram_address
	EC_ENTRY EC_RAM_DATA_LOWER, PRINT_ERROR_MEMORY, d_str_ram_data_lower
	EC_ENTRY EC_RAM_DATA_UPPER, PRINT_ERROR_MEMORY, d_str_ram_data_upper
	EC_ENTRY EC_RAM_DATA_BOTH, PRINT_ERROR_MEMORY, d_str_ram_data_both
	EC_ENTRY EC_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY, d_str_ram_march_lower
	EC_ENTRY EC_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY, d_str_ram_march_upper
	EC_ENTRY EC_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY, d_str_ram_march_both
	EC_ENTRY EC_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS, d_str_ram_output_lower
	EC_ENTRY EC_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS, d_str_ram_output_upper
	EC_ENTRY EC_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS, d_str_ram_output_both
	EC_ENTRY EC_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS, d_str_ram_write_lower
	EC_ENTRY EC_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS, d_str_ram_write_upper
	EC_ENTRY EC_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS, d_str_ram_write_both
	EC_ENTRY EC_MAD_ROM_CRC32, PRINT_ERROR_CRC32, d_str_mad_rom_crc32
	EC_ENTRY EC_MAD_ROM_ADDRESS, PRINT_ERROR_HEX_BYTE, d_str_mad_rom_address
	EC_LIST_END

d_str_ram_address:		STRING "RAM ADDRESS"
d_str_ram_data_lower:		STRING "RAM DATA (LOWER)"
d_str_ram_data_upper:		STRING "RAM DATA (UPPER)"
d_str_ram_data_both:		STRING "RAM DATA (BOTH)"
d_str_ram_march_lower:		STRING "RAM MARCH (LOWER)"
d_str_ram_march_upper:		STRING "RAM MARCH (UPPER)"
d_str_ram_march_both:		STRING "RAM MARCH (BOTH)"
d_str_ram_output_lower:		STRING "RAM DEAD OUTPUT (LOWER)"
d_str_ram_output_upper:		STRING "RAM DEAD OUTPUT (UPPER)"
d_str_ram_output_both:		STRING "RAM DEAD OUTPUT (BOTH)"
d_str_ram_write_lower:		STRING "RAM WRITE (LOWER)"
d_str_ram_write_upper:		STRING "RAM WRITE (UPPER)"
d_str_ram_write_both:		STRING "RAM WRITE (BOTH)"

d_str_mad_rom_crc32:		STRING "MAD ROM CRC32 ERROR"
d_str_mad_rom_address:		STRING "MAD ROM ADDRESS ERROR"
