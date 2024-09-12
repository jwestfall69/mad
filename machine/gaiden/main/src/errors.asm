	include "cpu/68000/include/error_codes.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/print_error.inc"
	include "cpu/68000/include/handlers/error.inc"

	include "error_codes.inc"

	global d_ec_list

	section data
	align 2

d_ec_list:
	EC_ENTRY EC_BG_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_bg_ram_address
	EC_ENTRY EC_BG_RAM_DATA_LOWER, PRINT_ERROR_MEMORY, d_str_bg_ram_data_lower
	EC_ENTRY EC_BG_RAM_DATA_UPPER, PRINT_ERROR_MEMORY, d_str_bg_ram_data_upper
	EC_ENTRY EC_BG_RAM_DATA_BOTH, PRINT_ERROR_MEMORY, d_str_bg_ram_data_both
	EC_ENTRY EC_BG_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY, d_str_bg_ram_march_lower
	EC_ENTRY EC_BG_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY, d_str_bg_ram_march_upper
	EC_ENTRY EC_BG_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY, d_str_bg_ram_march_both
	EC_ENTRY EC_BG_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS, d_str_bg_ram_output_lower
	EC_ENTRY EC_BG_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS, d_str_bg_ram_output_upper
	EC_ENTRY EC_BG_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS, d_str_bg_ram_output_both
	EC_ENTRY EC_BG_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS, d_str_bg_ram_write_lower
	EC_ENTRY EC_BG_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS, d_str_bg_ram_write_upper
	EC_ENTRY EC_BG_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS, d_str_bg_ram_write_both

	EC_ENTRY EC_FG_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_fg_ram_address
	EC_ENTRY EC_FG_RAM_DATA_LOWER, PRINT_ERROR_MEMORY, d_str_fg_ram_data_lower
	EC_ENTRY EC_FG_RAM_DATA_UPPER, PRINT_ERROR_MEMORY, d_str_fg_ram_data_upper
	EC_ENTRY EC_FG_RAM_DATA_BOTH, PRINT_ERROR_MEMORY, d_str_fg_ram_data_both
	EC_ENTRY EC_FG_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY, d_str_fg_ram_march_lower
	EC_ENTRY EC_FG_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY, d_str_fg_ram_march_upper
	EC_ENTRY EC_FG_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY, d_str_fg_ram_march_both
	EC_ENTRY EC_FG_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS, d_str_fg_ram_output_lower
	EC_ENTRY EC_FG_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS, d_str_fg_ram_output_upper
	EC_ENTRY EC_FG_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS, d_str_fg_ram_output_both
	EC_ENTRY EC_FG_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS, d_str_fg_ram_write_lower
	EC_ENTRY EC_FG_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS, d_str_fg_ram_write_upper
	EC_ENTRY EC_FG_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS, d_str_fg_ram_write_both

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

	EC_ENTRY EC_TXT_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_txt_ram_address
	EC_ENTRY EC_TXT_RAM_DATA_LOWER, PRINT_ERROR_MEMORY, d_str_txt_ram_data_lower
	EC_ENTRY EC_TXT_RAM_DATA_UPPER, PRINT_ERROR_MEMORY, d_str_txt_ram_data_upper
	EC_ENTRY EC_TXT_RAM_DATA_BOTH, PRINT_ERROR_MEMORY, d_str_txt_ram_data_both
	EC_ENTRY EC_TXT_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY, d_str_txt_ram_march_lower
	EC_ENTRY EC_TXT_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY, d_str_txt_ram_march_upper
	EC_ENTRY EC_TXT_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY, d_str_txt_ram_march_both
	EC_ENTRY EC_TXT_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS, d_str_txt_ram_output_lower
	EC_ENTRY EC_TXT_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS, d_str_txt_ram_output_upper
	EC_ENTRY EC_TXT_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS, d_str_txt_ram_output_both
	EC_ENTRY EC_TXT_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS, d_str_txt_ram_write_lower
	EC_ENTRY EC_TXT_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS, d_str_txt_ram_write_upper
	EC_ENTRY EC_TXT_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS, d_str_txt_ram_write_both

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
	EC_ENTRY EC_MAD_ROM_CRC32, PRINT_ERROR_CRC32, d_str_mad_rom_crc32
	EC_ENTRY EC_MAD_ROM_ADDRESS, PRINT_ERROR_HEX_BYTE, d_str_mad_rom_address
	EC_LIST_END

d_str_bg_ram_address:			STRING "BG RAM ADDRESS"
d_str_bg_ram_data_lower:		STRING "BG RAM DATA (LOWER)"
d_str_bg_ram_data_upper:		STRING "BG RAM DATA (UPPER)"
d_str_bg_ram_data_both:			STRING "BG RAM DATA (BOTH)"
d_str_bg_ram_march_lower:		STRING "BG RAM MARCH (LOWER)"
d_str_bg_ram_march_upper:		STRING "BG RAM MARCH (UPPER)"
d_str_bg_ram_march_both:		STRING "BG RAM MARCH (BOTH)"
d_str_bg_ram_output_lower:		STRING "BG RAM DEAD OUTPUT (LOWER)"
d_str_bg_ram_output_upper:		STRING "BG RAM DEAD OUTPUT (UPPER)"
d_str_bg_ram_output_both:		STRING "BG RAM DEAD OUTPUT (BOTH)"
d_str_bg_ram_write_lower:		STRING "BG RAM WRITE (LOWER)"
d_str_bg_ram_write_upper:		STRING "BG RAM WRITE (UPPER)"
d_str_bg_ram_write_both:		STRING "BG RAM WRITE (BOTH)"

d_str_fg_ram_address:			STRING "FG RAM ADDRESS"
d_str_fg_ram_data_lower:		STRING "FG RAM DATA (LOWER)"
d_str_fg_ram_data_upper:		STRING "FG RAM DATA (UPPER)"
d_str_fg_ram_data_both:			STRING "FG RAM DATA (BOTH)"
d_str_fg_ram_march_lower:		STRING "FG RAM MARCH (LOWER)"
d_str_fg_ram_march_upper:		STRING "FG RAM MARCH (UPPER)"
d_str_fg_ram_march_both:		STRING "FG RAM MARCH (BOTH)"
d_str_fg_ram_output_lower:		STRING "FG RAM DEAD OUTPUT (LOWER)"
d_str_fg_ram_output_upper:		STRING "FG RAM DEAD OUTPUT (UPPER)"
d_str_fg_ram_output_both:		STRING "FG RAM DEAD OUTPUT (BOTH)"
d_str_fg_ram_write_lower:		STRING "FG RAM WRITE (LOWER)"
d_str_fg_ram_write_upper:		STRING "FG RAM WRITE (UPPER)"
d_str_fg_ram_write_both:		STRING "FG RAM WRITE (BOTH)"

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

d_str_txt_ram_address:			STRING "TXT RAM ADDRESS"
d_str_txt_ram_data_lower:		STRING "TXT RAM DATA (LOWER)"
d_str_txt_ram_data_upper:		STRING "TXT RAM DATA (UPPER)"
d_str_txt_ram_data_both:		STRING "TXT RAM DATA (BOTH)"
d_str_txt_ram_march_lower:		STRING "TXT RAM MARCH (LOWER)"
d_str_txt_ram_march_upper:		STRING "TXT RAM MARCH (UPPER)"
d_str_txt_ram_march_both:		STRING "TXT RAM MARCH (BOTH)"
d_str_txt_ram_output_lower:		STRING "TXT RAM DEAD OUTPUT (LOWER)"
d_str_txt_ram_output_upper:		STRING "TXT RAM DEAD OUTPUT (UPPER)"
d_str_txt_ram_output_both:		STRING "TXT RAM DEAD OUTPUT (BOTH)"
d_str_txt_ram_write_lower:		STRING "TXT RAM WRITE (LOWER)"
d_str_txt_ram_write_upper:		STRING "TXT RAM WRITE (UPPER)"
d_str_txt_ram_write_both:		STRING "TXT RAM WRITE (BOTH)"

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

d_str_mad_rom_crc32:			STRING "MAD ROM CRC32 ERROR"
d_str_mad_rom_address:			STRING "MAD ROM ADDRESS ERROR"
