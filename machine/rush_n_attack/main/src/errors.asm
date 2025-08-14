	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/print_error.inc"
	include "cpu/z80/include/handlers/error.inc"

	global d_ec_list

	section data

d_ec_list:
	EC_LIST_END
