	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/print_error.inc"
	include "cpu/68000/include/handlers/error.inc"

	global d_ec_list

	section data
	align 1

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

	EC_ENTRY EC_GFX_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_gfx_ram_address
	EC_ENTRY EC_GFX_RAM_DATA_LOWER, PRINT_ERROR_MEMORY, d_str_gfx_ram_data_lower
	EC_ENTRY EC_GFX_RAM_DATA_UPPER, PRINT_ERROR_MEMORY, d_str_gfx_ram_data_upper
	EC_ENTRY EC_GFX_RAM_DATA_BOTH, PRINT_ERROR_MEMORY, d_str_gfx_ram_data_both
	EC_ENTRY EC_GFX_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY, d_str_gfx_ram_march_lower
	EC_ENTRY EC_GFX_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY, d_str_gfx_ram_march_upper
	EC_ENTRY EC_GFX_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY, d_str_gfx_ram_march_both
	EC_ENTRY EC_GFX_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS, d_str_gfx_ram_output_lower
	EC_ENTRY EC_GFX_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS, d_str_gfx_ram_output_upper
	EC_ENTRY EC_GFX_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS, d_str_gfx_ram_output_both
	EC_ENTRY EC_GFX_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS, d_str_gfx_ram_write_lower
	EC_ENTRY EC_GFX_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS, d_str_gfx_ram_write_upper
	EC_ENTRY EC_GFX_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS, d_str_gfx_ram_write_both

	EC_ENTRY EC_OBJECT_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_object_ram_address
	EC_ENTRY EC_OBJECT_RAM_DATA_LOWER, PRINT_ERROR_MEMORY, d_str_object_ram_data_lower
	EC_ENTRY EC_OBJECT_RAM_DATA_UPPER, PRINT_ERROR_MEMORY, d_str_object_ram_data_upper
	EC_ENTRY EC_OBJECT_RAM_DATA_BOTH, PRINT_ERROR_MEMORY, d_str_object_ram_data_both
	EC_ENTRY EC_OBJECT_RAM_MARCH_LOWER, PRINT_ERROR_MEMORY, d_str_object_ram_march_lower
	EC_ENTRY EC_OBJECT_RAM_MARCH_UPPER, PRINT_ERROR_MEMORY, d_str_object_ram_march_upper
	EC_ENTRY EC_OBJECT_RAM_MARCH_BOTH, PRINT_ERROR_MEMORY, d_str_object_ram_march_both
	EC_ENTRY EC_OBJECT_RAM_OUTPUT_LOWER, PRINT_ERROR_ADDRESS, d_str_object_ram_output_lower
	EC_ENTRY EC_OBJECT_RAM_OUTPUT_UPPER, PRINT_ERROR_ADDRESS, d_str_object_ram_output_upper
	EC_ENTRY EC_OBJECT_RAM_OUTPUT_BOTH, PRINT_ERROR_ADDRESS, d_str_object_ram_output_both
	EC_ENTRY EC_OBJECT_RAM_WRITE_LOWER, PRINT_ERROR_ADDRESS, d_str_object_ram_write_lower
	EC_ENTRY EC_OBJECT_RAM_WRITE_UPPER, PRINT_ERROR_ADDRESS, d_str_object_ram_write_upper
	EC_ENTRY EC_OBJECT_RAM_WRITE_BOTH, PRINT_ERROR_ADDRESS, d_str_object_ram_write_both
	EC_ENTRY EC_OBJECT_RAM_BANK, PRINT_ERROR_MEMORY, d_str_object_ram_bank

	EC_ENTRY EC_QSOUND_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_qsound_ram_address
	EC_ENTRY EC_QSOUND_RAM_DATA, PRINT_ERROR_MEMORY, d_str_qsound_ram_data
	EC_ENTRY EC_QSOUND_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_qsound_ram_march
	EC_ENTRY EC_QSOUND_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_qsound_ram_output
	EC_ENTRY EC_QSOUND_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_qsound_ram_write

	EC_ENTRY EC_MAD_ROM_CRC32, PRINT_ERROR_CRC32, d_str_mad_rom_crc32
	EC_ENTRY EC_MAD_ROM_ADDRESS, PRINT_ERROR_HEX_BYTE, d_str_mad_rom_address
	EC_LIST_END

d_str_gfx_ram_address:		STRING "GFX RAM ADDRESS"
d_str_gfx_ram_data_lower:	STRING "GFX RAM DATA (LOWER)"
d_str_gfx_ram_data_upper:	STRING "GFX RAM DATA (UPPER)"
d_str_gfx_ram_data_both:	STRING "GFX RAM DATA (BOTH)"
d_str_gfx_ram_march_lower:	STRING "GFX RAM MARCH (LOWER)"
d_str_gfx_ram_march_upper:	STRING "GFX RAM MARCH (UPPER)"
d_str_gfx_ram_march_both:	STRING "GFX RAM MARCH (BOTH)"
d_str_gfx_ram_output_lower:	STRING "GFX RAM DEAD OUTPUT (LOWER)"
d_str_gfx_ram_output_upper:	STRING "GFX RAM DEAD OUTPUT (UPPER)"
d_str_gfx_ram_output_both:	STRING "GFX RAM DEAD OUTPUT (BOTH)"
d_str_gfx_ram_write_lower:	STRING "GFX RAM WRITE (LOWER)"
d_str_gfx_ram_write_upper:	STRING "GFX RAM WRITE (UPPER)"
d_str_gfx_ram_write_both:	STRING "GFX RAM WRITE (BOTH)"

d_str_object_ram_address:	STRING "OBJECT RAM ADDRESS"
d_str_object_ram_data_lower:	STRING "OBJECT RAM DATA (LOWER)"
d_str_object_ram_data_upper:	STRING "OBJECT RAM DATA (UPPER)"
d_str_object_ram_data_both:	STRING "OBJECT RAM DATA (BOTH)"
d_str_object_ram_march_lower:	STRING "OBJECT RAM MARCH (LOWER)"
d_str_object_ram_march_upper:	STRING "OBJECT RAM MARCH (UPPER)"
d_str_object_ram_march_both:	STRING "OBJECT RAM MARCH (BOTH)"
d_str_object_ram_output_lower:	STRING "OBJECT RAM DEAD OUTPUT (LOWER)"
d_str_object_ram_output_upper:	STRING "OBJECT RAM DEAD OUTPUT (UPPER)"
d_str_object_ram_output_both:	STRING "OBJECT RAM DEAD OUTPUT (BOTH)"
d_str_object_ram_write_lower:	STRING "OBJECT RAM WRITE (LOWER)"
d_str_object_ram_write_upper:	STRING "OBJECT RAM WRITE (UPPER)"
d_str_object_ram_write_both:	STRING "OBJECT RAM WRITE (BOTH)"
d_str_object_ram_bank:		STRING "OBJECT RAM BANK SWITCH FAILED"

d_str_qsound_ram_address:	STRING "QSOUND RAM ADDRESS"
d_str_qsound_ram_data:		STRING "QSOUND RAM DATA"
d_str_qsound_ram_march:		STRING "QSOUND RAM MARCH"
d_str_qsound_ram_output:	STRING "QSOUND RAM DEAD OUTPUT"
d_str_qsound_ram_write:		STRING "QSOUND RAM WRITE"

d_str_work_ram_address:		STRING "WORK RAM ADDRESS"
d_str_work_ram_data_lower:	STRING "WORK RAM DATA (LOWER)"
d_str_work_ram_data_upper:	STRING "WORK RAM DATA (UPPER)"
d_str_work_ram_data_both:	STRING "WORK RAM DATA (BOTH)"
d_str_work_ram_march_lower:	STRING "WORK RAM MARCH (LOWER)"
d_str_work_ram_march_upper:	STRING "WORK RAM MARCH (UPPER)"
d_str_work_ram_march_both:	STRING "WORK RAM MARCH (BOTH)"
d_str_work_ram_output_lower:	STRING "WORK RAM DEAD OUTPUT (LOWER)"
d_str_work_ram_output_upper:	STRING "WORK RAM DEAD OUTPUT (UPPER)"
d_str_work_ram_output_both:	STRING "WORK RAM DEAD OUTPUT (BOTH)"
d_str_work_ram_write_lower:	STRING "WORK RAM WRITE (LOWER)"
d_str_work_ram_write_upper:	STRING "WORK RAM WRITE (UPPER)"
d_str_work_ram_write_both:	STRING "WORK RAM WRITE (BOTH)"

d_str_mad_rom_crc32:		STRING "MAD ROM CRC32 ERROR"
d_str_mad_rom_address:		STRING "MAD ROM ADDRESS ERROR"
