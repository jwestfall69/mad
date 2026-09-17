	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/print_error.inc"
	include "cpu/6x09/include/handlers/error.inc"

	global d_ec_list

	section data

d_ec_list:
	EC_ENTRY EC_SCROLL_RAM_ADDRESS, PRINT_ERROR_MEMORY, d_str_scroll_ram_address
	EC_ENTRY EC_SCROLL_RAM_DATA, PRINT_ERROR_MEMORY, d_str_scroll_ram_data
	EC_ENTRY EC_SCROLL_RAM_MARCH, PRINT_ERROR_MEMORY, d_str_scroll_ram_march
	EC_ENTRY EC_SCROLL_RAM_OUTPUT, PRINT_ERROR_ADDRESS, d_str_scroll_ram_output
	EC_ENTRY EC_SCROLL_RAM_WRITE, PRINT_ERROR_ADDRESS, d_str_scroll_ram_write
	EC_LIST_END

d_str_scroll_ram_address:	STRING "SCROLL RAM ADDRESS"
d_str_scroll_ram_data:		STRING "SCROLL RAM DATA"
d_str_scroll_ram_march:		STRING "SCROLL RAM MARCH"
d_str_scroll_ram_output:	STRING "SCROLL RAM DEAD OUTPUT"
d_str_scroll_ram_write:		STRING "SCROLL RAM WRITE"

