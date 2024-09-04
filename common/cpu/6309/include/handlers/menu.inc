MENU_EXIT	equ $0
MENU_CONTINUE	equ $1

	; struct menu_entry {
	;   word function_address;
	;   word string_address;
	; }
	macro MENU_ENTRY
		dfw \1, \2
	endm

	macro MENU_LIST_END
		dfw $0, $0
	endm

