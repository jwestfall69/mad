	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/menu.inc"

	global ram_tests_menu

	section code

ram_tests_menu:
		lea	d_str_menu_title, a0
		lea	d_menu_list, a1
		jsr	menu_handler
		rts

	section data
	align 1

d_menu_list:
	MENU_ENTRY manual_gfx_ram_tests, d_str_gfx_ram_test
	MENU_ENTRY manual_object_ram_tests, d_str_object_ram_test
	MENU_ENTRY manual_qsound_ram_tests, d_str_qsound_ram_test
	MENU_ENTRY manual_work_ram_tests, d_str_work_ram_test
	MENU_LIST_END

d_str_menu_title:		STRING "RAM TESTS"

d_str_gfx_ram_test:		STRING "GFX RAM TEST"
d_str_object_ram_test:		STRING "OBJECT RAM TEST"
d_str_qsound_ram_test:		STRING "QSOUND RAM TEST"
d_str_work_ram_test:		STRING "WORK RAM TEST"
