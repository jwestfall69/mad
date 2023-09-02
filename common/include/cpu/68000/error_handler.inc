	; struct EC_ENTRY {
	;   byte error_code;
	;   byte print_error_dsub_id;
	;   long description_string_address;
	; }
	macro EC_ENTRY
		dc.b EC_\1, \2
		dc.l STR_\1
	endm

	macro EC_ENTRY_NULL
		dc.b $0, $0
		dc.l $0
	endm

	; struct EC_PRINT_ENTRY {
	;   byte padding;
	;   byte dsub_id;
	;   long dsub_address
	macro EC_PRINT_ENTRY
		dc.b $0, \1
		dc.l \2
	endm

	macro EC_PRINT_ENTRY_NULL
		dc.b $0, $0
		dc.l $0
	endm
