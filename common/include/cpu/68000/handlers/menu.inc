
MENU_EXIT	equ $0
MENU_CONTINUE	equ $1

	; struct menu_entry {
	;   long function_address;
	;   long string_address;
	; }
	macro MENU_ENTRY
		dc.l \1, \2
	endm

	macro MENU_LIST_END
		dc.l $0
	endm
