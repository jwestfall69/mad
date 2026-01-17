	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/print_error.inc"
	include "cpu/6x09/include/handlers/error.inc"

	global d_ec_list

	section data

d_ec_list:
	EC_ENTRY EC_PALETTE_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_palette_ram_address
	EC_ENTRY EC_PALETTE_RAM_DATA, PRINT_ERROR_MEMORY, d_str_palette_ram_data
	EC_ENTRY EC_PALETTE_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_palette_ram_march
	EC_ENTRY EC_PALETTE_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_palette_ram_output
	EC_ENTRY EC_PALETTE_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_palette_ram_write

	EC_ENTRY EC_K007121_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_k007121_ram_address
	EC_ENTRY EC_K007121_RAM_DATA, PRINT_ERROR_MEMORY, d_str_k007121_ram_data
	EC_ENTRY EC_K007121_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_k007121_ram_march
	EC_ENTRY EC_K007121_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_k007121_ram_output
	EC_ENTRY EC_K007121_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_k007121_ram_write

	EC_LIST_END

d_str_palette_ram_address:	STRING "PALETTE RAM ADDRESS"
d_str_palette_ram_data:		STRING "PALETTE RAM DATA"
d_str_palette_ram_march:	STRING "PALETTE RAM MARCH"
d_str_palette_ram_output:	STRING "PALETTE RAM DEAD OUTPUT"
d_str_palette_ram_write:	STRING "PALETTE RAM WRITE"

d_str_k007121_ram_address:	STRING "K007121 RAM ADDRESS"
d_str_k007121_ram_data:		STRING "K007121 RAM DATA"
d_str_k007121_ram_march:	STRING "K007121 RAM MARCH"
d_str_k007121_ram_output:	STRING "K007121 RAM DEAD OUTPUT"
d_str_k007121_ram_write:	STRING "K007121 RAM WRITE"
