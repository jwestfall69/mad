	; struct EC_ENTRY {
	;   byte error_code;
	;   byte print_error_dsub_id;
	;   long description_string_address;
	; }
	macro EC_ENTRY
		dc.b EC_\1, \2
		dc.l STR_\1
	endm

	macro EC_LIST_END
		dc.b $0, $0
		dc.l $0
	endm
