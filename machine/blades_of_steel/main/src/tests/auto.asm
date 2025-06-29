	include "global/include/macros.inc"

	include "cpu/6x09/include/macros.inc"
	include "cpu/6x09/include/handlers/auto_test.inc"

	global	auto_func_tests

	section code

auto_func_tests:
		ldy	#d_auto_test_func_list
		jsr	auto_test_func_handler
		rts

	section data

d_auto_test_func_list:
	AUTO_TEST_ENTRY auto_palette_ram_tests, d_str_testing_palette_ram
;	AUTO_TEST_ENTRY auto_sprite_ram_tests, d_str_testing_sprite_ram
	AUTO_TEST_ENTRY auto_tile_ram_tests, d_str_testing_tile_ram
	AUTO_TEST_LIST_END

d_str_testing_palette_ram:		STRING "TESTING PALETTE RAM"
d_str_testing_sprite_ram:		STRING "TESTING SPRITE RAM"
d_str_testing_tile_ram:			STRING "TESTING TILE RAM"

