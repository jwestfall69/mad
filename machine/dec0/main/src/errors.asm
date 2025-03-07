	include "global/include/macros.inc"
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
	EC_ENTRY EC_PALETTE_RAM_DATA_LOWER, PRINT_ERROR_MEMORY, d_str_palette_ram_data_lower
	EC_ENTRY EC_PALETTE_RAM_DATA_UPPER, PRINT_ERROR_MEMORY, d_str_palette_ram_data_upper
	EC_ENTRY EC_PALETTE_RAM_DATA_BOTH, PRINT_ERROR_MEMORY, d_str_palette_ram_data_both
	EC_ENTRY EC_PALETTE_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY, d_str_palette_ram_march_lower
	EC_ENTRY EC_PALETTE_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY, d_str_palette_ram_march_upper
	EC_ENTRY EC_PALETTE_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY, d_str_palette_ram_march_both
	EC_ENTRY EC_PALETTE_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS, d_str_palette_ram_output_lower
	EC_ENTRY EC_PALETTE_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS, d_str_palette_ram_output_upper
	EC_ENTRY EC_PALETTE_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS, d_str_palette_ram_output_both
	EC_ENTRY EC_PALETTE_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS, d_str_palette_ram_write_lower
	EC_ENTRY EC_PALETTE_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS, d_str_palette_ram_write_upper
	EC_ENTRY EC_PALETTE_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS, d_str_palette_ram_write_both

	EC_ENTRY EC_PALETTE_EXT_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_palette_ext_ram_address
	EC_ENTRY EC_PALETTE_EXT_RAM_DATA_LOWER, PRINT_ERROR_MEMORY, d_str_palette_ext_ram_data_lower
	EC_ENTRY EC_PALETTE_EXT_RAM_DATA_UPPER, PRINT_ERROR_MEMORY, d_str_palette_ext_ram_data_upper
	EC_ENTRY EC_PALETTE_EXT_RAM_DATA_BOTH, PRINT_ERROR_MEMORY, d_str_palette_ext_ram_data_both
	EC_ENTRY EC_PALETTE_EXT_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY, d_str_palette_ext_ram_march_lower
	EC_ENTRY EC_PALETTE_EXT_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY, d_str_palette_ext_ram_march_upper
	EC_ENTRY EC_PALETTE_EXT_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY, d_str_palette_ext_ram_march_both
	EC_ENTRY EC_PALETTE_EXT_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS, d_str_palette_ext_ram_output_lower
	EC_ENTRY EC_PALETTE_EXT_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS, d_str_palette_ext_ram_output_upper
	EC_ENTRY EC_PALETTE_EXT_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS, d_str_palette_ext_ram_output_both
	EC_ENTRY EC_PALETTE_EXT_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS, d_str_palette_ext_ram_write_lower
	EC_ENTRY EC_PALETTE_EXT_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS, d_str_palette_ext_ram_write_upper
	EC_ENTRY EC_PALETTE_EXT_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS, d_str_palette_ext_ram_write_both

	EC_ENTRY EC_SPRITE_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_sprite_ram_address
	EC_ENTRY EC_SPRITE_RAM_DATA_LOWER, PRINT_ERROR_MEMORY, d_str_sprite_ram_data_lower
	EC_ENTRY EC_SPRITE_RAM_DATA_UPPER, PRINT_ERROR_MEMORY, d_str_sprite_ram_data_upper
	EC_ENTRY EC_SPRITE_RAM_DATA_BOTH, PRINT_ERROR_MEMORY, d_str_sprite_ram_data_both
	EC_ENTRY EC_SPRITE_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY, d_str_sprite_ram_march_lower
	EC_ENTRY EC_SPRITE_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY, d_str_sprite_ram_march_upper
	EC_ENTRY EC_SPRITE_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY, d_str_sprite_ram_march_both
	EC_ENTRY EC_SPRITE_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS, d_str_sprite_ram_output_lower
	EC_ENTRY EC_SPRITE_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS, d_str_sprite_ram_output_upper
	EC_ENTRY EC_SPRITE_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS, d_str_sprite_ram_output_both
	EC_ENTRY EC_SPRITE_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS, d_str_sprite_ram_write_lower
	EC_ENTRY EC_SPRITE_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS, d_str_sprite_ram_write_upper
	EC_ENTRY EC_SPRITE_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS, d_str_sprite_ram_write_both

	EC_ENTRY EC_TILE1_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_tile1_ram_address
	EC_ENTRY EC_TILE1_RAM_DATA_LOWER, PRINT_ERROR_MEMORY, d_str_tile1_ram_data_lower
	EC_ENTRY EC_TILE1_RAM_DATA_UPPER, PRINT_ERROR_MEMORY, d_str_tile1_ram_data_upper
	EC_ENTRY EC_TILE1_RAM_DATA_BOTH, PRINT_ERROR_MEMORY, d_str_tile1_ram_data_both
	EC_ENTRY EC_TILE1_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY, d_str_tile1_ram_march_lower
	EC_ENTRY EC_TILE1_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY, d_str_tile1_ram_march_upper
	EC_ENTRY EC_TILE1_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY, d_str_tile1_ram_march_both
	EC_ENTRY EC_TILE1_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS, d_str_tile1_ram_output_lower
	EC_ENTRY EC_TILE1_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS, d_str_tile1_ram_output_upper
	EC_ENTRY EC_TILE1_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS, d_str_tile1_ram_output_both
	EC_ENTRY EC_TILE1_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS, d_str_tile1_ram_write_lower
	EC_ENTRY EC_TILE1_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS, d_str_tile1_ram_write_upper
	EC_ENTRY EC_TILE1_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS, d_str_tile1_ram_write_both

	EC_ENTRY EC_TILE2_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_tile2_ram_address
	EC_ENTRY EC_TILE2_RAM_DATA_LOWER, PRINT_ERROR_MEMORY, d_str_tile2_ram_data_lower
	EC_ENTRY EC_TILE2_RAM_DATA_UPPER, PRINT_ERROR_MEMORY, d_str_tile2_ram_data_upper
	EC_ENTRY EC_TILE2_RAM_DATA_BOTH, PRINT_ERROR_MEMORY, d_str_tile2_ram_data_both
	EC_ENTRY EC_TILE2_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY, d_str_tile2_ram_march_lower
	EC_ENTRY EC_TILE2_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY, d_str_tile2_ram_march_upper
	EC_ENTRY EC_TILE2_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY, d_str_tile2_ram_march_both
	EC_ENTRY EC_TILE2_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS, d_str_tile2_ram_output_lower
	EC_ENTRY EC_TILE2_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS, d_str_tile2_ram_output_upper
	EC_ENTRY EC_TILE2_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS, d_str_tile2_ram_output_both
	EC_ENTRY EC_TILE2_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS, d_str_tile2_ram_write_lower
	EC_ENTRY EC_TILE2_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS, d_str_tile2_ram_write_upper
	EC_ENTRY EC_TILE2_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS, d_str_tile2_ram_write_both

	EC_ENTRY EC_TILE3_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_tile3_ram_address
	EC_ENTRY EC_TILE3_RAM_DATA_LOWER, PRINT_ERROR_MEMORY, d_str_tile3_ram_data_lower
	EC_ENTRY EC_TILE3_RAM_DATA_UPPER, PRINT_ERROR_MEMORY, d_str_tile3_ram_data_upper
	EC_ENTRY EC_TILE3_RAM_DATA_BOTH, PRINT_ERROR_MEMORY, d_str_tile3_ram_data_both
	EC_ENTRY EC_TILE3_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY, d_str_tile3_ram_march_lower
	EC_ENTRY EC_TILE3_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY, d_str_tile3_ram_march_upper
	EC_ENTRY EC_TILE3_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY, d_str_tile3_ram_march_both
	EC_ENTRY EC_TILE3_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS, d_str_tile3_ram_output_lower
	EC_ENTRY EC_TILE3_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS, d_str_tile3_ram_output_upper
	EC_ENTRY EC_TILE3_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS, d_str_tile3_ram_output_both
	EC_ENTRY EC_TILE3_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS, d_str_tile3_ram_write_lower
	EC_ENTRY EC_TILE3_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS, d_str_tile3_ram_write_upper
	EC_ENTRY EC_TILE3_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS, d_str_tile3_ram_write_both

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
d_str_palette_ram_data_lower:		STRING "PALETTE RAM DATA (LOWER)"
d_str_palette_ram_data_upper:		STRING "PALETTE RAM DATA (UPPER)"
d_str_palette_ram_data_both:		STRING "PALETTE RAM DATA (BOTH)"
d_str_palette_ram_march_lower:		STRING "PALETTE RAM MARCH (LOWER)"
d_str_palette_ram_march_upper:		STRING "PALETTE RAM MARCH (UPPER)"
d_str_palette_ram_march_both:		STRING "PALETTE RAM MARCH (BOTH)"
d_str_palette_ram_output_lower:		STRING "PALETTE RAM DEAD OUTPUT (LOWER)"
d_str_palette_ram_output_upper:		STRING "PALETTE RAM DEAD OUTPUT (UPPER)"
d_str_palette_ram_output_both:		STRING "PALETTE RAM DEAD OUTPUT (BOTH)"
d_str_palette_ram_write_lower:		STRING "PALETTE RAM WRITE (LOWER)"
d_str_palette_ram_write_upper:		STRING "PALETTE RAM WRITE (UPPER)"
d_str_palette_ram_write_both:		STRING "PALETTE RAM WRITE (BOTH)"

d_str_palette_ext_ram_address:		STRING "PAL EXT RAM ADDRESS"
d_str_palette_ext_ram_data_lower:	STRING "PAL EXT RAM DATA (LOWER)"
d_str_palette_ext_ram_data_upper:	STRING "PAL EXT RAM DATA (UPPER)"
d_str_palette_ext_ram_data_both:	STRING "PAL EXT RAM DATA (BOTH)"
d_str_palette_ext_ram_march_lower:	STRING "PAL EXT RAM MARCH (LOWER)"
d_str_palette_ext_ram_march_upper:	STRING "PAL EXT RAM MARCH (UPPER)"
d_str_palette_ext_ram_march_both:	STRING "PAL EXT RAM MARCH (BOTH)"
d_str_palette_ext_ram_output_lower:	STRING "PAL EXT RAM DEAD OUTPUT (LOWER)"
d_str_palette_ext_ram_output_upper:	STRING "PAL EXT RAM DEAD OUTPUT (UPPER)"
d_str_palette_ext_ram_output_both:	STRING "PAL EXT RAM DEAD OUTPUT (BOTH)"
d_str_palette_ext_ram_write_lower:	STRING "PAL EXT RAM WRITE (LOWER)"
d_str_palette_ext_ram_write_upper:	STRING "PAL EXT RAM WRITE (UPPER)"
d_str_palette_ext_ram_write_both:	STRING "PAL EXT RAM WRITE (BOTH)"

d_str_sprite_ram_address:		STRING "SPRITE RAM ADDRESS"
d_str_sprite_ram_data_lower:		STRING "SPRITE RAM DATA (LOWER)"
d_str_sprite_ram_data_upper:		STRING "SPRITE RAM DATA (UPPER)"
d_str_sprite_ram_data_both:		STRING "SPRITE RAM DATA (BOTH)"
d_str_sprite_ram_march_lower:		STRING "SPRITE RAM MARCH (LOWER)"
d_str_sprite_ram_march_upper:		STRING "SPRITE RAM MARCH (UPPER)"
d_str_sprite_ram_march_both:		STRING "SPRITE RAM MARCH (BOTH)"
d_str_sprite_ram_output_lower:		STRING "SPRITE RAM DEAD OUTPUT (LOWER)"
d_str_sprite_ram_output_upper:		STRING "SPRITE RAM DEAD OUTPUT (UPPER)"
d_str_sprite_ram_output_both:		STRING "SPRITE RAM DEAD OUTPUT (BOTH)"
d_str_sprite_ram_write_lower:		STRING "SPRITE RAM WRITE (LOWER)"
d_str_sprite_ram_write_upper:		STRING "SPRITE RAM WRITE (UPPER)"
d_str_sprite_ram_write_both:		STRING "SPRITE RAM WRITE (BOTH)"

d_str_tile1_ram_address:		STRING "TILE1 RAM ADDRESS"
d_str_tile1_ram_data_lower:		STRING "TILE1 RAM DATA (LOWER)"
d_str_tile1_ram_data_upper:		STRING "TILE1 RAM DATA (UPPER)"
d_str_tile1_ram_data_both:		STRING "TILE1 RAM DATA (BOTH)"
d_str_tile1_ram_march_lower:		STRING "TILE1 RAM MARCH (LOWER)"
d_str_tile1_ram_march_upper:		STRING "TILE1 RAM MARCH (UPPER)"
d_str_tile1_ram_march_both:		STRING "TILE1 RAM MARCH (BOTH)"
d_str_tile1_ram_output_lower:		STRING "TILE1 RAM DEAD OUTPUT (LOWER)"
d_str_tile1_ram_output_upper:		STRING "TILE1 RAM DEAD OUTPUT (UPPER)"
d_str_tile1_ram_output_both:		STRING "TILE1 RAM DEAD OUTPUT (BOTH)"
d_str_tile1_ram_write_lower:		STRING "TILE1 RAM WRITE (LOWER)"
d_str_tile1_ram_write_upper:		STRING "TILE1 RAM WRITE (UPPER)"
d_str_tile1_ram_write_both:		STRING "TILE1 RAM WRITE (BOTH)"

d_str_tile2_ram_address:		STRING "TILE2 RAM ADDRESS"
d_str_tile2_ram_data_lower:		STRING "TILE2 RAM DATA (LOWER)"
d_str_tile2_ram_data_upper:		STRING "TILE2 RAM DATA (UPPER)"
d_str_tile2_ram_data_both:		STRING "TILE2 RAM DATA (BOTH)"
d_str_tile2_ram_march_lower:		STRING "TILE2 RAM MARCH (LOWER)"
d_str_tile2_ram_march_upper:		STRING "TILE2 RAM MARCH (UPPER)"
d_str_tile2_ram_march_both:		STRING "TILE2 RAM MARCH (BOTH)"
d_str_tile2_ram_output_lower:		STRING "TILE2 RAM DEAD OUTPUT (LOWER)"
d_str_tile2_ram_output_upper:		STRING "TILE2 RAM DEAD OUTPUT (UPPER)"
d_str_tile2_ram_output_both:		STRING "TILE2 RAM DEAD OUTPUT (BOTH)"
d_str_tile2_ram_write_lower:		STRING "TILE2 RAM WRITE (LOWER)"
d_str_tile2_ram_write_upper:		STRING "TILE2 RAM WRITE (UPPER)"
d_str_tile2_ram_write_both:		STRING "TILE2 RAM WRITE (BOTH)"

d_str_tile3_ram_address:		STRING "TILE3 RAM ADDRESS"
d_str_tile3_ram_data_lower:		STRING "TILE3 RAM DATA (LOWER)"
d_str_tile3_ram_data_upper:		STRING "TILE3 RAM DATA (UPPER)"
d_str_tile3_ram_data_both:		STRING "TILE3 RAM DATA (BOTH)"
d_str_tile3_ram_march_lower:		STRING "TILE3 RAM MARCH (LOWER)"
d_str_tile3_ram_march_upper:		STRING "TILE3 RAM MARCH (UPPER)"
d_str_tile3_ram_march_both:		STRING "TILE3 RAM MARCH (BOTH)"
d_str_tile3_ram_output_lower:		STRING "TILE3 RAM DEAD OUTPUT (LOWER)"
d_str_tile3_ram_output_upper:		STRING "TILE3 RAM DEAD OUTPUT (UPPER)"
d_str_tile3_ram_output_both:		STRING "TILE3 RAM DEAD OUTPUT (BOTH)"
d_str_tile3_ram_write_lower:		STRING "TILE3 RAM WRITE (LOWER)"
d_str_tile3_ram_write_upper:		STRING "TILE3 RAM WRITE (UPPER)"
d_str_tile3_ram_write_both:		STRING "TILE3 RAM WRITE (BOTH)"

d_str_mad_rom_crc32:			STRING "MAD ROM CRC32 ERROR"
d_str_mad_rom_address:			STRING "MAD ROM ADDRESS ERROR"
