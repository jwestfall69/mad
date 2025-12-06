
	rsreset
s_me_function_ptr	rs.l 1
s_me_name_ptr		rs.l 1
s_me_struct_size	rs.b 0

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
