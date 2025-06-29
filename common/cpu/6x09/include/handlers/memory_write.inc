
	rsreset
s_mw_num_bytes		rs.b 1
s_mw_buffer_ptr		rs.w 1
s_mw_highlight_cb	rs.w 1
s_mw_write_memory_cb	rs.w 1
s_mw_loop_cb		rs.w 1
s_mw_struct_size	rs.b 0

	; struct mw_settings {
	;  byte num_bytes;
	;  word buffer_ptr;
	;  word highlight_cb;
	;  word write_memory_cb;
	;  word loop_cb;
	; }
	macro MW_SETTINGS
		dc.b \1
		dc.w \2, \3, \4, \5
	endm

