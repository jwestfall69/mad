PRINT_ERROR_ADDRESS		equ $1
PRINT_ERROR_CRC32		equ $2
PRINT_ERROR_HEX_BYTE		equ $3
PRINT_ERROR_MEMORY		equ $4
PRINT_ERROR_STRING		equ $5

PRINT_ERROR_INVALID		equ $ff

	; struct EC_PRINT_ENTRY {
	;   byte function_id;
	;   word function_address
	macro EC_PRINT_ENTRY
		dfb \1
		dfw \2
	endm

	macro EC_PRINT_LIST_END
		dfb $0, $0
		dfw $0
	endm
