MAIN_MENU_UP_BIT	equ $0
MAIN_MENU_DOWN_BIT	equ $1
MAIN_MENU_BUTTON_BIT	equ $2

	; struct main_menu_entry {
	;   long function_address;
	;   long string_address;
	; }
	macro MAIN_MENU_ENTRY
		dc.l \1, \2
	endm

	macro MAIN_MENU_ENTRY_LIST_END
		dc.l $0
	endm
