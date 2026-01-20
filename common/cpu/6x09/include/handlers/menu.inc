	rsreset
s_me_function_ptr	rs.w 1
s_me_name_ptr		rs.w 1
s_me_flags		rs.b 1
s_me_struct_size	rs.b 0

	; struct menu_entry {
	;   word function_address;
	;   word string_address;
	;   byte flags;
	; }
	macro MENU_ENTRY
		dc.w \1, \2
		dc.b \3
	endm

	macro MENU_LIST_END
		dc.w $0, $0
	endm

ME_FLAG_SKIP_SCREEN_INIT_BIT	equ $0

ME_FLAG_NONE			equ $0
; skip calling screen_init before running menu entry function
ME_FLAG_SKIP_SCREEN_INIT	equ (1<<ME_FLAG_SKIP_SCREEN_INIT_BIT)
