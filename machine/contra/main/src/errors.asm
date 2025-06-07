	include "global/include/macros.inc"
	include "cpu/6309/include/error_codes.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/print_error.inc"
	include "cpu/6309/include/handlers/error.inc"

	include "error_codes.inc"

	global d_ec_list

	section data

d_ec_list:
	EC_ENTRY EC_PALETTE_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_palette_ram_address
	EC_ENTRY EC_PALETTE_RAM_DATA, PRINT_ERROR_MEMORY, d_str_palette_ram_data
	EC_ENTRY EC_PALETTE_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_palette_ram_march
	EC_ENTRY EC_PALETTE_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_palette_ram_output
	EC_ENTRY EC_PALETTE_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_palette_ram_write

	EC_ENTRY EC_K007121_10E_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_k007121_10e_ram_address
	EC_ENTRY EC_K007121_10E_RAM_DATA, PRINT_ERROR_MEMORY, d_str_k007121_10e_ram_data
	EC_ENTRY EC_K007121_10E_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_k007121_10e_ram_march
	EC_ENTRY EC_K007121_10E_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_k007121_10e_ram_output
	EC_ENTRY EC_K007121_10E_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_k007121_10e_ram_write

	EC_ENTRY EC_K007121_18E_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_k007121_18e_ram_address
	EC_ENTRY EC_K007121_18E_RAM_DATA, PRINT_ERROR_MEMORY, d_str_k007121_18e_ram_data
	EC_ENTRY EC_K007121_18E_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_k007121_18e_ram_march
	EC_ENTRY EC_K007121_18E_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_k007121_18e_ram_output
	EC_ENTRY EC_K007121_18E_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_k007121_18e_ram_write

	EC_LIST_END

d_str_palette_ram_address:	STRING "PALETTE RAM ADDRESS"
d_str_palette_ram_data:		STRING "PALETTE RAM DATA"
d_str_palette_ram_march:	STRING "PALETTE RAM MARCH"
d_str_palette_ram_output:	STRING "PALETTE RAM DEAD OUTPUT"
d_str_palette_ram_write:	STRING "PALETTE RAM WRITE"

d_str_k007121_10e_ram_address:	STRING "K007121 10E RAM ADDRESS"
d_str_k007121_10e_ram_data:	STRING "K007121 10E RAM DATA"
d_str_k007121_10e_ram_march:	STRING "K007121 10E RAM MARCH"
d_str_k007121_10e_ram_output:	STRING "K007121 10E RAM DEAD OUTPUT"
d_str_k007121_10e_ram_write:	STRING "K007121 10E RAM WRITE"

d_str_k007121_18e_ram_address:	STRING "K007121 18E RAM ADDRESS"
d_str_k007121_18e_ram_data:	STRING "K007121 18E RAM DATA"
d_str_k007121_18e_ram_march:	STRING "K007121 18E RAM MARCH"
d_str_k007121_18e_ram_output:	STRING "K007121 18E RAM DEAD OUTPUT"
d_str_k007121_18e_ram_write:	STRING "K007121 18E RAM WRITE"
