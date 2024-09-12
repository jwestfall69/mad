	; struct EC_ENTRY {
	;   byte error_code;
	;   byte print_error_dsub_id;
	;   word description_string_address;
	; }
	macro EC_ENTRY
		dfb \1, \2
		dfw \3
	endm

	macro EC_LIST_END
		dfb $0, $0
		dfw $0
	endm
