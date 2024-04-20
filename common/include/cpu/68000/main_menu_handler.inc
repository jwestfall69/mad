	; struct main_menu_entry {
	;   long function_address;
	;   long string_address;
	; }
	macro MAIN_MENU_ENTRY
		dc.l \1, \2
	endm

	macro MAIN_MENU_LIST_END
		dc.l $0
	endm
