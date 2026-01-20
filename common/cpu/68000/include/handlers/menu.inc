
	rsreset
s_me_function_ptr	rs.l 1
s_me_name_ptr		rs.l 1
s_me_flags		rs.b 1
s_me_padding		rs.b 1
s_me_struct_size	rs.b 0

	; struct menu_entry {
	;   long function_address;
	;   long string_address;
	;   byte flags;
	;   byte padding;
	; }
	macro MENU_ENTRY
		dc.l \1, \2
		dc.b \3, $0
	endm

	macro MENU_LIST_END
		dc.l $0
	endm

ME_FLAG_SKIP_SCREEN_INIT_BIT	equ $0

ME_FLAG_NONE			equ $0
; skip calling screen_init before running menu entry function
ME_FLAG_SKIP_SCREEN_INIT	equ (1<<ME_FLAG_SKIP_SCREEN_INIT_BIT)
