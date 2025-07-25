	rsreset
s_ves_value_changed_cb	rs.l 1
s_ves_loop_input_cb	rs.l 1
s_ves_struct_size	rs.b 0

	; struct ve_settings {
	;  long value_changed_cb;
	;  long loop_input_cb;
	; }
	macro VE_SETTINGS
		dc.l \1, \2
	endm


	rsreset
s_vee_type		rs.b 1
s_vee_input		rs.b 1
s_vee_address		rs.l 1
s_vee_mask		rs.w 1
s_vee_struct_size	rs.b 0

	; struct ve_entry {
	;  byte type;
	;  byte input;
	;  long address;
	;  word mask;
	; }

	macro VE_ENTRY
		dc.b \1, \2
		dc.l \3
		dc.w \4
	endm

	macro VE_LIST_END
		dc.w $ffff
	endm

; The type of data at s_vee_address.  These also
; get used for print offsets so the data is all
; right aligned
VE_TYPE_NIBBLE		equ $3
VE_TYPE_BYTE		equ $2
VE_TYPE_WORD		equ $0

; if input comes from r_input_edge or r_input_raw
VE_INPUT_EDGE		equ $0
VE_INPUT_RAW		equ $1
