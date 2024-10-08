PRINT_ERROR_ADDRESS		equ $1
PRINT_ERROR_CRC32		equ $2
PRINT_ERROR_HEX_BYTE		equ $3
PRINT_ERROR_MEMORY		equ $4
PRINT_ERROR_STRING		equ $5

PRINT_ERROR_INVALID		equ $ff

	rsreset
s_pe_print_error_id		rs.w 1
s_pe_function_ptr		rs.l 1
s_pe_struct_size		rs.b 0

	; struct EC_PRINT_ENTRY {
	;   word dsub_id;
	;   long dsub_address
	macro EC_PRINT_ENTRY
		dc.w \1
		dc.l \2
	endm

	macro EC_PRINT_LIST_END
		dc.b $0, $0
		dc.l $0
	endm
