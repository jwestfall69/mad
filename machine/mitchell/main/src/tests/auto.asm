	include "global/include/macros.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/tests/auto.inc"

	global d_auto_func_list

	section data

d_auto_func_list:
	AUTO_ENTRY auto_color_ram_tests, d_str_testing_color_ram
	AUTO_ENTRY auto_object_ram_tests, d_str_testing_object_ram
	AUTO_ENTRY auto_tile_ram_tests, d_str_testing_tile_ram
	AUTO_LIST_END

d_str_testing_color_ram:		STRING "TESTING COLOR RAM"
d_str_testing_object_ram:		STRING "TESTING OBJECT RAM"
d_str_testing_tile_ram:			STRING "TESTING TILE RAM"
