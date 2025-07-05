
	rsreset
s_mw_num_bytes		rs.b 1
s_mw_padding		rs.b 1
s_mw_buffer_ptr		rs.l 1
s_mw_highlight_cb	rs.l 1
s_mw_write_memory_cb	rs.l 1
s_mw_loop_cb		rs.l 1
s_mw_struct_size	rs.b 0

	; struct mw_settings {
	;  byte num_bytes;
	;  byte padding;
	;  long buffer_ptr;
	;  long highlight_cb;
	;  long write_memory_cb;
	;  long loop_cb;
	; }
	macro MW_SETTINGS
		dc.b \1, $0
		dc.l \2, \3, \4, \5
	endm

