	include "global/include/macros.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/handlers/auto_test.inc"

	global	auto_func_tests

	section code

auto_func_tests:
		ldy	#d_auto_test_func_list
		jsr	auto_test_func_handler
		rts

	section data

d_auto_test_func_list:
	AUTO_TEST_ENTRY auto_palette_ram_tests, d_str_testing_palette_ram
	AUTO_TEST_ENTRY auto_sprite1_ram_tests, d_str_testing_sprite1_ram
	AUTO_TEST_ENTRY auto_sprite2_ram_tests, d_str_testing_sprite2_ram
	AUTO_TEST_ENTRY auto_tile1_ram_tests, d_str_testing_tile1_ram
	AUTO_TEST_ENTRY auto_tile2_ram_tests, d_str_testing_tile2_ram
	AUTO_TEST_ENTRY auto_tile3_ram_tests, d_str_testing_tile3_ram
	AUTO_TEST_LIST_END

d_str_testing_palette_ram:		STRING "TESTING PALETTE RAM"
d_str_testing_sprite1_ram:		STRING "TESTING SPRITE1 RAM"
d_str_testing_sprite2_ram:		STRING "TESTING SPRITE2 RAM"
d_str_testing_tile1_ram:		STRING "TESTING TILE1 RAM"
d_str_testing_tile2_ram:		STRING "TESTING TILE2 RAM"
d_str_testing_tile3_ram:		STRING "TESTING TILE3 RAM"

