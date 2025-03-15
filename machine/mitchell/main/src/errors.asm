	include "global/include/macros.inc"
	include "cpu/z80/include/error_codes.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/print_error.inc"
	include "cpu/z80/include/handlers/error.inc"

	include "error_codes.inc"

	global d_ec_list

	section data

d_ec_list:
	EC_ENTRY EC_COLOR_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_color_ram_address
	EC_ENTRY EC_COLOR_RAM_DATA, PRINT_ERROR_MEMORY, d_str_color_ram_data
	EC_ENTRY EC_COLOR_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_color_ram_march
	EC_ENTRY EC_COLOR_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_color_ram_output
	EC_ENTRY EC_COLOR_RAM_WRITE, PRINT_ERROR_HEX_BYTE, d_str_color_ram_write

	EC_ENTRY EC_OBJECT_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_object_ram_address
	EC_ENTRY EC_OBJECT_RAM_DATA, PRINT_ERROR_MEMORY, d_str_object_ram_data
	EC_ENTRY EC_OBJECT_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_object_ram_march
	EC_ENTRY EC_OBJECT_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_object_ram_output
	EC_ENTRY EC_OBJECT_RAM_WRITE, PRINT_ERROR_HEX_BYTE, d_str_object_ram_write

	EC_ENTRY EC_TILE_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_tile_ram_address
	EC_ENTRY EC_TILE_RAM_DATA, PRINT_ERROR_MEMORY, d_str_tile_ram_data
	EC_ENTRY EC_TILE_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_tile_ram_march
	EC_ENTRY EC_TILE_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_tile_ram_output
	EC_ENTRY EC_TILE_RAM_WRITE, PRINT_ERROR_HEX_BYTE, d_str_tile_ram_write
	EC_LIST_END

d_str_color_ram_address:	STRING "COLOR RAM ADDRESS"
d_str_color_ram_data:		STRING "COLOR RAM DATA"
d_str_color_ram_march:		STRING "COLOR RAM MARCH"
d_str_color_ram_output:		STRING "COLOR RAM DEAD OUTPUT"
d_str_color_ram_write:		STRING "COLOR RAM WRITE"


d_str_object_ram_address:	STRING "OBJECT RAM ADDRESS"
d_str_object_ram_data:		STRING "OBJECT RAM DATA"
d_str_object_ram_march:		STRING "OBJECT RAM MARCH"
d_str_object_ram_output:	STRING "OBJECT RAM DEAD OUTPUT"
d_str_object_ram_write:		STRING "OBJECT RAM WRITE"

d_str_tile_ram_address:	STRING "TILE RAM ADDRESS"
d_str_tile_ram_data:		STRING "TILE RAM DATA"
d_str_tile_ram_march:		STRING "TILE RAM MARCH"
d_str_tile_ram_output:		STRING "TILE RAM DEAD OUTPUT"
d_str_tile_ram_write:		STRING "TILE RAM WRITE"

