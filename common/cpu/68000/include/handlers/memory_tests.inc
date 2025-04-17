	; struct mt_params {
	;  long start_address
	;  ptr  *address_list		// (0x0 = disabled)
	;  long size
	;  word num_address_lines
	;  word mask
	;  byte base_ec
	;  byte flags
	; };

	rsreset
s_mt_start_address	rs.l 1
s_mt_address_list	rs.l 1
s_mt_size		rs.l 1
s_mt_num_address_lines	rs.w 1
s_mt_mask		rs.w 1
s_mt_base_ec		rs.b 1
s_mt_flags		rs.b 1
s_mt_struct_size	rs.b 0

	macro MT_PARAMS
		dc.l \1, \2, \3
		dc.w \4, \5
		dc.b \6, \7
	endm

MT_ERROR_ADDRESS_BASE	equ $0
MT_ERROR_DATA_BASE	equ $1
MT_ERROR_MARCH_BASE	equ $4
MT_ERROR_OUTPUT_BASE	equ $7
MT_ERROR_WRITE_BASE	equ $a

MT_NULL_ADDRESS_LIST	equ $0

MT_FLAG_NONE		equ $00
MT_FLAG_LOWER_ONLY	equ $01
