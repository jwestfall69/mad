	rsreset
s_me_function_ptr	rs.w 1
s_me_name_ptr		rs.w 1
s_me_struct_size	rs.b 0

	; struct menu_entry {
	;   word function_address;
	;   word string_address;
	; }
	macro MENU_ENTRY
		dc.w \1, \2
	endm

	macro MENU_LIST_END
		dc.w $0, $0
	endm

