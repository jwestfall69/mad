	include "cpu/6309/include/common.inc"
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
	AUTO_TEST_ENTRY auto_k007121_g8_ram_tests, d_str_testing_k007121_g8_ram
	AUTO_TEST_ENTRY auto_k007121_g15_ram_tests, d_str_testing_k007121_g15_ram
	AUTO_TEST_LIST_END

d_str_testing_palette_ram:		STRING "TESTING PALETTE RAM"
d_str_testing_k007121_g8_ram:		STRING "TESTING K007121 G8 RAM"
d_str_testing_k007121_g15_ram:		STRING "TESTING K007121 G15 RAM"

