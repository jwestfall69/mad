	include "global/include/macros.inc"
	include "cpu/konami/include/error_codes.inc"
	include "cpu/konami/include/macros.inc"
	include "cpu/konami/include/print_error.inc"
	include "cpu/konami/include/handlers/error.inc"

	include "error_codes.inc"

	global d_ec_list

	section data

d_ec_list:
	EC_ENTRY EC_PALETTE_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_palette_ram_address
	EC_ENTRY EC_PALETTE_RAM_DATA, PRINT_ERROR_MEMORY, d_str_palette_ram_data
	EC_ENTRY EC_PALETTE_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_palette_ram_march
	EC_ENTRY EC_PALETTE_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_palette_ram_output
	EC_ENTRY EC_PALETTE_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_palette_ram_write

	EC_ENTRY EC_TILE1_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_tile1_ram_address
	EC_ENTRY EC_TILE1_RAM_DATA, PRINT_ERROR_MEMORY, d_str_tile1_ram_data
	EC_ENTRY EC_TILE1_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_tile1_ram_march
	EC_ENTRY EC_TILE1_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_tile1_ram_output
	EC_ENTRY EC_TILE1_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_tile1_ram_write

	EC_ENTRY EC_TILE2_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_tile2_ram_address
	EC_ENTRY EC_TILE2_RAM_DATA, PRINT_ERROR_MEMORY, d_str_tile2_ram_data
	EC_ENTRY EC_TILE2_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_tile2_ram_march
	EC_ENTRY EC_TILE2_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_tile2_ram_output
	EC_ENTRY EC_TILE2_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_tile2_ram_write

	EC_ENTRY EC_SPRITE_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_sprite_ram_address
	EC_ENTRY EC_SPRITE_RAM_DATA, PRINT_ERROR_MEMORY, d_str_sprite_ram_data
	EC_ENTRY EC_SPRITE_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_sprite_ram_march
	EC_ENTRY EC_SPRITE_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_sprite_ram_output
	EC_ENTRY EC_SPRITE_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_sprite_ram_write

	EC_LIST_END

d_str_palette_ram_address:	STRING "PALETTE RAM ADDRESS"
d_str_palette_ram_data:		STRING "PALETTE RAM DATA"
d_str_palette_ram_march:	STRING "PALETTE RAM MARCH"
d_str_palette_ram_output:	STRING "PALETTE RAM DEAD OUTPUT"
d_str_palette_ram_write:	STRING "PALETTE RAM WRITE"

d_str_tile1_ram_address:	STRING "TILE1 RAM ADDRESS"
d_str_tile1_ram_data:		STRING "TILE1 RAM DATA"
d_str_tile1_ram_march:		STRING "TILE1 RAM MARCH"
d_str_tile1_ram_output:		STRING "TILE1 RAM DEAD OUTPUT"
d_str_tile1_ram_write:		STRING "TILE1 RAM WRITE"

d_str_tile2_ram_address:	STRING "TILE2 RAM ADDRESS"
d_str_tile2_ram_data:		STRING "TILE2 RAM DATA"
d_str_tile2_ram_march:		STRING "TILE2 RAM MARCH"
d_str_tile2_ram_output:		STRING "TILE2 RAM DEAD OUTPUT"
d_str_tile2_ram_write:		STRING "TILE2 RAM WRITE"

d_str_sprite_ram_address:	STRING "SPRITE RAM ADDRESS"
d_str_sprite_ram_data:		STRING "SPRITE RAM DATA"
d_str_sprite_ram_march:		STRING "SPRITE RAM MARCH"
d_str_sprite_ram_output:	STRING "SPRITE RAM DEAD OUTPUT"
d_str_sprite_ram_write:		STRING "SPRITE RAM WRITE"
