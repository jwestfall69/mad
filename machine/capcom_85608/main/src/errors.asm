	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/print_error.inc"
	include "cpu/z80/include/handlers/error.inc"

	global d_ec_list

	section data

d_ec_list:
	EC_ENTRY EC_BG_TILE_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_bg_tile_ram_address
	EC_ENTRY EC_BG_TILE_RAM_DATA, PRINT_ERROR_MEMORY, d_str_bg_tile_ram_data
	EC_ENTRY EC_BG_TILE_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_bg_tile_ram_march
	EC_ENTRY EC_BG_TILE_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_bg_tile_ram_output
	EC_ENTRY EC_BG_TILE_RAM_WRITE, PRINT_ERROR_HEX_BYTE, d_str_bg_tile_ram_write

	EC_ENTRY EC_FIX_TILE_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_fix_tile_ram_address
	EC_ENTRY EC_FIX_TILE_RAM_DATA, PRINT_ERROR_MEMORY, d_str_fix_tile_ram_data
	EC_ENTRY EC_FIX_TILE_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_fix_tile_ram_march
	EC_ENTRY EC_FIX_TILE_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_fix_tile_ram_output
	EC_ENTRY EC_FIX_TILE_RAM_WRITE, PRINT_ERROR_HEX_BYTE, d_str_fix_tile_ram_write

	EC_LIST_END

d_str_bg_tile_ram_address:		STRING "BG TILE RAM ADDRESS"
d_str_bg_tile_ram_data:			STRING "BG TILE RAM DATA"
d_str_bg_tile_ram_march:		STRING "BG TILE RAM MARCH"
d_str_bg_tile_ram_output:		STRING "BG TILE RAM DEAD OUTPUT"
d_str_bg_tile_ram_write:		STRING "BG TILE RAM WRITE"

d_str_fix_tile_ram_address:		STRING "FIX TILE RAM ADDRESS"
d_str_fix_tile_ram_data:		STRING "FIX TILE RAM DATA"
d_str_fix_tile_ram_march:		STRING "FIX TILE RAM MARCH"
d_str_fix_tile_ram_output:		STRING "FIX TILE RAM DEAD OUTPUT"
d_str_fix_tile_ram_write:		STRING "FIX TILE RAM WRITE"
