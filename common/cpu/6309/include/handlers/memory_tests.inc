	rsreset
mt_start_address	rs.w 1
mt_size			rs.w 1
mt_num_address_lines	rs.b 1
mt_base_ec		rs.b 1


	; struct mt_params {
	;  word memory_start_address
	;  word memory_size
	;  byte num_address_lines
	;  byte base_ec
	; };
	macro MT_PARAMS
		dc.w	\1, \2
		dc.b	\3, \4
	endm

MT_ERROR_ADDRESS_BASE	equ $0
MT_ERROR_DATA_BASE	equ $1
MT_ERROR_MARCH_BASE	equ $2
MT_ERROR_OUTPUT_BASE	equ $3
MT_ERROR_WRITE_BASE	equ $4
