	; struct EC_ENTRY {
	;   byte error_code;
	;   byte print_error_dsub_id;
	;   long description_string_address;
	; }
	macro EC_ENTRY
		dc.b \1, \2
		dc.l \3
	endm

	macro EC_LIST_END
		dc.b $0, $0
		dc.l $0
	endm
