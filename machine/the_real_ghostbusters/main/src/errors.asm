	include "cpu/6309/include/common.inc"
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

	EC_ENTRY EC_BAC06_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_bac06_ram_address
	EC_ENTRY EC_BAC06_RAM_DATA, PRINT_ERROR_MEMORY, d_str_bac06_ram_data
	EC_ENTRY EC_BAC06_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_bac06_ram_march
	EC_ENTRY EC_BAC06_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_bac06_ram_output
	EC_ENTRY EC_BAC06_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_bac06_ram_write

	EC_ENTRY EC_VIDEO_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_video_ram_address
	EC_ENTRY EC_VIDEO_RAM_DATA, PRINT_ERROR_MEMORY, d_str_video_ram_data
	EC_ENTRY EC_VIDEO_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_video_ram_march
	EC_ENTRY EC_VIDEO_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_video_ram_output
	EC_ENTRY EC_VIDEO_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_video_ram_write
	EC_LIST_END

d_str_sprite_ram_address:	STRING "SPRITE RAM ADDRESS"
d_str_sprite_ram_data:		STRING "SPRITE RAM DATA"
d_str_sprite_ram_march:		STRING "SPRITE RAM MARCH"
d_str_sprite_ram_output:	STRING "SPRITE RAM DEAD OUTPUT"
d_str_sprite_ram_write:		STRING "SPRITE RAM WRITE"

d_str_bac06_ram_address:	STRING "BAC06 RAM ADDRESS"
d_str_bac06_ram_data:		STRING "BAC06 RAM DATA"
d_str_bac06_ram_march:		STRING "BAC06 RAM MARCH"
d_str_bac06_ram_output:		STRING "BAC06 RAM DEAD OUTPUT"
d_str_bac06_ram_write:		STRING "BAC06 RAM WRITE"

d_str_video_ram_address:	STRING "VIDEO RAM ADDRESS"
d_str_video_ram_data:		STRING "VIDEO RAM DATA"
d_str_video_ram_march:		STRING "VIDEO RAM MARCH"
d_str_video_ram_output:		STRING "VIDEO RAM DEAD OUTPUT"
d_str_video_ram_write:		STRING "VIDEO RAM WRITE"
