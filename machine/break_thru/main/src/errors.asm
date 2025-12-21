	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/print_error.inc"
	include "cpu/6x09/include/handlers/error.inc"

	global d_ec_list

	section data

d_ec_list:
	EC_ENTRY EC_SPRITE_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_sprite_ram_address
	EC_ENTRY EC_SPRITE_RAM_DATA, PRINT_ERROR_MEMORY, d_str_sprite_ram_data
	EC_ENTRY EC_SPRITE_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_sprite_ram_march
	EC_ENTRY EC_SPRITE_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_sprite_ram_output
	EC_ENTRY EC_SPRITE_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_sprite_ram_write

	EC_ENTRY EC_FG_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_fg_ram_address
	EC_ENTRY EC_FG_RAM_DATA, PRINT_ERROR_MEMORY, d_str_fg_ram_data
	EC_ENTRY EC_FG_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_fg_ram_march
	EC_ENTRY EC_FG_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_fg_ram_output
	EC_ENTRY EC_FG_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_fg_ram_write
	EC_LIST_END

d_str_sprite_ram_address:	STRING "SPRITE RAM ADDRESS"
d_str_sprite_ram_data:		STRING "SPRITE RAM DATA"
d_str_sprite_ram_march:		STRING "SPRITE RAM MARCH"
d_str_sprite_ram_output:	STRING "SPRITE RAM DEAD OUTPUT"
d_str_sprite_ram_write:		STRING "SPRITE RAM WRITE"

d_str_fg_ram_address:		STRING "FG RAM ADDRESS"
d_str_fg_ram_data:		STRING "FG RAM DATA"
d_str_fg_ram_march:		STRING "FG RAM MARCH"
d_str_fg_ram_output:		STRING "FG RAM DEAD OUTPUT"
d_str_fg_ram_write:		STRING "FG RAM WRITE"
