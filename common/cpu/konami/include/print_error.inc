PRINT_ERROR_ADDRESS		equ $1
PRINT_ERROR_CRC32		equ $2
PRINT_ERROR_HEX_BYTE		equ $3
PRINT_ERROR_MEMORY		equ $4
PRINT_ERROR_STRING		equ $5

PRINT_ERROR_INVALID		equ $ff

	rsreset
s_pe_print_error_id		rs.b 1
s_pe_function_ptr		rs.w 1
s_pe_struct_size		rs.b 0

	; struct EC_PRINT_ENTRY {
	;   byte function_id;
	;   word function_address
	macro EC_PRINT_ENTRY
		dc.b \1
		dc.w \2
	endm

	macro EC_PRINT_LIST_END
		dc.b $0, $0
		dc.w $0
	endm
